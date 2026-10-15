#!/bin/bash

# ========================================================
# [GUARD 0] KUNCI DIREKTORI KERJA SCRIPT
# ========================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================================"
echo "   NUTRICAST: SISTEM PERAMALAN & OPTIMASI PMT STUNTING  "
echo "   Full-Stack Startup Manager & Dependency Guard (POSIX)"
echo "========================================================"
echo ""

# ========================================================
# [LANGKAH 1/5] INTEGRITAS STRUKTUR FOLDER PROYEK
# ========================================================
echo "[LANGKAH 1/5] Memeriksa Integritas Struktur Folder Proyek..."
if [ ! -f "backend/app.py" ]; then
    echo "[ERROR CRITICAL] File 'backend/app.py' tidak ditemukan!"
    exit 1
fi
if [ ! -f "frontend/package.json" ]; then
    echo "[ERROR CRITICAL] File 'frontend/package.json' tidak ditemukan!"
    exit 1
fi
echo "[OK] Struktur file proyek lengkap (backend dan frontend terdeteksi)."
echo ""

# ========================================================
# [LANGKAH 2/5] VALIDASI PYTHON & PIP
# ========================================================
echo "[LANGKAH 2/5] Memeriksa Lingkungan Python & pip..."

PYTHON_CMD="python3"
if ! command -v python3 &>/dev/null; then
    if command -v python &>/dev/null; then
        PYTHON_CMD="python"
    else
        echo "[ERROR GUARD] Python tidak ditemukan di sistem!"
        echo "Silakan unduh dan pasang Python 3.10+ dari https://www.python.org"
        exit 1
    fi
fi

echo "[OK] Menggunakan interpreter: $PYTHON_CMD ($($PYTHON_CMD --version))"
echo ""

# ========================================================
# [LANGKAH 3/5] VALIDASI NODE.JS & NPM
# ========================================================
echo "[LANGKAH 3/5] Memeriksa Lingkungan Node.js & npm..."

if ! command -v node &>/dev/null; then
    echo "[ERROR GUARD] Node.js tidak ditemukan!"
    echo "Silakan pasang Node.js 18+ LTS dari https://nodejs.org"
    exit 1
fi
echo "[OK] Node.js terdeteksi: $(node --version)"

if ! command -v npm &>/dev/null; then
    echo "[ERROR GUARD] npm tidak ditemukan!"
    exit 1
fi
echo "[OK] npm terdeteksi: v$(npm --version)"
echo ""

# ========================================================
# [LANGKAH 4/5] MANAJEMEN VIRTUAL ENVIRONMENT & BACKEND
# ========================================================
echo "[LANGKAH 4/5] Menyiapkan Lingkungan Backend & Dependensi Python..."

# Cek format venv jika bekas Windows (Scripts vs bin)
if [ -d "backend/venv" ] && [ ! -f "backend/venv/bin/python" ]; then
    echo "[INFO] Menghapus folder backend/venv format non-POSIX..."
    rm -rf backend/venv
fi

# Coba buat venv jika belum ada
if [ ! -d "backend/venv" ]; then
    echo "[WAIT] Membuat virtual environment baru di 'backend/venv'..."
    $PYTHON_CMD -m venv backend/venv 2>/dev/null
fi

ACTIVE_PY="$PYTHON_CMD"
if [ -f "backend/venv/bin/python" ]; then
    ACTIVE_PY="backend/venv/bin/python"
    echo "[OK] Menggunakan Virtual Environment: backend/venv"
else
    echo "[INFO] Menggunakan Python Sistem ($PYTHON_CMD) langsung."
fi

# Cek dependensi utama
echo "[GUARD] Memverifikasi dependensi modul Backend..."
if "$ACTIVE_PY" -c "import flask, flask_cors, pandas, numpy, openpyxl" &>/dev/null; then
    echo "[OK] Seluruh modul inti Backend sudah siap!"
else
    echo "[WAIT] Memasang modul backend yang diperlukan..."
    if [ -f "backend/requirements.txt" ]; then
        "$ACTIVE_PY" -m pip install -r backend/requirements.txt --no-warn-script-location
    elif [ -f "requirements.txt" ]; then
        "$ACTIVE_PY" -m pip install -r requirements.txt --no-warn-script-location
    fi

    if ! "$ACTIVE_PY" -c "import flask, flask_cors, pandas, numpy, openpyxl" &>/dev/null; then
        echo "[WAIT] Memasang paket inti secara langsung..."
        "$ACTIVE_PY" -m pip install flask flask-cors pandas numpy openpyxl --no-warn-script-location
    fi
    echo "[OK] Dependensi Backend berhasil diverifikasi!"
fi

if [ ! -f "backend/forecasting.db" ]; then
    echo "[WAIT] Menginisialisasi Database SQLite awal dari Excel..."
    (cd backend && "$ACTIVE_PY" init_db.py)
    echo "[OK] Database berhasil diinisialisasi."
else
    echo "[OK] Database SQLite 'forecasting.db' siap digunakan."
fi
echo ""

# ========================================================
# [LANGKAH 5/5] SETUP DEPENDENSI FRONTEND (NPM)
# ========================================================
echo "[LANGKAH 5/5] Memeriksa Dependensi Frontend (Vue 3 + Vite)..."

if [ ! -d "frontend/node_modules" ]; then
    echo "[WAIT] Memasang dependensi npm frontend..."
    (cd frontend && npm install)
    echo "[OK] Package frontend berhasil dipasang."
else
    echo "[OK] Folder frontend/node_modules sudah tersedia."
fi
echo ""

# ========================================================
# PELUNCURAN SERVER & CLEAN EXIT TRAP
# ========================================================
echo "========================================================"
echo "[BERHASIL] Seluruh Guard & Dependensi Selesai Disiapkan!"
echo ""
echo "Meluncurkan Server Nutricast:"
echo " 1. Backend API Server : http://127.0.0.1:5001"
echo " 2. Frontend Web App   : http://localhost:5173"
echo " Tekan Ctrl+C untuk menghentikan seluruh aplikasi."
echo "========================================================"
echo ""

(cd backend && "$ACTIVE_PY" app.py) &
BACKEND_PID=$!

trap "kill $BACKEND_PID 2>/dev/null; exit" INT TERM EXIT

(cd frontend && npm run dev)
