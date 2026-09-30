import unittest
import json
import io
import os
import sys
import tempfile
import sqlite3
import pandas as pd

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import app as flask_app

class TestFlaskAPI(unittest.TestCase):
    def setUp(self):
        flask_app.app.config['TESTING'] = True
        self.client = flask_app.app.test_client()
        
        # Create a temp DB for testing
        self.db_fd, self.db_path = tempfile.mkstemp()
        flask_app.DB_PATH = self.db_path
        
        # Init schema
        conn = sqlite3.connect(self.db_path)
        conn.execute('''
            CREATE TABLE IF NOT EXISTS harga_pangan (
                Tanggal TEXT,
                Beras REAL,
                Telur_Ayam REAL,
                Daging_Ayam REAL
            )
        ''')
        conn.execute('''
            CREATE TABLE IF NOT EXISTS tkpi (
                Kode TEXT,
                Nama_Bahan TEXT,
                Energi_kkal REAL,
                Protein_g REAL,
                Lemak_g REAL,
                KH_g REAL
            )
        ''')
        conn.execute('''
            CREATE TABLE IF NOT EXISTS akg (
                Kelompok_Umur TEXT,
                Energi_kkal REAL,
                Protein_g REAL,
                Lemak_g REAL,
                KH_g REAL
            )
        ''')
        conn.execute('''
            CREATE TABLE IF NOT EXISTS hasil_forecast (
                Tanggal TEXT,
                Beras REAL,
                Telur_Ayam REAL,
                Daging_Ayam REAL
            )
        ''')
        conn.commit()
        conn.close()

    def tearDown(self):
        os.close(self.db_fd)
        if os.path.exists(self.db_path):
            os.unlink(self.db_path)

    def test_health_check(self):
        res = self.client.get('/api/health')
        self.assertEqual(res.status_code, 200)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'Online')

    def test_get_stats_empty_db(self):
        res = self.client.get('/api/data/stats')
        self.assertEqual(res.status_code, 200)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'success')
        self.assertEqual(data['stats'], [])
        self.assertEqual(data['commodities'], [])

    def test_get_dashboard_summary_empty_db(self):
        res = self.client.get('/api/dashboard/summary')
        self.assertEqual(res.status_code, 200)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'success')
        self.assertFalse(data['has_data'])
        self.assertEqual(data['commodities'], [])
        self.assertEqual(data['chart_series'], [])

    def test_get_data_endpoints(self):
        # Insert sample rows
        conn = sqlite3.connect(self.db_path)
        conn.execute("INSERT INTO harga_pangan VALUES ('2024-01-01', 14500, 28000, 36000)")
        conn.execute("INSERT INTO tkpi VALUES ('B01', 'Beras', 360, 7.0, 0.5, 80)")
        conn.execute("INSERT INTO akg VALUES ('Balita', 1350, 20.0, 45.0, 215)")
        conn.commit()
        conn.close()

        # Test harga pangan endpoint
        res = self.client.get('/api/data/harga_pangan')
        self.assertEqual(res.status_code, 200)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'success')
        self.assertEqual(len(data['data']), 1)

        # Test tkpi endpoint
        res = self.client.get('/api/data/tkpi')
        self.assertEqual(res.status_code, 200)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'success')
        self.assertEqual(len(data['data']), 1)

        # Test akg endpoint
        res = self.client.get('/api/data/akg')
        self.assertEqual(res.status_code, 200)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'success')
        self.assertEqual(len(data['data']), 1)

    def test_upload_no_file(self):
        res = self.client.post('/api/upload')
        self.assertEqual(res.status_code, 400)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'error')

    def test_upload_valid_excel(self):
        # Create an in-memory excel file with 3 sheets
        output = io.BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df_harga = pd.DataFrame({
                'Tanggal': ['2024-01-01', '2024-01-02', '2024-01-03'],
                'Beras Premium': [14000, 14200, 14300],
                'Daging Ayam': [35000, 36000, 35500]
            })
            df_harga.to_excel(writer, sheet_name='01_Harga_Pangan', index=False)

            df_tkpi = pd.DataFrame({
                'Kode': ['B01', 'A01'],
                'Nama_Bahan': ['Beras', 'Ayam'],
                'Energi': [360, 250],
                'Protein': [7.0, 27.0]
            })
            df_tkpi.to_excel(writer, sheet_name='02_TKPI', index=False)

            df_akg = pd.DataFrame({
                'Kelompok': ['Balita 1-3 th'],
                'Energi': [1350],
                'Protein': [20.0]
            })
            df_akg.to_excel(writer, sheet_name='03_AKG', index=False)

        output.seek(0)
        data = {
            'file': (output, 'dataset_test.xlsx')
        }
        res = self.client.post('/api/upload', content_type='multipart/form-data', data=data)
        self.assertEqual(res.status_code, 200)
        json_data = json.loads(res.data)
        self.assertEqual(json_data['status'], 'success')
        self.assertEqual(json_data['total_rows_harga'], 3)
        self.assertIn('Beras Premium', json_data['commodities'])

    def test_dashboard_summary_with_data(self):
        # Insert time-series rows
        conn = sqlite3.connect(self.db_path)
        for i in range(1, 15):
            conn.execute(
                f"INSERT INTO harga_pangan VALUES ('2024-01-{i:02d}', {14000 + i*50}, {28000 - i*100}, {35000 + i*20})"
            )
        conn.commit()
        conn.close()

        res = self.client.get('/api/dashboard/summary')
        self.assertEqual(res.status_code, 200)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'success')
        self.assertTrue(data['has_data'])
        self.assertGreater(len(data['commodities']), 0)
        self.assertGreater(len(data['chart_series']), 0)
        self.assertIn('total_komoditas', data['kpi'])

    def test_gwo_and_forecast_endpoints(self):
        # Test Forecast endpoint
        res = self.client.post('/api/forecast', json={'steps': 30})
        self.assertEqual(res.status_code, 200)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'success')

        # Test GWO run endpoint
        res = self.client.post('/api/gwo', json={'pack_size': 50, 'max_iter': 300})
        self.assertEqual(res.status_code, 200)
        data = json.loads(res.data)
        self.assertEqual(data['status'], 'success')

if __name__ == '__main__':
    unittest.main()
