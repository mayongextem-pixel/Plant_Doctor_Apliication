#!/bin/bash

echo "🧹 Membersihkan Storage Emulator Android..."
echo ""

# Get ADB path
ADB="/Users/nantamac/Library/Android/sdk/platform-tools/adb"

if [ ! -f "$ADB" ]; then
    echo "❌ ADB tidak ditemukan di: $ADB"
    echo "💡 Pastikan Android SDK sudah terinstall"
    exit 1
fi

echo "📱 Checking emulator connection..."
$ADB devices

echo ""
echo "🗑️  Menghapus cache aplikasi di emulator..."

# Clear cache for common system apps
$ADB shell pm clear com.google.android.gms 2>/dev/null
$ADB shell pm clear com.android.chrome 2>/dev/null
$ADB shell pm clear com.android.vending 2>/dev/null

echo ""
echo "🗂️  Storage emulator sebelum pembersihan:"
$ADB shell df -h | grep "/data"

echo ""
echo "🧹 Membersihkan temporary files..."
$ADB shell "rm -rf /data/local/tmp/*" 2>/dev/null

echo ""
echo "📊 Storage emulator setelah pembersihan:"
$ADB shell df -h | grep "/data"

echo ""
echo "✅ Selesai!"
echo ""
echo "💡 Jika masih penuh, lakukan WIPE DATA via AVD Manager:"
echo "   Android Studio → Tools → Device Manager → Your Emulator → ⋮ → Wipe Data"
echo ""
echo "🚀 Setelah itu jalankan:"
echo "   flutter run --release"
