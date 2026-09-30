# Nutricast: Sistem Peramalan Harga Pangan & Optimasi Menu Nutrisi Pencegahan Stunting (ARIMA - FPR - GWO)

[![Vue 3](https://img.shields.io/badge/Vue-3.5-4FC08D?style=flat&logo=vue.js&logoColor=white)](https://vuejs.org/)
[![Vite](https://img.shields.io/badge/Vite-6.0-646CFF?style=flat&logo=vite&logoColor=white)](https://vitejs.dev/)
[![Tailwind CSS](https://img.shields.io/badge/TailwindCSS-3.4-38B2AC?style=flat&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-3.1-000000?style=flat&logo=flask&logoColor=white)](https://flask.palletsprojects.com/)
[![Vitest](https://img.shields.io/badge/Vitest-Passed%20(22%2F22)-729B1B?style=flat&logo=vitest&logoColor=white)](https://vitest.dev/)
[![Windows](https://img.shields.io/badge/OS-Windows%2010%2F11-0078D6?style=flat&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![macOS](https://img.shields.io/badge/OS-macOS-000000?style=flat&logo=apple&logoColor=white)](https://www.apple.com/macos)
[![Linux](https://img.shields.io/badge/OS-Linux-FCC624?style=flat&logo=linux&logoColor=black)](https://www.kernel.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 📖 1. Ringkasan Proyek
**Nutricast** adalah platform analitik prediktif dan optimasi formulasi menu makanan gizi balita berbasis kecerdasan komputasional. Sistem dirancang khusus untuk membantu perencana gizi posyandu/puskesmas serta dinas ketahanan pangan dalam merancang menu **Pemberian Makanan Tambahan (PMT)** pencegahan stunting balita dengan biaya termurah (*cost-efficient*) dan standar Angka Kecukupan Gizi (AKG) optimal.

Sistem mengintegrasikan 3 pilar analitik utama:
1. **Time Series Forecasting (Auto-ARIMA)**: Proyeksi tren harga harian 8 komoditas pangan pokok 30 hari ke depan dilengkapi batas keyakinan 95% (*95% Confidence Interval*).
2. **Financial Pattern Recognition (FPR)**: Analisis logaritmik return dan volatilitas pergerakan harga untuk mengklasifikasi tren pasar (*Bullish*, *Bearish*, *Stabil/Sideways*).
3. **Multi-Objective Grey Wolf Optimizer (GWO)**:
   - **Tahap 1**: Pembobotan multi-kriteria kognitif dan perankingan prioritas 8 komoditas pangan pokok.
   - **Tahap 2**: Formulasi gramatur porsi menu ($0\text{ g} \le X_i \le 300\text{ g}$) dengan fungsi objektif minimasi biaya harian + penalti deviasi target nutrisi balita (Energi 1350 kkal, Protein 20g, Lemak 45g, Karbohidrat 215g).

---

## 🛠️ 2. Prasyarat & Panduan Instalasi Tools (Windows & macOS / Linux)

Sebelum menjalankan aplikasi, pastikan komputer Anda telah terpasang **Git**, **Node.js (dengan npm)**, dan **Python**. Pilih panduan instalasi sesuai sistem operasi Anda:

---

### A. Panduan Instalasi di WINDOWS (10 / 11)

#### 1. Instalasi Git di Windows
1. Unduh installer resmi dari **[git-scm.com/download/win](https://git-scm.com/download/win)**.
2. Jalankan installer `.exe`, klik *Next* dengan pengaturan standar.
3. ⚠️ Pastikan mencentang opsi **"Git Bash Here"** dan **"Git from the command line and also from 3rd-party software"**.
4. Verifikasi di Command Prompt / PowerShell:
   ```cmd
   git --version
   ```

#### 2. Instalasi Node.js & npm di Windows
- **Cara 1 (Mudah - Installer Resmi)**:
  1. Kunjungi situs resmi **[nodejs.org](https://nodejs.org/)**.
  2. Unduh versi **LTS (Long Term Support)** terbaru (misal `v20.x.x` atau `v22.x.x`).
  3. Jalankan file `.msi` hingga selesai (*Next -> Next -> Install*).
- **Cara 2 (Via Winget Package Manager)**:
  ```powershell
  winget install OpenJS.NodeJS.LTS
  ```
- **Verifikasi Instalasi di Windows**:
  ```cmd
  node -v
  npm -v
  ```

#### 3. Instalasi Python di Windows
1. Kunjungi **[python.org/downloads](https://www.python.org/downloads/)** dan unduh installer Python 3.11+.
2. Jalankan file installer `python-3.11.x-amd64.exe`.
3. ⚠️ **SANGAT PENTING**: Di jendela pertama instalasi, centang kotak **☑ "Add python.exe to PATH"** di bagian bawah sebelum mengklik *"Install Now"*.
4. Verifikasi di Command Prompt:
   ```cmd
   python --version
   pip --version
   ```

---

### B. Panduan Instalasi di macOS

#### 1. Instalasi Git di macOS
```bash
# Menggunakan Homebrew:
brew install git

# Atau install Command Line Tools Apple bawaan:
xcode-select --install
```

#### 2. Instalasi Node.js & npm di macOS
```bash
# Menggunakan Homebrew:
brew install node@20

# Atau menggunakan NVM:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install 20
nvm use 20
```

#### 3. Instalasi Python di macOS
```bash
brew install python@3.11
```

---

### C. Panduan Instalasi di Linux (Ubuntu / Debian)

```bash
# Update repository
sudo apt update && sudo apt upgrade -y

# 1. Install Git & Python
sudo apt install git python3 python3-pip python3-venv -y

# 2. Install Node.js 20 LTS (NodeSource)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

---

## 📥 3. Kloning Repositori dari GitHub

Buka terminal (**Command Prompt / PowerShell / Git Bash** di Windows, atau **Terminal** di Mac/Linux), arahkan ke folder yang Anda inginkan, lalu jalankan:

```bash
# Klon repositori
git clone https://github.com/<username>/forecasting-nutricast.git

# Masuk ke direktori repositori
cd forecasting-nutricast
```

---

## ⚡ 4. Cara Cepat: Menjalankan dengan Skrip 1-Klik (Runner Scripts)

Proyek ini telah dilengkapi dengan skrip otomatisasi untuk mempermudah eksekusi:

### 🪟 Pengguna Windows:
Cukup **klik ganda (double click)** pada file `run_app.bat` di dalam folder proyek, atau jalankan melalui Command Prompt:
```cmd
run_app.bat
```
*Skrip akan otomatis membuat virtual environment, memasang dependensi backend & frontend, menginisialisasi database, menjalankan kedua server, dan membuka browser di `http://localhost:5173`.*

### 🍎 Pengguna macOS / 🐧 Linux:
Buka Terminal, beri izin eksekusi lalu jalankan:
```bash
chmod +x run_app.sh
./run_app.sh
```

---

## 🚀 5. Panduan Manual Menjalankan Aplikasi (Step-by-Step)

Jika Anda ingin menjalankan backend dan frontend secara manual di terminal terpisah:

```
forecasting-nutricast/
├── backend/     # Python 3 + Flask + SQLite API Engine (Port 5001)
├── frontend/    # Vue 3 + Vite + Tailwind CSS UI (Port 5173)
└── uat/         # Dokumentasi Lengkap User Acceptance Testing (UAT)
```

---

### Langkah 1: Menjalankan Backend Server (Flask API)

#### Di WINDOWS (Command Prompt / PowerShell):
```cmd
:: 1. Masuk ke folder backend
cd backend

:: 2. Buat Python Virtual Environment
python -m venv venv

:: 3. Aktifkan Virtual Environment
:: Jika di Command Prompt:
venv\Scripts\activate
:: Jika di PowerShell:
venv\Scripts\Activate.ps1

:: 4. Pasang library backend
pip install --upgrade pip
pip install -r requirements.txt

:: 5. Inisialisasi Database SQLite
python init_db.py

:: 6. Jalankan Backend Server
python app.py
```

#### Di macOS / Linux (Terminal):
```bash
# 1. Masuk ke folder backend
cd backend

# 2. Buat Python Virtual Environment
python3 -m venv venv

# 3. Aktifkan Virtual Environment
source venv/bin/activate

# 4. Pasang library backend
pip install --upgrade pip
pip install -r requirements.txt

# 5. Inisialisasi Database SQLite
python init_db.py

# 6. Jalankan Backend Server
python app.py
```

> 🌐 **Backend API aktif pada**: `http://127.0.0.1:5001` (atau `http://localhost:5001`)

---

### Langkah 2: Menjalankan Frontend Web App (Vue 3 + Vite)

Buka jendela terminal baru (biarkan terminal backend tetap berjalan):

#### Di WINDOWS & macOS / Linux:
```bash
# 1. Masuk ke folder frontend
cd frontend

# 2. Pasang dependensi Node.js
npm install

# 3. Jalankan Vite Development Server
npm run dev
```

> 🚀 **Aplikasi Web aktif pada**: `http://localhost:5173`
> Buka browser Anda dan akses: **`http://localhost:5173`**

---

### Langkah 3: Menjalankan Unit Tests Frontend (Vitest)

```bash
cd frontend
npm test
```
*Seluruh 9 test file (22 unit test) berstatus: **PASS 100%**.*

---

### Langkah 4: Build Mode Produksi (Opsional)

```bash
cd frontend
npm run build
```
*Berkas hasil kompilasi siap hosting akan tersimpan di `frontend/dist/`.*

---

## 🗺️ 6. Peta Navigasi & Fitur Modul Aplikasi

| Modul | Rute URL | Fitur & Fungsi Utama |
|---|---|---|
| **Dashboard Utama** | `/ringkasan-dashboard-nutricast` (Alias: `/`, `/dashboard`) | Ringkasan 4 KPI eksekutif, grafik deret waktu multi-komoditas 30 hari forecast + CI 95%, dan status rekomendasi porsi PMT. |
| **Modul 1: Manajemen Dataset** | `/modul-1-manajemen-dataset-upload-excel` (Alias: `/modul1`) | Upload file Excel 3 Sheet (`Harga Pangan`, `TKPI 2020`, `AKG Standar`), validasi integritas kolom, imputasi waktu, dan statistik deskriptif. |
| **Modul 2: Forecasting ARIMA (P1)** | `/modul-2-forecasting-arima-evaluasi-nutricast-1` (Alias: `/modul2`) | Train:test split (70:30, 80:20, 90:10), Auto-ARIMA Grid Search, chart Split Horizon interaktif, dan ekspor konfigurasi JSON. |
| **Modul 2: Forecasting ARIMA (P2)** | `/modul-2-forecasting-arima-evaluasi-nutricast-2` (Alias: `/modul2_2`) | Validasi Walk-Forward 10-Fold Rolling Horizon, pengujian autokorelasi residual Ljung-Box (*White Noise*), dan tabel perbandingan model. |
| **Modul 3: Financial Pattern (FPR)** | `/modul-3-financial-pattern-fpr-nutricast` (Alias: `/modul3`) | Kalkulasi Daily Log Return & Volatilitas, klasifikasi tren (*Bullish*, *Bearish*, *Stabil*), dan sinkronisasi data ke GWO engine. |
| **Modul 4: Optimasi GWO** | `/modul-4-optimasi-gwo-nutricast` (Alias: `/modul4`) | Multi-Objective GWO Tahap 1 (Scoring) & Tahap 2 (Formulasi porsi menu balita vs target AKG), kurva konvergensi fitness, dan simpan preset. |
| **Modul 5: Menu PMT & Ekspor** | `/modul-5-menu-pmt-export-nutricast` (Alias: `/modul5`) | Tabel porsi gramatur optimal, Nutrition Compliance Gauge (AKG), ekspor rekapitulasi Excel (.xlsx), dan cetak lembar resep posyandu PDF. |
| **Evaluasi Diagnostik Model** | `/evaluasi-diagnostik-model-nutricast` (Alias: `/evaluasi`) | Validasi saintifik mendalam: ADF stationarity test, residual normalitas Shapiro-Wilk, Ljung-Box, dan unduh laporan ilmiah PDF. |

---

## 🧪 7. Dokumentasi User Acceptance Testing (UAT)

Skenario pengujian penerimaan pengguna (*User Acceptance Testing*) lengkap dengan total **132 Test Cases (70 Positif & 62 Negatif)** tersedia di direktori [`uat/`](uat/):

- 📘 [`uat/README.md`](uat/README.md) - Panduan umum, matriks traceability, dan standar pengujian.
- 📋 [`uat/TC_MODUL_1_MANAJEMEN_DATASET.md`](uat/TC_MODUL_1_MANAJEMEN_DATASET.md) - 20 Test Cases Ingesti Dataset & Imputasi.
- 📋 [`uat/TC_MODUL_2_FORECASTING_ARIMA.md`](uat/TC_MODUL_2_FORECASTING_ARIMA.md) - 20 Test Cases ARIMA, Split Horizon & Diagnostik.
- 📋 [`uat/TC_MODUL_3_FINANCIAL_PATTERN_FPR.md`](uat/TC_MODUL_3_FINANCIAL_PATTERN_FPR.md) - 17 Test Cases Return & Volatilitas FPR.
- 📋 [`uat/TC_MODUL_4_OPTIMASI_GWO.md`](uat/TC_MODUL_4_OPTIMASI_GWO.md) - 22 Test Cases Optimasi GWO Tahap 1 & 2.
- 📋 [`uat/TC_MODUL_5_MENU_PMT_EKSPOR.md`](uat/TC_MODUL_5_MENU_PMT_EKSPOR.md) - 17 Test Cases Menu PMT, Excel & PDF Export.
- 📋 [`uat/TC_DASHBOARD_DAN_EVALUASI_DIAGNOSTIK.md`](uat/TC_DASHBOARD_DAN_EVALUASI_DIAGNOSTIK.md) - 18 Test Cases Dashboard & Diagnostik.
- 📋 [`uat/TC_END_TO_END_DAN_SECURITY_NFR.md`](uat/TC_END_TO_END_DAN_SECURITY_NFR.md) - 18 Test Cases Alur E2E, NFR & Keamanan.

---

## 📡 8. Endpoint REST API Backend

| Endpoint | Method | Deskripsi |
|---|:---:|---|
| `/api/health` | `GET` | Memeriksa status kesehatan server backend (`{"status": "Online"}`). |
| `/api/dashboard/summary` | `GET` | Mengambil agregat KPI, data deret historis, peramalan 30 hari, dan porsi PMT. |
| `/api/data/stats` | `GET` | Mengambil ringkasan statistik deskriptif 8 komoditas (Mean, Std, Min, Max, CV). |
| `/api/data/harga_pangan` | `GET` | Mengambil data mentah harga pangan deret waktu harian. |
| `/api/data/tkpi` | `GET` | Mengambil data tabel komposisi gizi pangan TKPI 2020. |
| `/api/data/akg` | `GET` | Mengambil data standar AKG dan target PMT balita. |
| `/api/upload` | `POST` | Mengunggah berkas Excel (`.xlsx`) multipart untuk parsing & simpan ke database. |
| `/api/forecast` | `POST` | Memicu fitting Auto-ARIMA Grid Search untuk seluruh komoditas. |
| `/api/gwo` | `POST` | Memicu komputasi metaheuristik Multi-Objective Grey Wolf Optimizer. |

---

## 🛠️ 9. Panduan Pemecahan Masalah (Troubleshooting & FAQ)

1. **Q: (Windows PowerShell) Muncul error `File ... cannot be loaded because running scripts is disabled on this system`?**
   - **A**: Buka PowerShell sebagai Administrator dan jalankan perintah:
     ```powershell
     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
     ```
     Lalu coba aktifkan virtualenv kembali (`venv\Scripts\Activate.ps1`).

2. **Q: Muncul error `Gagal terhubung ke server` di browser?**
   - **A**: Pastikan terminal backend sedang berjalan di port `5001`. Cek apakah `http://127.0.0.1:5001/api/health` mengembalikan respon JSON `{"status": "Online"}`.

3. **Q: Terjadi `ModuleNotFoundError: No module named 'flask'` saat menjalankan backend?**
   - **A**: Pastikan Virtual Environment telah diaktifkan (`venv\Scripts\activate` di Windows atau `source venv/bin/activate` di macOS/Linux), lalu jalankan `pip install -r requirements.txt`.

4. **Q: Data di Dashboard kosong saat pertama kali dijalankan (*Cold Start*)?**
   - **A**: Buka terminal backend dan jalankan `python init_db.py`, atau buka menu **Modul 1: Manajemen Dataset** pada antarmuka web lalu unggah berkas `Data Tanpa susu.xlsx` yang ada di folder root proyek.

5. **Q: Perintah `python` atau `pip` tidak dikenali di Windows (*'python' is not recognized*)?**
   - **A**: Python belum ditambahkan ke System Environment Variables (PATH). Unduh ulang installer Python dari python.org, pilih *Modify*, dan centang opsi *"Add Python to environment variables"*.

---

## 📄 10. Lisensi & Kontribusi
Proyek ini dilisensikan di bawah [MIT License](LICENSE). Kontribusi terbuka melalui *Pull Requests* dan pelaporan *Issues* di GitHub.

---

© 2026 **Nutricast** - Inovasi Kecerdasan Komputasional untuk Pencegahan Stunting Balita Indonesia.
