import sqlite3
import pandas as pd
import os

db_path = os.path.join(os.path.dirname(__file__), 'forecasting.db')
excel_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'Data Tanpa susu.xlsx')
sql_dump_path = os.path.join(os.path.dirname(__file__), 'schema.sql')

def init_db():
    conn = sqlite3.connect(db_path)
    print(f"Reading {excel_path}...")
    xls = pd.ExcelFile(excel_path)
    sheets = xls.sheet_names

    sheet_mapping = {
        'harga': 'harga_pangan',
        'tkpi': 'tkpi',
        'menu': 'menu_pmt',
        'akg': 'akg',
        'hasil_forecast': 'hasil_forecast',
        'evaluasi': 'evaluasi_forecast',
        'gwo': 'gwo_params'
    }

    for s in sheets:
        s_lower = s.lower()
        target_table = None
        for key, table in sheet_mapping.items():
            if key in s_lower:
                target_table = table
                break
        
        if target_table:
            df = pd.read_excel(xls, sheet_name=s)
            if 'Tanggal' in df.columns:
                df['Tanggal'] = pd.to_datetime(df['Tanggal']).dt.strftime('%Y-%m-%d')
            if 'Unnamed: 0' in df.columns:
                df = df.drop(columns=['Unnamed: 0'])
            df.to_sql(target_table, conn, if_exists='replace', index=False)
            print(f"Loaded {len(df)} rows into '{target_table}' from sheet '{s}'.")

    conn.commit()
    
    # Export full SQL dump for easy restoration
    with open(sql_dump_path, 'w', encoding='utf-8') as f:
        for line in conn.iterdump():
            f.write(f"{line}\n")
    print(f"Exported schema & data dump to {sql_dump_path}")

    conn.close()
    print("Database initialized successfully.")

if __name__ == '__main__':
    init_db()

