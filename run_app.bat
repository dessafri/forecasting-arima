@echo off
TITLE Nutricast - Full Stack Runner (Windows)
COLOR 0A

:: 1. Kunci direktori kerja selalu ke folder lokasi run_app.bat
cd /d "%~dp0"

echo ========================================================
echo    NUTRICAST: SISTEM PERAMALAN ^& OPTIMASI PMT STUNTING
echo ========================================================
echo.

:: 2. Deteksi interpreter Python yang valid di sistem
set PYTHON_CMD=python
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        set PYTHON_CMD=py
    ) else (
        echo [ERROR] Python tidak ditemukan di PATH sistem Windows!
        echo Silakan unduh dan pasang Python 3.10 / 3.11 / 3.12 dari https://www.python.org
        echo PENTING: Beri tanda centang pada opsi 'Add Python to PATH' saat instalasi.
        echo.
        pause
        exit /b 1
    )
)

:: Tampilkan versi Python yang terdeteksi
echo [OK] Menggunakan interpreter: %PYTHON_CMD%
%PYTHON_CMD% --version

:: 3. Deteksi Node.js / npm
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js / npm tidak ditemukan di PATH sistem!
    echo Silakan unduh dan pasang Node.js LTS dari https://nodejs.org
    echo.
    pause
    exit /b 1
)

:: 4. Validasi dan Persiapan Python Virtual Environment
echo.
echo [1/3] Menyiapkan Backend Server Python...

:: Periksa apakah folder venv ada tapi rusak/bekas dari OS lain (misal dari macOS/Linux)
if exist "backend\venv" (
    if not exist "backend\venv\Scripts\python.exe" (
        echo [INFO] Mendeteksi virtual environment tidak kompatibel (format non-Windows). Menyiapkan ulang...
        rd /s /q "backend\venv" 2>nul
    )
)

:: Buat virtual environment jika belum ada
if not exist "backend\venv\Scripts\python.exe" (
    echo Membuat Python Virtual Environment di backend\venv...
    %PYTHON_CMD% -m venv backend\venv
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Gagal membuat virtual environment.
        pause
        exit /b 1
    )
)

:: 5. Instalasi dependensi ke dalam Virtual Environment
echo Memasang dan memperbarui dependensi Backend (Flask, Pandas, dll)...
"backend\venv\Scripts\python.exe" -m pip install --upgrade pip --quiet

if exist "backend\requirements.txt" (
    "backend\venv\Scripts\python.exe" -m pip install -r "backend\requirements.txt"
) else if exist "requirements.txt" (
    "backend\venv\Scripts\python.exe" -m pip install -r "requirements.txt"
)

:: Verifikasi apakah modul Flask berhasil terpasang di venv
"backend\venv\Scripts\python.exe" -c "import flask" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [PERBAIKAN OTOMATIS] Flask belum terpasang sempurna. Memasang paket inti Flask secara langsung...
    "backend\venv\Scripts\python.exe" -m pip install flask flask-cors pandas numpy openpyxl
    
    :: Pasang juga ke global python sebagai cadangan jika user menjalankan manual tanpa venv
    %PYTHON_CMD% -m pip install flask flask-cors pandas numpy openpyxl --quiet 2>nul
)

:: 6. Inisialisasi Database SQLite jika belum tersedia
if not exist "backend\forecasting.db" (
    echo Menginisialisasi Database SQLite awal (forecasting.db)...
    cd /d "%~dp0backend"
    "venv\Scripts\python.exe" init_db.py
    cd /d "%~dp0"
)

:: 7. Setup Frontend (Vue 3 + Vite)
echo.
echo [2/3] Menyiapkan Frontend Web App (Vue 3 + Vite)...
if not exist "frontend\node_modules" (
    echo Memasang package npm frontend (pertama kali dijalankan)...
    cd /d "%~dp0frontend"
    call npm install
    cd /d "%~dp0"
)

:: 8. Jalankan Server Backend & Frontend
echo.
echo [3/3] Menjalankan Aplikasi Nutricast...
echo ========================================================
echo  - Backend API:  http://127.0.0.1:5001
echo  - Frontend Web: http://localhost:5173
echo ========================================================
echo.

:: Jalankan backend menggunakan python interpreter venv secara eksplisit
start "Nutricast Backend Server (Port 5001)" /d "%~dp0backend" cmd /k "call venv\Scripts\activate.bat && venv\Scripts\python.exe app.py"

:: Jalankan frontend Vite dev server
start "Nutricast Frontend (Port 5173)" /d "%~dp0frontend" cmd /k "npm run dev"

echo Menunggu server siap dan membuka browser...
timeout /t 4 /nobreak >nul
start http://localhost:5173

echo.
echo Aplikasi Nutricast telah berhasil dijalankan!
echo Jangan tutup jendela Command Prompt backend dan frontend.
timeout /t 5 >nul
