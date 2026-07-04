# 🔧 Troubleshooting - Plant Doctor Application

## ❌ Error: "not enough space" saat install di emulator

### Penyebab
Emulator Android kehabisan ruang penyimpanan internal.

### ✅ Solusi

#### Solusi 1: Wipe Data Emulator (RECOMMENDED)

1. **Tutup emulator** yang sedang berjalan
2. Buka **Android Studio**
3. Klik menu **Tools** → **Device Manager** (atau **AVD Manager**)
4. Pada daftar emulator, klik ikon **▼** (dropdown) di sebelah emulator Anda
5. Pilih salah satu:
   - **"Wipe Data"** - Menghapus semua data dan aplikasi
   - **"Cold Boot Now"** - Restart emulator dari awal
6. Tunggu hingga selesai
7. Jalankan emulator lagi
8. Jalankan aplikasi:
   ```bash
   flutter run
   ```

#### Solusi 2: Gunakan Release Mode (Ukuran Lebih Kecil)

Build dalam mode release menghasilkan APK yang lebih kecil:

```bash
flutter run --release
```

#### Solusi 3: Install Manual APK

1. Build APK terlebih dahulu:
   ```bash
   flutter build apk --debug
   ```

2. Install manual ke emulator:
   ```bash
   adb install -r build/app/outputs/flutter-apk/app-debug.apk
   ```

3. Jika masih error, uninstall dulu aplikasi lama:
   ```bash
   adb uninstall com.example.plan_doctor_apllication
   adb install build/app/outputs/flutter-apk/app-debug.apk
   ```

#### Solusi 4: Buat Emulator Baru dengan Storage Lebih Besar

1. Buka **Android Studio**
2. **Tools** → **Device Manager** → **Create Device**
3. Pilih device (misalnya Pixel 5)
4. Pilih system image (API 33 atau lebih tinggi recommended)
5. Di halaman **Verify Configuration**:
   - Klik **Show Advanced Settings**
   - Ubah **Internal Storage** menjadi minimal **2048 MB** atau **4096 MB**
   - Klik **Finish**
6. Gunakan emulator baru ini

#### Solusi 5: Jalankan Script Perbaikan Otomatis

Jalankan script yang telah disediakan:

```bash
./fix_emulator.sh
```

Kemudian ikuti instruksi yang muncul.

---

## 🚀 Alternatif: Jalankan di Platform Lain

### Chrome (Web)
```bash
flutter run -d chrome
```

### Physical Device (Android)
1. Aktifkan **USB Debugging** di HP Android Anda:
   - Settings → About Phone → Tap "Build Number" 7x
   - Settings → Developer Options → USB Debugging (ON)
2. Hubungkan HP ke laptop via USB
3. Jalankan:
   ```bash
   flutter devices
   flutter run
   ```

### macOS Desktop (jika Xcode terinstall)
```bash
flutter run -d macos
```

---

## 📊 Memeriksa Storage Emulator

Untuk melihat berapa ruang yang tersedia di emulator:

```bash
adb shell df -h
```

Atau untuk melihat aplikasi yang terinstall:

```bash
adb shell pm list packages
```

---

## 🔄 Reset Lengkap Emulator

Jika semua solusi di atas tidak berhasil, reset total emulator:

1. Tutup emulator
2. Hapus emulator lama dari AVD Manager
3. Buat emulator baru dengan konfigurasi:
   - **RAM**: 2048 MB atau lebih
   - **Internal Storage**: 4096 MB atau lebih
   - **SD Card**: Optional, 512 MB
4. Jalankan emulator baru
5. Install aplikasi

---

## ✅ Verifikasi Instalasi Berhasil

Setelah berhasil diinstall, Anda harus melihat:
- Dashboard **Plant Doctor** dengan header hijau
- Tombol **"Ambil Foto"** dan **"Dari Galeri"**
- Floating Action Button untuk diagnosis
- **BUKAN** aplikasi Flutter demo counter

---

## 💡 Tips Mencegah Error di Masa Depan

1. **Gunakan mode release** untuk testing jika emulator lemot:
   ```bash
   flutter run --release
   ```

2. **Bersihkan project** secara berkala:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Restart emulator** secara berkala untuk membersihkan cache

4. **Gunakan physical device** untuk testing yang lebih cepat dan akurat

5. **Tingkatkan storage emulator** jika sering develop aplikasi besar
