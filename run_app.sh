#!/bin/bash

# Pastikan script selalu berjalan di root folder project
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================================"
echo "   NUTRICAST: SISTEM PERAMALAN & OPTIMASI PMT STUNTING  "
echo "========================================================"
echo ""

# 1. Setup Backend
echo "[1/3] Menyiapkan Backend Server Python..."
if [ ! -d "backend/venv" ]; then
    echo "Membuat Python Virtual Environment..."
    python3 -m venv backend/venv
fi

if [ -f "backend/requirements.txt" ]; then
    backend/venv/bin/python -m pip install -r backend/requirements.txt
elif [ -f "requirements.txt" ]; then
    backend/venv/bin/python -m pip install -r requirements.txt
fi

if ! backend/venv/bin/python -c "import flask" 2>/dev/null; then
    echo "Memasang dependensi inti Flask..."
    backend/venv/bin/python -m pip install flask flask-cors pandas numpy openpyxl
fi

if [ ! -f "backend/forecasting.db" ]; then
    echo "Menginisialisasi Database SQLite awal..."
    (cd backend && ./venv/bin/python init_db.py)
fi

# 2. Setup Frontend
echo ""
echo "[2/3] Menyiapkan Frontend Web App..."
if [ ! -d "frontend/node_modules" ]; then
    echo "Memasang dependensi npm frontend..."
    (cd frontend && npm install)
fi

# 3. Jalankan Backend & Frontend
echo ""
echo "[3/3] Menjalankan Server Backend & Frontend..."
echo "========================================================"
echo " - Backend API:  http://127.0.0.1:5001"
echo " - Frontend Web: http://localhost:5173"
echo " Tekan Ctrl+C untuk menghentikan seluruh aplikasi."
echo "========================================================"
echo ""

(cd backend && ./venv/bin/python app.py) &
BACKEND_PID=$!

# Trap exit untuk membersihkan backend saat Ctrl+C
trap "kill $BACKEND_PID 2>/dev/null; exit" INT TERM EXIT

(cd frontend && npm run dev)
