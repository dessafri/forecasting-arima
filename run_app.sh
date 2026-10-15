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
# [GUARD 1] INTEGRITAS STRUKTUR FOLDER PROYEK
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
# [GUARD 2] VALIDASI PYTHON, PIP, & MODUL VENV
# ========================================================
echo "[LANGKAH 2/5] Memeriksa Lingkungan Python, pip, & venv..."

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

# Cek ketersediaan venv
echo "[GUARD] Memeriksa ketersediaan modul venv..."
if ! $PYTHON_CMD -c "import venv" &>/dev/null; then
    echo "[ERROR GUARD] Modul 'venv' tidak tersedia di Python Anda!"
    echo "Pada Ubuntu/Debian jalankan: sudo apt install python3-venv"
    exit 1
fi
echo "[OK] Modul 'venv' terverifikasi aktif."

# Cek ketersediaan pip
echo "[GUARD] Memeriksa ketersediaan modul pip..."
if ! $PYTHON_CMD -m pip --version &>/dev/null; then
    echo "[INFO] pip belum aktif. Mencoba menjalankan ensurepip..."
    $PYTHON_CMD -m ensurepip --default-pip &>/dev/null
    if ! $PYTHON_CMD -m pip --version &>/dev/null; then
        echo "[ERROR GUARD] pip tidak dapat diaktifkan. Pasang python3-pip terlebih dahulu."
        exit 1
    fi
fi
echo "[OK] pip terdeteksi: $($PYTHON_CMD -m pip --version)"
echo ""

# ========================================================
# [GUARD 3] VALIDASI NODE.JS & NPM UNTUK FRONTEND
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
# [GUARD 4] MANAJEMEN VIRTUAL ENVIRONMENT & BACKEND
# ========================================================
echo "[LANGKAH 4/5] Menyiapkan Virtual Environment & Dependensi Backend..."

# Cek format venv jika bekas Windows (Scripts vs bin)
if [ -d "backend/venv" ] && [ ! -f "backend/venv/bin/python" ]; then
    echo "[GUARD] Terdeteksi folder backend/venv non-POSIX (format Windows). Membersihkan..."
    rm -rf backend/venv
fi

if [ ! -d "backend/venv" ]; then
    echo "[WAIT] Membuat virtual environment baru di 'backend/venv'..."
    $PYTHON_CMD -m venv backend/venv
    if [ $? -ne 0 ]; then
        echo "[ERROR] Gagal membuat virtual environment."
        exit 1
    fi
    echo "[OK] Virtual environment baru berhasil dibuat."
else
    echo "[OK] Virtual environment backend/venv sudah tersedia."
fi

backend/venv/bin/python -m pip install --upgrade pip --quiet 2>/dev/null

echo "[GUARD] Memverifikasi apakah paket inti Backend sudah terpasang..."
if backend/venv/bin/python -c "import flask, flask_cors, pandas, numpy, openpyxl" &>/dev/null; then
    echo "[OK] Seluruh modul inti Backend telah terpasang dengan baik!"
else
    echo "[WAIT] Memasang dependensi backend..."
    if [ -f "backend/requirements.txt" ]; then
        backend/venv/bin/python -m pip install -r backend/requirements.txt
    elif [ -f "requirements.txt" ]; then
        backend/venv/bin/python -m pip install -r requirements.txt
    fi

    # Fallback jika belum sempurna
    if ! backend/venv/bin/python -c "import flask, flask_cors, pandas, numpy, openpyxl" &>/dev/null; then
        echo "[FIX FALLBACK] Memasang paket inti langsung ke venv..."
        backend/venv/bin/python -m pip install flask flask-cors pandas numpy openpyxl
    fi

    if ! backend/venv/bin/python -c "import flask" &>/dev/null; then
        echo "[ERROR CRITICAL] Modul Flask tetap tidak dapat dimuat!"
        exit 1
    fi
    echo "[OK] Instalasi dependensi Backend berhasil diverifikasi!"
fi

if [ ! -f "backend/forecasting.db" ]; then
    echo "[WAIT] Menginisialisasi Database SQLite awal dari Excel..."
    (cd backend && ./venv/bin/python init_db.py)
    echo "[OK] Database berhasil diinisialisasi."
else
    echo "[OK] Database SQLite 'forecasting.db' siap digunakan."
fi
echo ""

# ========================================================
# [GUARD 5] SETUP DEPENDENSI FRONTEND (NPM)
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
echo "[BERHASIL] Seluruh Guard & Dependensi Terverifikasi!"
echo ""
echo "Meluncurkan Server Nutricast:"
echo " 1. Backend API Server : http://127.0.0.1:5001"
echo " 2. Frontend Web App   : http://localhost:5173"
echo " Tekan Ctrl+C untuk menghentikan seluruh aplikasi."
echo "========================================================"
echo ""

(cd backend && ./venv/bin/python app.py) &
BACKEND_PID=$!

trap "kill $BACKEND_PID 2>/dev/null; exit" INT TERM EXIT

(cd frontend && npm run dev)
