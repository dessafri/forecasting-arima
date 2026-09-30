import unittest
import pandas as pd
import numpy as np
import sys
import os

# Add parent directory to path to import app
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from app import compute_stats_from_df

class TestStatsComputation(unittest.TestCase):
    def test_compute_stats_empty_df(self):
        df_empty = pd.DataFrame()
        stats, cols = compute_stats_from_df(df_empty)
        self.assertEqual(stats, [])
        self.assertEqual(cols, [])

    def test_compute_stats_df_with_non_numeric_only(self):
        df = pd.DataFrame({"Tanggal": ["2024-01-01", "2024-01-02", "2024-01-03"]})
        stats, cols = compute_stats_from_df(df)
        self.assertEqual(stats, [])
        self.assertEqual(cols, [])

    def test_compute_stats_valid_numeric_df(self):
        df = pd.DataFrame({
            "Tanggal": ["2024-01-01", "2024-01-02", "2024-01-03", "2024-01-04"],
            "Beras": [14000.0, 14200.0, 14400.0, 14600.0],
            "Telur": [28000.0, 28000.0, 28000.0, 28000.0]
        })
        stats, cols = compute_stats_from_df(df)
        self.assertEqual(len(cols), 2)
        self.assertIn("Beras", cols)
        self.assertIn("Telur", cols)
        
        beras_stat = next(s for s in stats if s["komoditas"] == "Beras")
        self.assertEqual(beras_stat["n"], 4)
        self.assertEqual(beras_stat["mean"], 14300.0)
        self.assertEqual(beras_stat["min"], 14000.0)
        self.assertEqual(beras_stat["max"], 14600.0)
        self.assertGreater(beras_stat["cv"], 0)

        telur_stat = next(s for s in stats if s["komoditas"] == "Telur")
        self.assertEqual(telur_stat["mean"], 28000.0)
        self.assertEqual(telur_stat["std"], 0.0)
        self.assertEqual(telur_stat["cv"], 0.0)

    def test_compute_stats_with_nan_values(self):
        df = pd.DataFrame({
            "Beras": [14000.0, np.nan, 16000.0]
        })
        stats, cols = compute_stats_from_df(df)
        self.assertEqual(len(stats), 1)
        self.assertEqual(stats[0]["n"], 2)
        self.assertEqual(stats[0]["mean"], 15000.0)

if __name__ == '__main__':
    unittest.main()
