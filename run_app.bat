@echo off
TITLE Nutricast - Full Stack Runner (Windows)
COLOR 0A
echo ========================================================
echo    NUTRICAST: SISTEM PERAMALAN & OPTIMASI PMT STUNTING
echo ========================================================
echo.

:: 1. Check Python
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Python tidak ditemukan! Harap pasang Python 3.10+ dan centang 'Add to PATH'.
    pause
    exit /b
)

:: 2. Check Node
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js / npm tidak ditemukan! Harap pasang Node.js 18+.
    pause
    exit /b
)

:: 3. Setup & Run Backend in a separate window
echo [1/2] Menyiapkan Backend Server...
cd backend
if not exist venv (
    echo Membuat Python Virtual Environment...
    python -m venv venv
)
call venv\Scripts\activate
pip install -r requirements.txt --quiet
if not exist forecasting.db (
    echo Menginisialisasi Database SQLite...
    python init_db.py
)
start "Nutricast Backend Server (Port 5001)" cmd /k "venv\Scripts\activate && python app.py"
cd ..

:: 4. Setup & Run Frontend
echo [2/2] Menyiapkan Frontend Web App...
cd frontend
if not exist node_modules (
    echo Memasang dependensi npm...
    call npm install
)
echo.
echo ========================================================
echo Backend aktif di: http://127.0.0.1:5001
echo Membuka Frontend Web App di browser...
echo ========================================================
start "Nutricast Frontend (Port 5173)" cmd /k "npm run dev"
cd ..

timeout /t 3 >nul
start http://localhost:5173
