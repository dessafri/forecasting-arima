@echo off
TITLE Nutricast - Full Stack Runner & Dependency Guard (Windows)
COLOR 0A

:: ========================================================
:: [GUARD 0] KUNCI DIREKTORI KERJA SCRIPT
:: ========================================================
cd /d "%~dp0"

echo ========================================================
echo    NUTRICAST: SISTEM PERAMALAN ^& OPTIMASI PMT STUNTING
echo    Full-Stack Startup Manager ^& Dependency Guard (Windows)
echo ========================================================
echo.

:: ========================================================
:: [GUARD 1] INTEGRITAS STRUKTUR FOLDER PROYEK
:: ========================================================
echo [LANGKAH 1/5] Memeriksa Integritas Struktur Folder Proyek...
if not exist "backend\app.py" (
    echo [ERROR CRITICAL] File 'backend\app.py' tidak ditemukan!
    echo Pastikan Anda mengekstrak seluruh file proyek ke folder ini.
    echo.
    pause
    exit /b 1
)
if not exist "frontend\package.json" (
    echo [ERROR CRITICAL] File 'frontend\package.json' tidak ditemukan!
    echo Pastikan folder frontend tersedia lengkap.
    echo.
    pause
    exit /b 1
)
echo [OK] Struktur file proyek lengkap (backend dan frontend terdeteksi).
echo.

:: ========================================================
:: [GUARD 2] VALIDASI PYTHON, PIP, ^& MODUL VENV
:: ========================================================
echo [LANGKAH 2/5] Memeriksa Lingkungan Python, pip, ^& venv...

set PYTHON_CMD=python
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        set PYTHON_CMD=py
    ) else (
        echo [ERROR GUARD] Interpreter Python tidak ditemukan di PATH sistem Windows!
        echo Solusi:
        echo 1. Unduh Python versi 3.10, 3.11, atau 3.12 dari: https://www.python.org/downloads/
        echo 2. Jalankan installer, dan WAJIB centang opsi 'Add python.exe to PATH'.
        echo.
        pause
        exit /b 1
    )
)

echo [OK] Menggunakan perintah Python: %PYTHON_CMD%
for /f "tokens=*" %%v in ('%PYTHON_CMD% --version 2^>^&1') do echo [INFO] Versi Python: %%v

:: Cek versi Python minimal (>= 3.10)
%PYTHON_CMD% -c "import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Versi Python Anda terdeteksi di bawah 3.10. Disarankan Python 3.10+ untuk kestabilan dependensi.
)

:: Guard: Cek apakah modul 'venv' tersedia di Python sistem
echo [GUARD] Memeriksa ketersediaan modul venv di Python...
%PYTHON_CMD% -c "import venv" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR GUARD] Modul 'venv' tidak tersedia di instalasi Python Anda!
    echo Solusi: Buka Windows Apps/Features, pilih Modify Python, lalu pastikan 'Standard Library' dan 'pip' dicentang.
    echo.
    pause
    exit /b 1
)
echo [OK] Modul 'venv' terverifikasi aktif.

:: Guard: Cek apakah modul 'pip' tersedia di Python sistem
echo [GUARD] Memeriksa ketersediaan modul pip di Python...
%PYTHON_CMD% -m pip --version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] pip belum terkonfigurasi. Mencoba menjalankan ensurepip...
    %PYTHON_CMD% -m ensurepip --default-pip >nul 2>nul
    %PYTHON_CMD% -m pip --version >nul 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR GUARD] pip tidak dapat diaktifkan di Python ini.
        echo Harap instal ulang Python dan centang 'pip'.
        echo.
        pause
        exit /b 1
    )
)
for /f "tokens=*" %%p in ('%PYTHON_CMD% -m pip --version 2^>^&1') do echo [OK] pip terdeteksi: %%p
echo.

:: ========================================================
:: [GUARD 3] VALIDASI NODE.JS ^& NPM UNTUK FRONTEND
:: ========================================================
echo [LANGKAH 3/5] Memeriksa Lingkungan Node.js ^& npm...

where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR GUARD] Node.js tidak ditemukan di PATH sistem!
    echo Solusi:
    echo 1. Unduh dan pasang Node.js 18+ LTS dari: https://nodejs.org
    echo 2. Buka ulang terminal atau jalankan kembali run_app.bat setelah instalasi.
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%n in ('node --version 2^>^&1') do echo [OK] Node.js terdeteksi: %%n

where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR GUARD] npm tidak ditemukan di PATH sistem!
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%m in ('npm --version 2^>^&1') do echo [OK] npm terdeteksi: v%%m
echo.

:: ========================================================
:: [GUARD 4] MANAJEMEN VIRTUAL ENVIRONMENT ^& DEPENDENSI BACKEND
:: ========================================================
echo [LANGKAH 4/5] Menyiapkan Virtual Environment ^& Memeriksa Dependensi Backend...

