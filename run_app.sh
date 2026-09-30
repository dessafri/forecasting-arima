#!/bin/bash

echo "========================================================"
echo "   NUTRICAST: SISTEM PERAMALAN & OPTIMASI PMT STUNTING  "
echo "========================================================"
echo ""

# 1. Setup Backend
echo "[1/2] Menyiapkan Backend Server..."
cd backend
if [ ! -d "venv" ]; then
    echo "Membuat Python Virtual Environment..."
    python3 -m venv venv
fi
source venv/bin/activate
pip install -r requirements.txt --quiet
if [ ! -f "forecasting.db" ]; then
    echo "Menginisialisasi Database SQLite..."
    python init_db.py
fi

# Run backend in background
python app.py &
BACKEND_PID=$!
cd ..

# 2. Setup Frontend
echo "[2/2] Menyiapkan Frontend Web App..."
cd frontend
if [ ! -d "node_modules" ]; then
    echo "Memasang dependensi npm..."
    npm install
fi

echo ""
echo "========================================================"
echo "Backend PID: $BACKEND_PID (http://127.0.0.1:5001)"
echo "Menjalankan Frontend Web App di http://localhost:5173"
echo "Tekan Ctrl+C untuk menghentikan seluruh aplikasi."
echo "========================================================"

# Trap exit to kill backend process
trap "kill $BACKEND_PID; exit" INT TERM EXIT

npm run dev
