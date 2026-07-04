# 🌿 Plant Doctor Application — Rangkuman Project

> **Mata Kuliah:** Pemrograman Mobile  
> **Jenis Tugas:** UAS (Ujian Akhir Semester)  
> **Versi Aplikasi:** 1.0.0  
> **Framework:** Flutter (Dart)  
> **Target Platform:** Android / iOS

---

## 📋 Deskripsi Aplikasi

**Plant Doctor** adalah aplikasi mobile berbasis Flutter yang memungkinkan pengguna mendeteksi penyakit pada tanaman menggunakan kamera smartphone. Hasil deteksi diperoleh melalui integrasi API Plant.id, kemudian ditampilkan beserta panduan penanganan dan perawatan. Aplikasi ini dilengkapi dengan sistem autentikasi, riwayat scan, dan navigasi bottom-bar yang lengkap.

---

## ✅ Fitur yang Telah Diselesaikan

### 1. 🎨 Sistem Tema & Desain Global
**File:** `lib/config/app_theme.dart`

- **Color Palette** "Modern Earthy Green" yang konsisten di seluruh aplikasi:
  - `Moss Green` (#4A7C59) sebagai warna primer
  - `Cream/Off-white` (#FFFBF5) sebagai background
  - `Terracotta Orange` (#E07A5F) sebagai aksen
  - `Soft Gold` (#F2CC8F) sebagai aksen sekunder
- **Tipografi Poppins** via `google_fonts` — diaplikasikan secara global
- **Material 3** aktif dengan `useMaterial3: true`
- **Design Token** lengkap: spacing (XS–XXL), radius (Small–XLarge), elevation
- **ThemeData** terpusat mencakup: AppBar, Card, Button, Input, SearchBar, FAB, BottomNavBar, Chip, Divider
- Helper method: `getSeverityColor()` dan `getAccuracyColor()`

---

### 2. 🌀 Splash Screen
**File:** `lib/screens/splash_screen.dart`

- Animasi **fade-in** dan **scale (elastic)** dengan `AnimationController`
- Dekorasi organik: `_OrganicShape` dan `_LeafShape` (CustomPainter)
- **Session check** otomatis via `SharedPreferences`:
  - Jika sudah login → langsung ke `MainScreen`
  - Jika belum → ke `WelcomeScreen`

---

### 3. 🚀 Onboarding / Welcome Screen (2 Halaman)
**File:** `lib/screens/auth/welcome_screen.dart`

- **PageView** 2 slide yang bisa digeser:
  1. Halaman 1: "Plant Doctor – Rawat Tanamanmu dengan AI"
  2. Halaman 2: "Diagnosis Akurat – Solusi instan menjaga tanaman"
- **Dot Indicator** animasi (expand/collapse) menunjukkan halaman aktif
- Tombol **Next** di halaman 1, tombol **"Let's Started"** di halaman 2
- Transisi halaman menggunakan `PageTransitions.slideAndFadeTransition()`

---

### 4. 🔐 Sistem Autentikasi (Mock)
**File:** `lib/screens/auth/login_screen.dart`, `register_screen.dart`

- **Login Screen**: Form email & password dengan validasi
- **Register Screen**: Form nama, email, dan password
- **Session Persistence** menggunakan `SharedPreferences`:
  - Key `isLoggedIn` disimpan saat login berhasil
  - Dibaca saat Splash Screen untuk menentukan routing
- **Logout** dari halaman Profil: menghapus `isLoggedIn` dan redirect ke `WelcomeScreen`

---

### 5. 🏠 Navigasi Utama (Bottom Navigation + FAB)
**File:** `lib/screens/main_nav/main_screen.dart`

- **Bottom Navigation Bar** dengan 3 tab:
  - 🏠 Beranda (`HomeFragment`)
  - 🌿 Koleksi (`KoleksiFragment`)
  - 👤 Profil (`ProfileFragment`)
- **FAB (Floating Action Button)** "Scan Tanaman" di tengah yang buka `CameraScreen`
- Custom page transition antar fragment

---

### 6. 🏡 Halaman Beranda (Home Fragment)
**File:** `lib/screens/main_nav/home_fragment.dart`

- **Greeting header**: "Selamat Datang! 👋" + subtitle
- **Search Bar** terintegrasi dengan Material 3 `SearchBar`
- **Quick Action Menu** (horizontal scroll) dengan navigasi ke:
  - Riwayat, Artikel, Tips Harian, Tersimpan
- **Promotional Banner** gradasi hijau untuk Tips Harian (navigasi langsung)
- **Plant Collection Grid** (2 kolom) menampilkan riwayat scan dengan status badge (Sehat/Sakit)
- Empty state saat belum ada tanaman terscan

---

### 7. 📷 Camera Screen
**File:** `lib/screens/camera_screen.dart`

- Integrasi `image_picker` untuk memilih foto dari galeri atau kamera
- Preview gambar sebelum dikirim untuk analisis
- Navigasi ke `DiagnosisResultScreen` setelah foto dipilih

---

### 8. 🔬 Layar Hasil Diagnosis
**File:** `lib/screens/diagnosis_result_screen.dart`

- **SliverAppBar** dengan full-screen foto tanaman (Hero animation)
- Tombol **Bookmark** dan **Share** di app bar
- Loading indicator selama proses analisis API
- **Error handling** dengan tombol "Coba Lagi" jika gagal
- Menampilkan:
  - Nama penyakit + nama umum (common name)
  - **Accuracy Badge** berwarna dinamis (hijau/kuning/merah)
  - **Severity Badge** dengan ikon dan warna sesuai tingkat keparahan (Ringan/Sedang/Parah)
  - Deskripsi penyakit
  - **Care Guide Icons**: Air, Cahaya, Tindakan
  - **Langkah Penanganan** bernomor (numbered list)
- **Auto-save** hasil diagnosis ke riwayat lokal segera setelah analisis selesai
- Bottom action bar: "Simpan Diagnosis" / "Tersimpan di Riwayat"

---

### 9. 🤖 Integrasi API Plant.id
**File:** `lib/services/api_service.dart`

- Singleton pattern (`ApiService.instance`)
- Endpoint: `POST /health_assessment` dengan **Multipart Form Data** (upload file gambar)
- Header autentikasi `Api-Key`
- **Error handling komprehensif**:
  - `401 Unauthorized` → pesan API key tidak valid
  - `429 Rate Limit` → pesan batas request terlampaui
  - `SocketException` → pesan tidak ada koneksi internet
  - `TimeoutException` → pesan koneksi timeout (30 detik)
  - `FormatException` → pesan format response tidak valid
- **Mock data fallback** otomatis jika API key belum dikonfigurasi (mode demo)
- Support diagnosis multi-gambar (`diagnosePlantMultipleImages`)
- Health check endpoint (`checkApiHealth`)

---

### 10. 💾 Layanan Riwayat Scan (Local Storage)
**File:** `lib/services/history_service.dart`

- **Model `ScanHistory`** dengan field: id, imagePath, diseaseName, accuracy, date, description, treatments
- Serialisasi JSON `toJson()` dan `fromJson()` untuk persistensi
- `HistoryService.saveScanResult()` — menyimpan hasil scan ke `SharedPreferences`
- `HistoryService.getHistory()` — mengambil semua riwayat scan
- `HistoryService.clearHistory()` — menghapus semua riwayat
- Data tersimpan dengan urutan terbaru di atas (insert at index 0)

---

### 11. 🗂️ Halaman Riwayat, Artikel, Tips Harian & Tersimpan
**File:** `lib/screens/menus/`

| Halaman | File | Deskripsi |
|---------|------|-----------|
| Riwayat | `riwayat_screen.dart` | Menampilkan riwayat diagnosis scan |
| Artikel | `artikel_screen.dart` | Daftar artikel seputar perawatan tanaman |
| Tips Harian | `tips_harian_screen.dart` | Tips perawatan tanaman harian |
| Tersimpan | `tersimpan_screen.dart` | Item yang di-bookmark/disimpan pengguna |

---

### 12. 👤 Halaman Profil
**File:** `lib/screens/main_nav/profile_fragment.dart`

- Avatar lingkaran dengan ikon edit
- **Stat Cards**: Tanaman, Scan, Artikel Dibaca
- Menu item: Notifikasi, Tentang Aplikasi, Bantuan & FAQ
- Tombol **Keluar (Logout)** yang menghapus sesi dan redirect ke WelcomeScreen
- Dialog **"Tentang Aplikasi"** built-in dengan nama & versi

---

### 13. 🌿 Halaman Koleksi Tanaman
**File:** `lib/screens/main_nav/koleksi_fragment.dart`

- Menampilkan koleksi tanaman yang telah discan/disimpan pengguna

---

### 14. 🔌 Layanan Lainnya
**File:** `lib/services/`

| Layanan | File | Fungsi |
|---------|------|--------|
| Connectivity | `connectivity_service.dart` | Cek status koneksi internet real-time |
| Storage | `storage_service.dart` | Manajemen file lokal (path provider) |

---

### 15. 🧩 Komponen UI Reusable
**File:** `lib/widgets/`

| Widget | File | Deskripsi |
|--------|------|-----------|
| `AppButton` | `app_button.dart` | Tombol kustom konsisten tema |
| `AppTextField` | `app_text_field.dart` | Input field kustom |
| `SkeletonLoader` | `skeleton_loader.dart` | Loading placeholder shimmer |

---

### 16. 🧱 Model Data
**File:** `lib/models/`

| Model | File | Deskripsi |
|-------|------|-----------|
| `PlantDiagnosis` | `plant_diagnosis.dart` | Model hasil diagnosis API |
| `Plant` | `plant.dart` | Model data tanaman |
| `Article` | `article.dart` | Model artikel |
| `PlantCollection` | `plant_collection.dart` | Model koleksi tanaman |
| `DetectionHistory` | `detection_history.dart` | Model riwayat deteksi |
| `SavedItem` | `saved_item.dart` | Model item tersimpan |
| `TipItem` | `tip_item.dart` | Model tips harian |

---

### 17. ⚙️ Konfigurasi & Utilitas
**File:** `lib/config/`, `lib/utils/`

- `app_constants.dart` — Konstanta global (API URL, API Key, dsb.)
- `app_theme.dart` — Design system terpusat
- `logger.dart` — Utility logging (info, warning, error)
- `page_transitions.dart` — Custom page transitions (fade, slide+fade)

---

## 📦 Dependencies Utama

| Package | Versi | Fungsi |
|---------|-------|--------|
| `http` | ^1.2.0 | HTTP client untuk panggilan API |
| `image_picker` | ^1.0.7 | Ambil foto dari kamera/galeri |
| `camera` | ^0.10.5+9 | Akses kamera langsung |
| `image` | ^4.1.7 | Manipulasi gambar |
| `shared_preferences` | ^2.2.2 | Penyimpanan lokal (session & riwayat) |
| `provider` | ^6.1.1 | State management |
| `connectivity_plus` | ^5.0.2 | Cek koneksi internet |
| `path_provider` | ^2.1.2 | Path penyimpanan file lokal |
| `uuid` | ^4.3.3 | Generate ID unik untuk setiap scan |
| `google_fonts` | ^8.1.0 | Tipografi Poppins |

---

## 🗺️ Alur Navigasi Aplikasi

```
Splash Screen
    │
    ├── (sudah login) ──────────────────────────► Main Screen
    │                                                  │
    └── (belum login) ──► Welcome Screen (2 slide)     ├── [Tab 1] Home Fragment
                              │                        │       ├── Riwayat Screen
                              └──► Login Screen        │       ├── Artikel Screen
                                       │               │       ├── Tips Harian Screen
                                       └──► Main Screen│       └── Tersimpan Screen
                                                       │
                                                       ├── [FAB] Camera Screen
                                                       │       └── Diagnosis Result Screen
                                                       │
                                                       ├── [Tab 2] Koleksi Fragment
                                                       │
                                                       └── [Tab 3] Profil Fragment
                                                               └── (Logout) ──► Welcome Screen
```

---

## 📁 Struktur Direktori

```
lib/
├── main.dart                          # Entry point aplikasi
├── config/
│   ├── app_theme.dart                 # Design system & ThemeData
│   └── app_constants.dart             # Konstanta (API URL, Key)
├── models/
│   ├── plant_diagnosis.dart
│   ├── plant.dart
│   ├── article.dart
│   ├── plant_collection.dart
│   ├── detection_history.dart
│   ├── saved_item.dart
│   ├── tip_item.dart
│   └── models.dart                    # Barrel export
├── services/
│   ├── api_service.dart               # Integrasi Plant.id API
│   ├── history_service.dart           # Riwayat scan (SharedPreferences)
│   ├── connectivity_service.dart      # Cek koneksi
│   ├── storage_service.dart           # File storage
│   └── services.dart                  # Barrel export
├── screens/
│   ├── splash_screen.dart
│   ├── camera_screen.dart
│   ├── diagnosis_result_screen.dart
│   ├── auth/
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── main_nav/
│   │   ├── main_screen.dart
│   │   ├── home_fragment.dart
│   │   ├── koleksi_fragment.dart
│   │   └── profile_fragment.dart
│   └── menus/
│       ├── riwayat_screen.dart
│       ├── artikel_screen.dart
│       ├── tips_harian_screen.dart
│       └── tersimpan_screen.dart
├── widgets/
│   ├── app_button.dart
│   ├── app_text_field.dart
│   └── skeleton_loader.dart
├── utils/
│   ├── logger.dart
│   └── page_transitions.dart
└── assets/
    ├── ecology.png
    └── ecology 2.png
```

---

## 🚧 Fitur yang Masih Dalam Pengerjaan / TODO

- [ ] **Share hasil diagnosis** — tombol Share sudah ada di UI, namun fungsi belum diimplementasikan
- [ ] **Navigasi ke detail tanaman** dari plant card di Home (onTap masih TODO)
- [ ] **Implementasi penuh halaman Artikel** — data masih statis
- [ ] **Implementasi penuh halaman Tips Harian** — data masih statis
- [ ] **Implementasi halaman Tersimpan** — belum terhubung ke data bookmark nyata
- [ ] **Konfigurasi API Key** — masih menggunakan mock data jika key belum diisi
- [ ] **Koneksi Riwayat ke `HistoryService`** — tampilan home masih pakai data mock statis
- [ ] **Fitur edit profil** — tombol edit avatar belum berfungsi
- [ ] **Notifikasi** — menu Notifikasi di profil belum diimplementasikan

---

## 📝 Catatan Pengembangan

- Aplikasi menggunakan **mock data fallback** di `ApiService` jika API key Plant.id belum dikonfigurasi, sehingga bisa di-demo tanpa koneksi API berbayar.
- Seluruh hasil scan **otomatis tersimpan** ke `SharedPreferences` segera setelah diagnosis berhasil.
- Sistem navigasi menggunakan **custom page transitions** (`fade`, `slide+fade`) untuk pengalaman yang lebih halus.
- Tema global menggunakan **Material 3** dengan design token yang terpusat di `AppTheme`.

---

*Dokumen ini dibuat secara otomatis berdasarkan analisis kode sumber project — 4 Juli 2026*
