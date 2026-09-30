import sqlite3
import pandas as pd
import os

db_path = os.path.join(os.path.dirname(__file__), 'forecasting.db')
excel_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'Data Tanpa susu.xlsx')

def init_db():
    conn = sqlite3.connect(db_path)
    print(f"Reading {excel_path}...")
    xls = pd.ExcelFile(excel_path)
    sheets = xls.sheet_names

    # 1. Sheet 1: Harga Komoditas / Pangan
    sheet1_candidates = [s for s in sheets if 'harga' in s.lower()]
    sheet1 = sheet1_candidates[0] if sheet1_candidates else sheets[0]
    df_harga = pd.read_excel(xls, sheet_name=sheet1)
    if 'Tanggal' in df_harga.columns:
        df_harga['Tanggal'] = pd.to_datetime(df_harga['Tanggal']).dt.strftime('%Y-%m-%d')
    df_harga.to_sql('harga_pangan', conn, if_exists='replace', index=False)
    print(f"Loaded {len(df_harga)} rows into 'harga_pangan' from sheet '{sheet1}'.")

    # 2. Sheet 2: TKPI
    sheet2_candidates = [s for s in sheets if 'tkpi' in s.lower()]
    sheet2 = sheet2_candidates[0] if sheet2_candidates else (sheets[1] if len(sheets) > 1 else None)
    if sheet2:
        df_tkpi = pd.read_excel(xls, sheet_name=sheet2)
        df_tkpi.to_sql('tkpi', conn, if_exists='replace', index=False)
        print(f"Loaded {len(df_tkpi)} rows into 'tkpi' from sheet '{sheet2}'.")

    # 3. Sheet 3: AKG
    sheet3_candidates = [s for s in sheets if 'akg' in s.lower()]
    sheet3 = sheet3_candidates[0] if sheet3_candidates else (sheets[2] if len(sheets) > 2 else None)
    if sheet3:
        df_akg = pd.read_excel(xls, sheet_name=sheet3)
        df_akg.to_sql('akg', conn, if_exists='replace', index=False)
        print(f"Loaded {len(df_akg)} rows into 'akg' from sheet '{sheet3}'.")

    conn.commit()
    conn.close()
    print("Database initialized successfully with 3 sheets.")

if __name__ == '__main__':
    init_db()
