# Product Requirements Document (PRD)
## Web App: Sistem Peramalan Harga Pangan & Optimasi Menu Nutrisi Pencegahan Stunting (ARIMA - FPR - GWO)

---

### 1. Ringkasan Eksekutif & Latar Belakang
Aplikasi web analitik prediktif dan optimasi gizi berbasis kecerdasan komputasional. Sistem mengintegrasikan:
1. **Time Series Forecasting (ARIMA)** untuk proyeksi tren harga 8 komoditas pangan pokok 30 hari ke depan.
2. **Financial Pattern Recognition (FPR)** untuk mengevaluasi return dan volatilitas pergerakan harga komoditas.
3. **Grey Wolf Optimizer (GWO) Multi-Objektif** untuk:
   - Pembobotan dan perankingan prioritas komoditas pangan.
   - Optimasi alokasi gramatur porsi menu makanan balita guna memenuhi Angka Kecukupan Gizi (AKG) pencegahan stunting dengan biaya termurah.

---

### 2. Sasaran Pengguna & User Persona
| Persona | Peran | Kebutuhan Utama |
|---|---|---|
| **Ahli Gizi / Petugas Puskesmas** | Perencana Menu PMT Balita | Menyusun porsi menu bergizi tinggi sesuai AKG dengan batasan biaya operasional. |
| **Dinas Ketahanan Pangan** | Analis Stabilitas Harga | Memantau fluktuasi, volatilitas, dan proyeksi tren harga komoditas strategis. |
| **Akademisi / Peneliti** | Evaluator Model | Melihat metrik evaluasi model (ADF, MAE, RMSE, MAPE, Rolling Fold, Uji Ljung-Box, Konvergensi GWO). |

---

### 3. Arsitektur Pipeline Data & Algoritma

```
┌────────────────────────┐
│  Upload Data (Excel)   │ ──► Sheet 01_Harga_Pangan & Sheet 02_TKPI
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ Preprocessing Data     │ ──► Wide-to-Long, Time Interpolation, Resampling Harian
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ Uji Stasioneritas ADF  │ ──► ADF Statistic, p-value, Lag, Status Stasioner
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ Model Fitting ARIMA    │ ──► Multi-split (70:30, 80:20, 90:10), Seleksi Best Order (p,d,q)
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ Validasi Model         │ ──► Walk-Forward Rolling Forecast (10-Fold), MAE, RMSE, MAPE
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ Forecast & Diagnostik  │ ──► Proyeksi 30 Hari, Uji Residual & Ljung-Box
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ Financial Pattern (FPR)│ ──► Daily Return, Volatilitas, Klasifikasi Tren Finansial
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ GWO Tahap 1: Ranking   │ ──► Optimasi Bobot (Harga, Return, Volatilitas) & Skor Prioritas
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ GWO Tahap 2: Menu PMT  │ ──► Formulasi Porsi (g) vs Biaya (Rp) vs Target AKG Balita
└───────────┬────────────┘
            │
            ▼
┌────────────────────────┐
│ Visualisasi & Export   │ ──► Dashboard Interaktif, Cetak Resep & Rekap Excel/PDF
└────────────────────────┘
```

---

### 4. Spesifikasi Fungsional (Feature Specifications)

#### Modul 1: Manajemen Dataset
- **F-101 (File Ingestion)**: Upload berkas Excel `.xlsx` / `.xls` dengan validasi otomatis nama sheet (`01_Harga_Pangan`, `02_TKPI`).
- **F-102 (Data Normalization)**: Otomatisasi konversi wide format ke long format, strip karakter mata uang, casting numerik.
- **F-103 (Handling Missing Values)**: Time-based interpolation (`ffill` dan `bfill`) untuk memastikan kontinuitas deret waktu harian.
- **F-104 (Statistik Deskriptif)**: Ringkasan data (Mean, Std Dev, Min, Max, Count) per komoditas:
  1. Beras Premium
  2. Daging Ayam Ras
  3. Telur Ayam Ras
  4. Ikan Kembung
  5. Wortel
  6. Kentang
  7. Buncis
  8. Daging Sapi

