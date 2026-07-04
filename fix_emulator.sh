#!/bin/bash

echo "🔧 Memperbaiki masalah storage emulator Android..."
echo ""

# 1. Clean Flutter project
echo "1️⃣ Membersihkan Flutter project..."
flutter clean
echo "✅ Flutter clean selesai"
echo ""

# 2. Get Flutter SDK path
FLUTTER_SDK=$(flutter --version | grep "Flutter" | awk '{print $3}')
echo "📍 Flutter SDK path: $FLUTTER_SDK"
echo ""

# 3. Find adb
ADB_PATH=$(which adb)
if [ -z "$ADB_PATH" ]; then
    # Try to find adb in common locations
    POSSIBLE_PATHS=(
        "$HOME/Library/Android/sdk/platform-tools/adb"
        "$HOME/Android/Sdk/platform-tools/adb"
        "/usr/local/bin/adb"
    )
    
    for path in "${POSSIBLE_PATHS[@]}"; do
        if [ -f "$path" ]; then
            ADB_PATH="$path"
            break
        fi
    done
fi

if [ -n "$ADB_PATH" ]; then
    echo "📱 ADB ditemukan: $ADB_PATH"
    echo ""
    
    # 4. Clear app data on emulator
    echo "2️⃣ Membersihkan data aplikasi di emulator..."
    $ADB_PATH shell pm clear com.example.plan_doctor_apllication 2>/dev/null || echo "⚠️  Aplikasi belum pernah terinstall"
    echo ""
    
    # 5. Show storage info
    echo "3️⃣ Informasi storage emulator:"
    $ADB_PATH shell df -h | grep "/data"
    echo ""
else
    echo "⚠️  ADB tidak ditemukan. Lewati pembersihan emulator."
    echo ""
fi

# 6. Rebuild
echo "4️⃣ Rebuilding Flutter project..."
flutter pub get
echo "✅ Dependencies berhasil di-download"
echo ""

echo "🎉 Selesai!"
echo ""
echo "📌 Langkah selanjutnya:"
echo "   1. Tutup emulator yang sedang berjalan"
echo "   2. Buka AVD Manager"
echo "   3. Klik 'Wipe Data' atau 'Cold Boot' pada emulator"
echo "   4. Jalankan emulator lagi"
echo "   5. Jalankan: flutter run"
echo ""
echo "💡 Atau gunakan command berikut untuk install di emulator dengan mode release (ukuran lebih kecil):"
echo "   flutter run --release"
