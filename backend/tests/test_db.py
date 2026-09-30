import unittest
import sqlite3
import os
import tempfile
import pandas as pd

class TestDatabase(unittest.TestCase):
    def setUp(self):
        # Create a temporary SQLite database for testing
        self.db_fd, self.db_path = tempfile.mkstemp()
        self.conn = sqlite3.connect(self.db_path)
        
        # Initialize schema
        self.conn.execute('''
            CREATE TABLE harga_pangan (
                Tanggal TEXT,
                Beras REAL,
                Telur_Ayam REAL,
                Daging_Ayam REAL,
                Ikan_Kembung REAL
            )
        ''')
        self.conn.execute('''
            CREATE TABLE tkpi (
                Kode TEXT,
                Nama_Bahan TEXT,
                Energi_kkal REAL,
                Protein_g REAL,
                Lemak_g REAL,
                KH_g REAL
            )
        ''')
        self.conn.execute('''
            CREATE TABLE akg (
                Kelompok_Umur TEXT,
                Energi_kkal REAL,
                Protein_g REAL,
                Lemak_g REAL,
                KH_g REAL
            )
        ''')
        self.conn.commit()

    def tearDown(self):
        self.conn.close()
        os.close(self.db_fd)
        os.unlink(self.db_path)

    def test_empty_database_query(self):
        cursor = self.conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM harga_pangan")
        count = cursor.fetchone()[0]
        self.assertEqual(count, 0)

    def test_insert_and_retrieve_harga_pangan(self):
        cursor = self.conn.cursor()
        cursor.execute(
            "INSERT INTO harga_pangan (Tanggal, Beras, Telur_Ayam, Daging_Ayam, Ikan_Kembung) VALUES (?, ?, ?, ?, ?)",
            ("2024-01-01", 14500.0, 28000.0, 36000.0, 38000.0)
        )
        self.conn.commit()
        
        cursor.execute("SELECT * FROM harga_pangan WHERE Tanggal = '2024-01-01'")
        row = cursor.fetchone()
        self.assertIsNotNone(row)
        self.assertEqual(row[0], "2024-01-01")
        self.assertEqual(row[1], 14500.0)

    def test_insert_and_retrieve_tkpi(self):
        cursor = self.conn.cursor()
        cursor.execute(
            "INSERT INTO tkpi (Kode, Nama_Bahan, Energi_kkal, Protein_g, Lemak_g, KH_g) VALUES (?, ?, ?, ?, ?, ?)",
            ("B01", "Beras Premium", 360.0, 7.0, 0.5, 80.0)
        )
        self.conn.commit()
        
        cursor.execute("SELECT Nama_Bahan, Protein_g FROM tkpi WHERE Kode = 'B01'")
        row = cursor.fetchone()
        self.assertEqual(row[0], "Beras Premium")
        self.assertEqual(row[1], 7.0)

    def test_insert_and_retrieve_akg(self):
        cursor = self.conn.cursor()
        cursor.execute(
            "INSERT INTO akg (Kelompok_Umur, Energi_kkal, Protein_g, Lemak_g, KH_g) VALUES (?, ?, ?, ?, ?)",
            ("Balita 1-3 th", 1350.0, 20.0, 45.0, 215.0)
        )
        self.conn.commit()
        
        cursor.execute("SELECT Kelompok_Umur, Energi_kkal FROM akg WHERE Kelompok_Umur = 'Balita 1-3 th'")
        row = cursor.fetchone()
        self.assertEqual(row[0], "Balita 1-3 th")
        self.assertEqual(row[1], 1350.0)

if __name__ == '__main__':
    unittest.main()
