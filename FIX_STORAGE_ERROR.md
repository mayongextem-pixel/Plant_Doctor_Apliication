# 🔧 Cara Mengatasi Error INSTALL_FAILED_INSUFFICIENT_STORAGE

## ❌ Error yang Muncul
```
adb: failed to install: Failure [INSTALL_FAILED_INSUFFICIENT_STORAGE]
```

**Penyebab:** Emulator Android kehabisan storage internal (saat ini 86% penuh)

---

## ✅ SOLUSI TERBAIK: Wipe Data Emulator

### **Langkah-Langkah Detail:**

#### 1️⃣ Tutup Emulator
- Klik tombol **X** pada window emulator
- Atau tekan **Cmd + Q** saat window emulator aktif

#### 2️⃣ Buka Android Studio
- Launch aplikasi **Android Studio**
- Tunggu hingga fully loaded

#### 3️⃣ Buka Device Manager
Pilih salah satu cara:
- **Cara A:** Menu bar → **Tools** → **Device Manager**
- **Cara B:** Klik icon **📱** (Device Manager) di toolbar kanan
- **Cara C:** Tekan **Shift + Shift** → ketik "Device Manager" → Enter

#### 4️⃣ Temukan Emulator Anda
Cari emulator dengan nama:
- **"sdk gphone64 arm64"**, atau
- **"Medium Phone API 36.1"**, atau
- **"Pixel 9"**

#### 5️⃣ Wipe Data
```
┌──────────────────────────────────────────┐
│ Device Manager                           │
├──────────────────────────────────────────┤
│ Virtual Devices                          │
│                                           │
│ 📱 sdk gphone64 arm64       ▶️  ⋮       │
│    API 36 (Android 16)                   │
│                                           │
└──────────────────────────────────────────┘
```

- Klik icon **⋮** (tiga titik vertikal) di sebelah kanan nama emulator
- Akan muncul dropdown menu
- Pilih **"Wipe Data"**

#### 6️⃣ Konfirmasi
- Dialog konfirmasi akan muncul
- Baca peringatan: "This will delete all data on the virtual device"
- Klik **"Yes"** atau **"Wipe Data"**

#### 7️⃣ Tunggu Proses
- Progress bar akan muncul
- Tunggu 5-15 detik
- Akan muncul notifikasi "Device data wiped successfully"

#### 8️⃣ Jalankan Emulator Lagi
- Klik tombol **▶️** (Play) pada emulator yang sama
- Tunggu emulator boot (30-60 detik)
- Emulator akan bersih seperti baru

#### 9️⃣ Run Aplikasi
Buka terminal dan jalankan:

```bash
cd "/Users/nantamac/flutter/UAS Pemob/Plant_Doctor_Apliication"
flutter run --release
```

---

## 🚀 Alternatif: Gunakan Release Mode

Jika tidak ingin wipe data, gunakan release mode (APK lebih kecil 50%):

```bash
flutter run --release
```

**Keuntungan Release Mode:**
- APK size ~15-20 MB (vs debug ~40-50 MB)
- Performa lebih cepat
- Cocok untuk testing

**Kekurangan Release Mode:**
- Tidak bisa hot reload
- Tidak ada debug info

---

## 🛠️ Alternatif: Buat Emulator Baru dengan Storage Lebih Besar

### Langkah-Langkah:

#### 1. Buka Device Manager
Android Studio → Tools → Device Manager

#### 2. Create New Virtual Device
Klik **"+"** atau **"Create Device"**

#### 3. Pilih Hardware
- Pilih **"Pixel 5"** atau **"Pixel 9"**
- Klik **"Next"**

#### 4. Pilih System Image
- Pilih **"API 33"** (Android 13) atau **"API 35"** (Android 15)
- Download jika belum tersedia
- Klik **"Next"**

#### 5. Konfigurasi AVD (PENTING!)
- AVD Name: `Plant_Doctor_Emulator`
- Graphics: **Hardware - GLES 2.0**
- Klik **"Show Advanced Settings"** (di bawah)

#### 6. Atur Storage (KUNCI!)
Scroll ke bagian **Memory and Storage**:
```
RAM: 2048 MB (atau lebih)
VM Heap: 512 MB
Internal Storage: 4096 MB  ← TINGKATKAN INI!
SD Card: 512 MB (opsional)
```