:: Cek apakah folder venv ada tapi bukan format Windows (misal bekas copy dari macOS)
if exist "backend\venv" (
    if not exist "backend\venv\Scripts\python.exe" (
        echo [GUARD] Mendeteksi folder backend\venv dari format non-Windows. Membersihkan...
        rd /s /q "backend\venv" 2>nul
    )
)

:: Buat virtual environment jika belum ada
if not exist "backend\venv\Scripts\python.exe" (
    echo [WAIT] Membuat virtual environment baru di 'backend\venv'...
    %PYTHON_CMD% -m venv backend\venv
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Gagal membuat virtual environment di folder backend\venv.
        pause
        exit /b 1
    )
    echo [OK] Virtual environment baru berhasil dibuat.
) else (
    echo [OK] Virtual environment backend\venv sudah tersedia.
)

:: Pastikan pip di dalam venv selalu mutakhir
"backend\venv\Scripts\python.exe" -m pip install --upgrade pip --quiet 2>nul

:: Cek apakah dependensi inti backend (flask, pandas, dll) sudah lengkap terpasang
echo [GUARD] Memverifikasi apakah paket inti Backend sudah terpasang...
"backend\venv\Scripts\python.exe" -c "import flask, flask_cors, pandas, numpy, openpyxl" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Seluruh modul inti Backend (Flask, CORS, Pandas, NumPy, OpenPyXL) telah terpasang dengan baik!
) else (
    echo [WAIT] Modul Backend belum lengkap. Memulai proses instalasi dependensi...
    if exist "backend\requirements.txt" (
        echo [INFO] Memasang dari backend\requirements.txt...
        "backend\venv\Scripts\python.exe" -m pip install -r "backend\requirements.txt"
    ) else if exist "requirements.txt" (
        echo [INFO] Memasang dari requirements.txt...
        "backend\venv\Scripts\python.exe" -m pip install -r "requirements.txt"
    )

    :: Validasi ulang setelah pip install
    "backend\venv\Scripts\python.exe" -c "import flask, flask_cors, pandas, numpy, openpyxl" 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo [FIX FALLBACK] Memasang paket inti secara langsung ke venv...
        "backend\venv\Scripts\python.exe" -m pip install flask flask-cors pandas numpy openpyxl
    )
    
    :: Verifikasi final
    "backend\venv\Scripts\python.exe" -c "import flask" 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR CRITICAL] Modul Flask tetap tidak dapat dimuat!
        echo Periksa koneksi internet atau hak akses folder Anda.
        pause
        exit /b 1
    )
    echo [OK] Instalasi dependensi Backend berhasil diverifikasi!
)

:: Cek status database SQLite
if not exist "backend\forecasting.db" (
    echo [WAIT] Database 'forecasting.db' belum ditemukan. Menginisialisasi dari Excel...
    cd /d "%~dp0backend"
    "venv\Scripts\python.exe" init_db.py
    cd /d "%~dp0"
    echo [OK] Database berhasil diinisialisasi.
) else (
    echo [OK] Database SQLite 'forecasting.db' siap digunakan.
)
echo.

:: ========================================================
:: [GUARD 5] SETUP DEPENDENSI FRONTEND (NPM)
:: ========================================================
echo [LANGKAH 5/5] Memeriksa Dependensi Frontend (Vue 3 + Vite)...

if not exist "frontend\node_modules" (
    echo [WAIT] Folder 'node_modules' belum ada. Memasang package npm frontend...
    cd /d "%~dp0frontend"
    call npm install
    cd /d "%~dp0"
    echo [OK] Package frontend berhasil dipasang.
) else (
    echo [OK] Folder frontend\node_modules sudah tersedia.
)
echo.

:: ========================================================
:: PELUNCURAN SERVER & BROWSER
:: ========================================================
echo ========================================================
echo [BERHASIL] Seluruh Guard ^& Dependensi Terverifikasi!
echo.
echo Meluncurkan Server Nutricast:
echo  1. Backend API Server : http://127.0.0.1:5001
echo  2. Frontend Web App   : http://localhost:5173
echo ========================================================
echo.

:: Jalankan Backend API Server di CMD window terpisah
start "Nutricast Backend Server (Port 5001)" /d "%~dp0backend" cmd /k "title Nutricast Backend API && call venv\Scripts\activate.bat && venv\Scripts\python.exe app.py"

:: Jalankan Frontend Vite Dev Server di CMD window terpisah
start "Nutricast Frontend (Port 5173)" /d "%~dp0frontend" cmd /k "title Nutricast Frontend Web && npm run dev"

echo Membuka aplikasi di browser default dalam 4 detik...
timeout /t 4 /nobreak >nul
start http://localhost:5173

echo.
echo ========================================================
echo Aplikasi Nutricast aktif dan berjalan!
echo Catatan: Jendela Command Prompt Backend dan Frontend
echo         jangan ditutup selama aplikasi digunakan.
echo ========================================================
timeout /t 6 >nul
