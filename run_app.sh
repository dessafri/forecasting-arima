#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================================"
echo "   NUTRICAST: SISTEM PERAMALAN & OPTIMASI PMT STUNTING  "
echo "========================================================"
echo ""

PYTHON_CMD="python3"
if ! command -v python3 &>/dev/null; then
    PYTHON_CMD="python"
fi

# 1. Install Backend Dependencies langsung
echo "[1/3] Memasang dependensi backend..."
if [ -f "backend/requirements.txt" ]; then
    $PYTHON_CMD -m pip install -r backend/requirements.txt
elif [ -f "requirements.txt" ]; then
    $PYTHON_CMD -m pip install -r requirements.txt
else
    $PYTHON_CMD -m pip install flask flask-cors pandas numpy openpyxl
fi

# Inisialisasi Database
if [ ! -f "backend/forecasting.db" ]; then
    echo "Menginisialisasi database awal..."
    (cd backend && $PYTHON_CMD init_db.py)
fi

# 2. Setup Frontend
echo "[2/3] Memeriksa dependensi frontend..."
if [ ! -d "frontend/node_modules" ]; then
    (cd frontend && npm install)
fi

# 3. Jalankan Backend & Frontend
echo "[3/3] Menjalankan Server Backend & Frontend..."
(cd backend && $PYTHON_CMD app.py) &
BACKEND_PID=$!

trap "kill $BACKEND_PID 2>/dev/null; exit" INT TERM EXIT

(cd frontend && npm run dev)