#### Modul 2: Forecasting & Evaluasi ARIMA
- **F-201 (Uji ADF)**: Pengujian stasioneritas dengan signifikansi alpha 5%.
- **F-202 (Eksplorasi Skenario Split)**: Komparasi performa split rasio 70:30, 80:20, dan 90:10.
- **F-203 (Model Selection)**: Identifikasi model ARIMA terbaik per komoditas berbasis minimasi MAPE.
- **F-204 (Walk-Forward Validation)**: Validasi rolling forecast 10-data horizon untuk mengukur kestabilan model.
- **F-205 (Proyeksi 30 Hari)**: Output estimasi harga harian untuk periode 30 hari ke depan.
- **F-206 (Diagnostik Residual)**: Visualisasi residual & pengujian autokorelasi Ljung-Box (memastikan residual bersifat white noise).

#### Modul 3: Financial Pattern Recognition (FPR)
- **F-301 (Return & Volatility Engine)**: Perhitungan return logaritmik/harian dan standar deviasi return (volatilitas) dari 30 hari forecast.
- **F-302 (Pola Klasifikasi)**: Deteksi pola tren komoditas (Bullish, Bearish, Sideways/Stabil) dipadukan dengan level risiko volatilitas.
- **F-303 (Status Validasi FPR)**: Verifikasi kelengkapan seluruh data komoditas sebelum masuk ke modul optimasi.

#### Modul 4: Optimasi Multi-Objektif Grey Wolf Optimizer (GWO)
- **F-401 (GWO Tahap 1 - Scoring Komoditas)**:
  - Optimasi bobot 3 kriteria ($w_{harga}, w_{return}, w_{volatilitas}$) dengan constraint $\sum w_i = 1$.
  - Normalisasi kriteria biaya (*cost*) vs kriteria manfaat (*benefit*).
  - Output peringkat prioritas komoditas (1 s.d. 8).
- **F-402 (GWO Tahap 2 - Optimasi Formulasi Menu)**:
  - Parameter default GWO: 50 Wolves, 300 Iterasi, 10 Runs.
  - Batasan porsi bahan: $0.0\text{ g} \le X_i \le 300.0\text{ g}$.
  - Target AKG Balita (Dapat disesuaikan):
    - Energi: 1350 kkal/hari
    - Protein: 20 gram/hari
    - Lemak: 45 gram/hari
    - Karbohidrat: 215 gram/hari
  - Objective Function: Minimasi total biaya menu harian + Penalty deviasi terhadap target nutrisi.
- **F-403 (GWO Convergence Visualizer)**: Grafik penurunan nilai fitness Alpha wolf per iterasi.

#### Modul 5: Rekomendasi Menu, Laporan & Ekspor
- **F-501 (Tabel Komposisi Menu)**: Rincian berat bahan (gram), kontribusi nutrisi per bahan, dan kalkulasi biaya porsi per anak/hari.
- **F-502 (Nutrition Compliance Gauge)**: Indikator persentase pemenuhan target AKG (Defisit / Pas / Surplus).
- **F-503 (Export Engine)**: Unduh dataset hasil forecast, skor GWO, dan formulasi menu dalam format Excel (`.xlsx`) dan ringkasan resep PDF.

---

### 5. Kebutuhan Non-Fungsional (NFR)
1. **Performance**: Komputasi GWO (10 run, 300 iterasi) harus diselesaikan di background worker (asynchronous) dengan polling status / websocket progress bar (Target runtime: < 15 detik).
2. **Reliability**: Validasi schema upload Excel ketat; parsing error tidak boleh menyebabkan crash server.
3. **Usability**: UI bersih, responsif pada desktop dan tablet petugas posyandu, visualisasi grafik interaktif (pan, zoom, hover tooltip).
4. **Reproducibility**: Parameter random seed pada GWO dan ARIMA tercatat agar hasil komputasi konsisten.

---

### 6. Rencana Arsitektur Teknologi
- **Backend API**: Python 3.11+ / FastAPI (eksekusi engine `statsmodels`, `pmdarima`, `numpy`, `pandas`).
- **Frontend App**: Next.js (App Router) + React + Tailwind CSS + Lucide Icons + Recharts / Chart.js.
- **Job Processing**: FastAPI BackgroundTasks / Redis Celery (untuk heavy iterative computation).
- **Database / Cache**: PostgreSQL / SQLite + Local Storage session state.
