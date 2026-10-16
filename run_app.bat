@echo off
TITLE Nutricast - Full Stack Runner (Windows)
COLOR 0A

:: Kunci folder kerja ke lokasi file bat ini berada
cd /d "%~dp0"

echo ========================================================
echo    NUTRICAST: SISTEM PERAMALAN ^& OPTIMASI PMT STUNTING
echo ========================================================
echo.

:: 1. Deteksi Python
set PYTHON_CMD=python
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        set PYTHON_CMD=py
    ) else (
        echo [ERROR] Python tidak ditemukan di PATH sistem!
        echo Pastikan Python sudah terpasang dan dicentang 'Add to PATH'.
        pause
        exit /b 1
    )
)
echo [1/4] Menggunakan Python: %PYTHON_CMD%

:: 2. Deteksi Node.js / npm
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js / npm tidak ditemukan!
    echo Silakan pasang Node.js dari https://nodejs.org
    pause
    exit /b 1
)
echo [2/4] Node.js dan npm terdeteksi.

:: 3. Instalasi dependensi backend langsung dengan pip (tanpa venv, tanpa upgrade pip)
echo [3/4] Memasang dependensi backend dari requirements.txt...
if exist "backend\requirements.txt" (
    %PYTHON_CMD% -m pip install -r "backend\requirements.txt"
) else if exist "requirements.txt" (
    %PYTHON_CMD% -m pip install -r "requirements.txt"
) else (
    %PYTHON_CMD% -m pip install flask flask-cors pandas numpy openpyxl
)

:: Inisialisasi Database jika belum ada
if not exist "backend\forecasting.db" (
    echo Menginisialisasi database awal...
    cd /d "%~dp0backend"
    %PYTHON_CMD% init_db.py
    cd /d "%~dp0"
)

:: 4. Setup frontend
echo [4/4] Memeriksa dependensi frontend...
if not exist "frontend\node_modules" (
    echo Memasang package npm frontend...
    cd /d "%~dp0frontend"
    call npm install
    cd /d "%~dp0"
)

:: 5. Jalankan backend dan frontend
echo.
echo ========================================================
echo  Backend Server  : http://127.0.0.1:5001
echo  Frontend Web    : http://localhost:5173
echo ========================================================
echo.

start "Nutricast Backend Server (Port 5001)" /d "%~dp0backend" cmd /k "%PYTHON_CMD% app.py"
start "Nutricast Frontend (Port 5173)" /d "%~dp0frontend" cmd /k "npm run dev"

timeout /t 4 /nobreak >nul
start http://localhost:5173

echo Aplikasi Nutricast sedang berjalan.
timeout /t 5 >nul