#### 7. Finish
- Klik **"Finish"**
- Emulator baru akan muncul di daftar
- Jalankan emulator baru ini

#### 8. Set as Default
```bash
flutter emulators --launch Plant_Doctor_Emulator
```

---

## 📊 Cek Storage Emulator

Untuk melihat berapa storage tersedia:

```bash
/Users/nantamac/Library/Android/sdk/platform-tools/adb shell df -h | grep "/data"
```

**Output Example:**
```
/dev/block/dm-53  5.8G 4.8G  866M  86% /data
                        ↑     ↑     ↑
                      Total  Used  Free
```

**Status:**
- ✅ **< 70% used** - Aman
- ⚠️ **70-85% used** - Perlu dibersihkan
- ❌ **> 85% used** - HARUS wipe data atau buat emulator baru

---

## 🧹 Script Pembersihan Otomatis

Jalankan script yang sudah dibuat:

```bash
./clear_emulator_space.sh
```

Script ini akan:
- Clear cache Google Play Services
- Clear cache Chrome
- Clear cache Google Play Store
- Hapus temporary files
- Tampilkan storage before/after

---

## 💡 Tips Mencegah Error di Masa Depan

### 1. Gunakan Release Mode untuk Testing
```bash
flutter run --release
```

### 2. Clean Project Secara Berkala
```bash
flutter clean
flutter pub get
```

### 3. Uninstall Aplikasi Lama dari Emulator
- Buka emulator
- Tap & hold icon aplikasi
- Drag ke "Uninstall"

### 4. Restart Emulator Secara Berkala
- Tutup emulator setelah selesai development
- Jangan biarkan emulator berjalan terus-menerus

### 5. Gunakan Physical Device
- Lebih cepat
- Storage tidak terbatas
- Hasil testing lebih akurat

---

## 🎯 Troubleshooting

### Q: Setelah wipe data masih error?
**A:** Buat emulator baru dengan storage lebih besar (4096 MB)

### Q: Wipe data menghapus apa saja?
**A:** Semua data di emulator (aplikasi, settings, files). Tidak mempengaruhi project Anda.

### Q: Apakah safe untuk wipe data?
**A:** Ya, sangat safe. Emulator akan reset seperti baru.

### Q: Berapa lama proses wipe data?
**A:** 5-15 detik saja.

### Q: Apakah project saya ikut terhapus?
**A:** TIDAK! Project di `/Users/nantamac/flutter/...` tetap aman. Hanya data di emulator yang dihapus.

---

## ✅ Checklist Solusi

Coba solusi secara berurutan:

- [ ] **Solusi 1:** Wipe Data Emulator (RECOMMENDED)
  - Android Studio → Device Manager → Emulator → ⋮ → Wipe Data
  
- [ ] **Solusi 2:** Run dengan Release Mode
  - `flutter run --release`
  
- [ ] **Solusi 3:** Bersihkan Cache
  - `./clear_emulator_space.sh`
  
- [ ] **Solusi 4:** Buat Emulator Baru
  - Storage 4096 MB atau lebih
  
- [ ] **Solusi 5:** Gunakan Physical Device
  - Enable USB Debugging
  - Connect via USB

---

## 🚀 Quick Commands

```bash
# Clean project
flutter clean && flutter pub get

# Run release mode
flutter run --release

# Check emulator storage
/Users/nantamac/Library/Android/sdk/platform-tools/adb shell df -h | grep "/data"

# Clear emulator space
./clear_emulator_space.sh

# List all emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch <emulator-name>
```

---

## 📞 Masih Error?

Jika semua solusi di atas tidak berhasil:

1. **Restart Emulator:**
   ```bash
   /Users/nantamac/Library/Android/sdk/platform-tools/adb reboot
   ```

2. **Restart Android Studio:**
   - Quit Android Studio
   - Launch lagi

3. **Restart Computer:**
   - Kadang ini solusi paling efektif

4. **Delete dan Buat Ulang Emulator:**
   - Device Manager → Emulator → ⋮ → Delete
   - Create new dengan storage 4096 MB

---

**Setelah Wipe Data, aplikasi Anda pasti bisa berjalan! 🎉**
