@echo off
TITLE Nutricast - Full Stack Runner (Windows)
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
:: [LANGKAH 1/5] INTEGRITAS STRUKTUR FOLDER PROYEK
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
:: [LANGKAH 2/5] VALIDASI PYTHON, PIP, ^& MODUL VENV
:: ========================================================
echo [LANGKAH 2/5] Memeriksa Lingkungan Python ^& pip...

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

:: Cek ketersediaan pip di Python sistem
%PYTHON_CMD% -m pip --version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Mengaktifkan modul pip bawaan...
    %PYTHON_CMD% -m ensurepip --default-pip >nul 2>nul
)
for /f "tokens=*" %%p in ('%PYTHON_CMD% -m pip --version 2^>^&1') do echo [OK] pip terdeteksi: %%p
echo.

:: ========================================================
:: [LANGKAH 3/5] VALIDASI NODE.JS ^& NPM UNTUK FRONTEND
:: ========================================================
echo [LANGKAH 3/5] Memeriksa Lingkungan Node.js ^& npm...

where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR GUARD] Node.js tidak ditemukan di PATH sistem!
    echo Solusi:
    echo 1. Unduh dan pasang Node.js 18+ LTS dari: https://nodejs.org
    echo 2. Jalankan kembali run_app.bat setelah instalasi.
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
:: [LANGKAH 4/5] MANAJEMEN PYTHON INTERPRETER ^& DEPENDENSI BACKEND
:: ========================================================
echo [LANGKAH 4/5] Menyiapkan Lingkungan Backend ^& Dependensi Python...

:: Periksa apakah folder venv ada tapi bukan format Windows (misal bekas salinan macOS)
if exist "backend\venv" (
    if not exist "backend\venv\Scripts\python.exe" (
        echo [INFO] Menghapus cache virtual environment non-Windows...
        rd /s /q "backend\venv" 2>nul
    )
)

:: Coba buat virtual environment jika belum ada
if not exist "backend\venv\Scripts\python.exe" (
    echo [WAIT] Mencoba membuat Python Virtual Environment di 'backend\venv'...
    %PYTHON_CMD% -m venv backend\venv 2>nul
)

:: Tentukan interpreter yang aktif (Gunakan venv jika ada, fallback ke sistem Python jika venv gagal)
set "ACTIVE_PY="
if exist "backend\venv\Scripts\python.exe" (
    set "ACTIVE_PY=%~dp0backend\venv\Scripts\python.exe"
    echo [OK] Menggunakan Virtual Environment: backend\venv
) else (
    set "ACTIVE_PY=%PYTHON_CMD%"
    echo [INFO] Menggunakan Python Sistem (%PYTHON_CMD%) langsung sebagai interpreter Backend.
)

:: Cek apakah dependensi utama (Flask, CORS, Pandas, NumPy, OpenPyXL) sudah terpasang
echo [GUARD] Memverifikasi dependensi modul Backend...
"%ACTIVE_PY%" -c "import flask, flask_cors, pandas, numpy, openpyxl" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Seluruh modul inti Backend (Flask, CORS, Pandas, NumPy, OpenPyXL) sudah siap!
) else (
    echo [WAIT] Memasang modul backend yang diperlukan (Flask, Pandas, NumPy, OpenPyXL)...
    
    :: Coba pasang menggunakan requirements.txt
    if exist "backend\requirements.txt" (
        "%ACTIVE_PY%" -m pip install -r "backend\requirements.txt" --no-warn-script-location
    ) else if exist "requirements.txt" (
        "%ACTIVE_PY%" -m pip install -r "requirements.txt" --no-warn-script-location
    )
    
    :: Jika masih belum lengkap, lakukan instalasi langsung (direct install)
    "%ACTIVE_PY%" -c "import flask, flask_cors, pandas, numpy, openpyxl" 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo [WAIT] Melakukan instalasi langsung paket inti...
        "%ACTIVE_PY%" -m pip install flask flask-cors pandas numpy openpyxl --no-warn-script-location
    )
    
    :: Verifikasi akhir Flask
    "%ACTIVE_PY%" -c "import flask" 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo [OK] Dependensi Backend berhasil diverifikasi!
    ) else (
        echo [PERINGATAN] Flask belum terpasang sempurna pada interpreter saat ini.
        echo Mencoba memasang ke Python global sebagai alternatif...
        %PYTHON_CMD% -m pip install flask flask-cors pandas numpy openpyxl --no-warn-script-location 2>nul
        set "ACTIVE_PY=%PYTHON_CMD%"
    )
)

:: Inisialisasi Database SQLite jika belum ada
if not exist "backend\forecasting.db" (
    echo [WAIT] Menginisialisasi Database SQLite awal (forecasting.db)...
    cd /d "%~dp0backend"
    "%ACTIVE_PY%" init_db.py
    cd /d "%~dp0"
    echo [OK] Database berhasil diinisialisasi.
) else (
    echo [OK] Database SQLite 'forecasting.db' siap digunakan.
)
echo.

:: ========================================================
:: [LANGKAH 5/5] SETUP DEPENDENSI FRONTEND (NPM)
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
echo [BERHASIL] Seluruh Guard ^& Dependensi Selesai Disiapkan!
echo.
echo Meluncurkan Server Nutricast:
echo  1. Backend API Server : http://127.0.0.1:5001
echo  2. Frontend Web App   : http://localhost:5173
echo ========================================================
echo.

:: Jalankan Backend API Server di CMD window terpisah
start "Nutricast Backend Server (Port 5001)" /d "%~dp0backend" cmd /k "title Nutricast Backend API && \"%ACTIVE_PY%\" app.py"

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
