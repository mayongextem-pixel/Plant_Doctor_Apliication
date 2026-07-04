# Implementation Plan: Auth Flow & Navigation Routing — Plant Doctor

## Overview

Implementasi bertahap dimulai dari fondasi (shared widgets, models, validators), dilanjutkan dengan auth screens, kemudian main navigation refactor, top menu screens, lalu integrasi akhir dan tests. Setiap langkah menghasilkan kode yang bisa dikompilasi dan langsung terhubung ke langkah sebelumnya.

## Tasks

- [ ] 1. Buat shared widgets dan validators
  - [ ] 1.1 Buat `lib/utils/validators.dart` dengan class `Validators`
    - Implementasi 4 fungsi murni: `email`, `password`, `name`, `confirmPassword`
    - `email`: reject jika kosong, tidak mengandung `@`, atau tidak punya domain dengan titik
    - `password`: reject jika kosong atau panjang < 6
    - `name`: reject jika trimmed length < 2
    - `confirmPassword(passwordController)`: reject jika tidak sama dengan password controller value
    - _Requirements: 2.3, 2.4, 3.3, 3.4, 3.5, 3.6_

  - [ ] 1.2 Buat `lib/widgets/app_button.dart` dengan enum `AppButtonVariant` dan `AppButton`
    - Enum: `primary`, `outlined`
    - Primary: `ElevatedButton` dengan `backgroundColor: AppTheme.primaryGreen`
    - Outlined: `OutlinedButton` dengan `side: BorderSide(color: AppTheme.primaryGreen)`
    - Parameter: `label`, `onPressed`, `variant`, `isLoading` (default false), `width`, `leadingIcon`
    - `isLoading: true` mengganti label dengan `CircularProgressIndicator` kecil
    - Lebar default `double.infinity`
    - _Requirements: 13.4_

  - [ ] 1.3 Buat `lib/widgets/app_text_field.dart` dengan `AppTextField`
    - Parameter: `label`, `hint`, `controller`, `validator`, `obscureText`, `isPasswordField`, `keyboardType`, `prefixIcon`
    - `isPasswordField: true` menambahkan `IconButton` suffix untuk toggle visibility (`obscureText` state)
    - Gunakan `InputDecoration` dari `AppTheme.inputDecorationTheme`
    - _Requirements: 13.5_

  - [ ] 1.4 Buat `lib/widgets/skeleton_loader.dart` dengan `SkeletonLoader` dan `SkeletonGridLoader`
    - `SkeletonLoader`: `StatefulWidget` dengan `AnimationController` untuk shimmer gradient bergerak, parameter `width`, `height`, `borderRadius`
    - `SkeletonGridLoader`: `StatelessWidget` dengan `GridView` berisi `SkeletonLoader`, parameter `itemCount` (default 6), `crossAxisCount` (default 2)
    - _Requirements: 6.2, 13.4_

- [ ] 2. Buat data models baru
  - [ ] 2.1 Buat `lib/models/detection_history.dart` dengan class `DetectionHistory`
    - Fields: `id`, `plantName`, `detectionDate`, `isHealthy`, `diseaseName`, `placeholderIcon`
    - Sertakan static list `mockData` dengan minimal 5 item sesuai tabel di design doc
    - _Requirements: 9.2, 9.3_

  - [ ] 2.2 Buat `lib/models/plant_collection.dart` dengan class `PlantCollection`
    - Fields: `id`, `plantName`, `isHealthy`, `lastScanDate`, `placeholderIcon`
    - Sertakan static list `mockData` dengan minimal 6 item, campuran sehat dan sakit
    - _Requirements: 6.3, 6.4_

  - [ ] 2.3 Buat `lib/models/tip_item.dart` dengan enum `TipCategory` dan class `TipItem`
    - Enum: `penyiraman`, `pemupukan`, `pencahayaan`
    - Fields: `id`, `title`, `description`, `category`, `icon`
    - Mapping ikon: penyiraman→`water_drop_rounded`, pemupukan→`grass_rounded`, pencahayaan→`wb_sunny_rounded`
    - Sertakan static list `mockData` dengan minimal 5 item tersebar di 3 kategori
    - _Requirements: 11.2, 11.3, 11.4_

  - [ ] 2.4 Buat `lib/models/saved_item.dart` dengan enum `SavedItemType` dan class `SavedItem`
    - Enum: `tanaman`, `artikel`
    - Fields: `id`, `name`, `type`, `icon`
    - Sertakan static list `mockData` dengan minimal 4 item
    - _Requirements: 12.2, 12.3_

  - [ ] 2.5 Update `lib/models/models.dart` barrel export untuk include semua model baru
    - Tambahkan export untuk `detection_history.dart`, `plant_collection.dart`, `tip_item.dart`, `saved_item.dart`
    - _Requirements: 13.1_

- [ ] 3. Buat auth screens
  - [ ] 3.1 Buat `lib/screens/auth/welcome_screen.dart` dengan `WelcomeScreen`
    - Scaffold tanpa AppBar, `backgroundColor: AppTheme.backgroundColor`
    - Konten: `SafeArea` → `Column` → Spacer, ikon tanaman (80px, primaryGreen), Text "Plant Doctor" (displayLarge), Text tagline (bodyLarge), elemen dekoratif organik, Spacer, `AppButton(primary, "Masuk")`, `SizedBox(12)`, `AppButton(outlined, "Daftar")`
    - Navigasi Masuk → LoginScreen via `PageTransitions.slideAndFadeTransition`
    - Navigasi Daftar → RegisterScreen via `PageTransitions.slideAndFadeTransition`
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8_

  - [ ] 3.2 Buat `lib/screens/auth/login_screen.dart` dengan `LoginScreen`
    - Scaffold dengan AppBar ("Masuk", back button → WelcomeScreen)
    - `SingleChildScrollView` → `Padding(horizontal: 24)` → `Form(key: _formKey, autovalidateMode: onUserInteraction)`
    - Fields: `AppTextField(email, validator: Validators.email)`, `AppTextField(password, isPasswordField: true, validator: Validators.password)`
    - `AppButton(label: "Masuk", isLoading: _isLoading)` → validate → mock async delay → `pushAndRemoveUntil` ke MainScreen via `PageTransitions.fadeTransition`
    - Teks "Belum punya akun? Daftar" → navigasi ke RegisterScreen
    - Gunakan `if (mounted)` sebelum Navigator call di async callback
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 14.1, 14.2_

  - [ ] 3.3 Buat `lib/screens/auth/register_screen.dart` dengan `RegisterScreen`
    - Scaffold dengan AppBar ("Daftar", back button → WelcomeScreen)
    - `SingleChildScrollView` → `Padding(horizontal: 24)` → `Form(key: _formKey, autovalidateMode: onUserInteraction)`
    - Fields: `AppTextField(nama, validator: Validators.name)`, `AppTextField(email, validator: Validators.email)`, `AppTextField(password, isPasswordField: true, validator: Validators.password)`, `AppTextField(konfirmasi, isPasswordField: true, validator: Validators.confirmPassword(_passwordController))`
    - `AppButton(label: "Daftar", isLoading: _isLoading)` → validate → mock async delay → `pushAndRemoveUntil` ke MainScreen via `PageTransitions.fadeTransition`
    - Gunakan `if (mounted)` sebelum Navigator call di async callback
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10, 14.1, 14.2_

- [ ] 4. Checkpoint — Build auth module
  - Pastikan semua widget dan screen kompilasi tanpa error; jalankan `flutter analyze` untuk memverifikasi. Tanyakan jika ada pertanyaan.

- [ ] 5. Buat top menu screens
  - [ ] 5.1 Buat `lib/screens/menus/riwayat_screen.dart` dengan `RiwayatScreen`
    - Scaffold + AppBar("Riwayat Deteksi", back button) + SafeArea
    - `ListView.builder` dari `DetectionHistory.mockData`
    - Setiap item: `ListTile` dengan `leading: CircleAvatar(ikon tanaman)`, `title: plantName`, `subtitle: formatted detectionDate`, `trailing: Badge(isHealthy ? "Sehat" successGreen : "Terinfeksi" errorRed)`
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

  - [ ] 5.2 Buat `lib/screens/menus/artikel_screen.dart` dengan `ArtikelScreen`
    - Scaffold + AppBar("Artikel Tanaman", back button) + SafeArea
    - `ListView.builder` dari `MockData.articles` (data statis artikel yang juga digunakan ArtikelFragment)
    - Komponen kartu artikel yang bisa di-share dengan `ArtikelFragment` (ekstrak sebagai widget `_ArticleCard` terpisah di file ini)
    - _Requirements: 10.1, 10.2, 10.3, 10.4_

  - [ ] 5.3 Buat `lib/screens/menus/tips_harian_screen.dart` dengan `TipsHarianScreen`
    - Scaffold + AppBar("Tips Harian", back button) + SafeArea
    - `ListView.builder` dari `TipItem.mockData`
    - Setiap item: `Card` dengan `ListTile(leading: Icon(tip.icon, primaryGreen), title: tip.title, subtitle: tip.description)` + chip label kategori
    - _Requirements: 11.1, 11.2, 11.3, 11.4, 11.5_

  - [ ] 5.4 Buat `lib/screens/menus/tersimpan_screen.dart` dengan `TersimpanScreen`
    - Scaffold + AppBar("Tersimpan", back button) + SafeArea
    - `GridView.builder` 2 kolom dari `SavedItem.mockData`
    - Setiap item: `Card` dengan ikon, nama, chip tipe (tanaman/artikel)
    - _Requirements: 12.1, 12.2, 12.3, 12.4_

- [ ] 6. Buat main navigation (MainScreen + Fragments)
  - [ ] 6.1 Buat `lib/screens/main_nav/home_fragment.dart` dengan `HomeFragment`
    - Ekstrak seluruh body `DashboardScreen` (CustomScrollView, greeting AppBar, quick action menu, promotional banner, plant collection grid) ke widget `HomeFragment` baru
    - Update quick action menu items untuk navigasi ke top menu screens via `PageTransitions.slideAndFadeTransition`:
      - "Riwayat" → `RiwayatScreen`
      - "Artikel" → `ArtikelScreen`
      - "Tips Harian" → `TipsHarianScreen`
      - "Tersimpan" → `TersimpanScreen`
    - Pastikan tidak ada `BottomNavigationBar` atau `FAB` di dalam fragment ini
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 14.3_

  - [ ] 6.2 Buat `lib/screens/main_nav/koleksi_fragment.dart` dengan `KoleksiFragment`
    - `SafeArea` → `Column`: judul "Koleksi Tanamanku" (titleLarge) + `Expanded(FutureBuilder)`
    - `Future.delayed(Duration(seconds: 1, milliseconds: 500))` untuk simulasi loading
    - `ConnectionState.waiting` → `SkeletonGridLoader(itemCount: 6)`
    - Data loaded → `GridView.builder` 2 kolom dari `PlantCollection.mockData`
    - Setiap kartu: nama tanaman, ikon, badge status Sehat (successGreen) / Sakit (errorRed), tanggal scan
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

  - [ ] 6.3 Buat `lib/screens/main_nav/artikel_fragment.dart` dengan `ArtikelFragment`
    - `SafeArea` → `Column`: judul "Artikel Tanaman" + `Expanded(ListView.builder)`
    - Gunakan `MockData.articles` yang sama dengan `ArtikelScreen`
    - Gunakan `_ArticleCard` widget yang sama (import atau duplikasi jika perlu)
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

  - [ ] 6.4 Buat `lib/screens/main_nav/profil_fragment.dart` dengan `ProfilFragment`
    - `SafeArea` → `Column`: CircleAvatar (radius 48, primaryGreen), nama "Pengguna Demo", email "demo@plantdoctor.id", Divider, 4 ListTile pengaturan statis, Spacer, `AppButton(outlined, "Keluar")`
    - Tombol "Keluar" → `showDialog(barrierDismissible: false)` dengan pilihan "Batalkan" (pop dialog) dan "Keluar" (`pushAndRemoveUntil` ke WelcomeScreen)
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_

  - [ ] 6.5 Buat `lib/screens/main_nav/main_screen.dart` dengan `MainScreen`
    - `StatefulWidget` dengan `int _currentIndex = 0`
    - `IndexedStack(index: _currentIndex, children: [HomeFragment, KoleksiFragment, ArtikelFragment, ProfilFragment])`
    - `BottomAppBar(shape: CircularNotchedRectangle)` dengan `BottomNavigationBar` (4 item: Beranda, Koleksi, Artikel, Profil)
    - `FloatingActionButton` centerDocked, ikon kamera, warna `primaryGreen`, size 72, navigasi ke `CameraScreen` via `PageTransitions.scaleTransition`
    - `selectedItemColor: AppTheme.primaryGreen`, `unselectedItemColor: AppTheme.textLight`
    - `onTap: (i) => setState(() => _currentIndex = i)`
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7_

- [ ] 7. Update SplashScreen dan main.dart untuk routing ke WelcomeScreen
  - [ ] 7.1 Update `lib/screens/splash_screen.dart`
    - Ubah navigasi akhir animasi dari `DashboardScreen` → `WelcomeScreen`
    - Gunakan `PageTransitions.fadeTransition` untuk transisi ke WelcomeScreen
    - _Requirements: 1.1, 13.6_

  - [ ] 7.2 Verifikasi `lib/main.dart` masih menggunakan `SplashScreen` sebagai `home`
    - Pastikan `MaterialApp(home: SplashScreen())` sudah benar
    - Tidak perlu perubahan jika sudah menunjuk ke SplashScreen
    - _Requirements: 13.6_

- [ ] 8. Checkpoint — Build dan verifikasi navigasi lengkap
  - Jalankan `flutter analyze` untuk memastikan tidak ada error atau warning.
  - Verifikasi semua import antar file sudah benar.
  - Tanyakan jika ada pertanyaan sebelum lanjut ke testing.

- [ ] 9. Tulis unit dan property-based tests untuk validators
  - [ ] 9.1 Buat `test/unit/validators_test.dart` dengan unit tests contoh spesifik untuk `Validators`
    - Test `email`: valid ("a@b.com"), invalid ("", "notanemail", "@domain.com", "user@", "user@.com")
    - Test `password`: valid (length >= 6), invalid ("", "12345", "abc")
    - Test `name`: valid ("AB", "John Doe"), invalid ("", "A", "  ")
    - Test `confirmPassword`: cocok → null, tidak cocok → error message
    - _Requirements: 2.3, 2.4, 3.3, 3.5, 3.6_

  - [ ]* 9.2 Tulis property test untuk Property 1: Email Validator Consistency
    - **Property 1: Email Validator Consistency**
    - **Validates: Requirements 2.3, 3.4**
    - Generate 200 string random, verifikasi: validator accept ↔ string non-empty + tepat satu `@` + ada karakter sebelum `@` + ada `.` di bagian setelah `@`
    - Tambahkan komentar: `// Feature: plant-doctor-auth-navigation, Property 1: Email Validator Consistency`

  - [ ]* 9.3 Tulis property test untuk Property 2: Password Validator Length Invariant
    - **Property 2: Password Validator Length Invariant**
    - **Validates: Requirements 2.4, 3.5**
    - Generate 200 string random, verifikasi: validator accept ↔ `value.length >= 6`
    - Tambahkan komentar: `// Feature: plant-doctor-auth-navigation, Property 2: Password Validator Length Invariant`

  - [ ]* 9.4 Tulis property test untuk Property 3: Confirm Password Equality Check
    - **Property 3: Confirm Password Equality Check**
    - **Validates: Requirements 3.6**
    - Generate 200 pasang string (password, confirmPassword) termasuk edge cases (string kosong, Unicode, karakter spesial), verifikasi: validator accept ↔ `confirmPassword == password`
    - Tambahkan komentar: `// Feature: plant-doctor-auth-navigation, Property 3: Confirm Password Equality Check`

  - [ ]* 9.5 Tulis property test untuk Property 4: Name Validator Minimum Length
    - **Property 4: Name Validator Minimum Length**
    - **Validates: Requirements 3.3**
    - Generate 200 string random, verifikasi: validator accept ↔ `value.trim().length >= 2`
    - Tambahkan komentar: `// Feature: plant-doctor-auth-navigation, Property 4: Name Validator Minimum Length`

- [ ] 10. Tulis widget tests untuk screens utama
  - [ ] 10.1 Buat `test/widgets/auth/welcome_screen_test.dart`
    - Test: WelcomeScreen menampilkan teks "Plant Doctor", tombol "Masuk", dan tombol "Daftar"
    - _Requirements: 1.2, 1.4, 1.5_

  - [ ]* 10.2 Tulis widget tests untuk LoginScreen
    - Buat `test/widgets/auth/login_screen_test.dart`
    - Test: menampilkan 2 TextFormField, menampilkan error saat submit dengan field kosong
    - _Requirements: 2.1, 2.5_

  - [ ]* 10.3 Tulis widget tests untuk RegisterScreen
    - Buat `test/widgets/auth/register_screen_test.dart`
    - Test: menampilkan 4 TextFormField
    - _Requirements: 3.1_

  - [ ] 10.4 Buat `test/widgets/main_nav/main_screen_test.dart` dengan widget tests untuk `MainScreen`
    - Test: FAB ada di halaman, tapping tab index 1 mengubah `currentIndex`
    - _Requirements: 4.1, 4.3, 4.4_

  - [ ]* 10.5 Tulis property test untuk Property 5: Tab Index to Fragment Mapping Consistency
    - **Property 5: Tab Index to Fragment Mapping Consistency**
    - **Validates: Requirements 4.2, 4.3**
    - Iterasi semua index valid `{0, 1, 2, 3}`, simulasi tap tab, verifikasi: `IndexedStack` menampilkan fragment yang benar di posisi index tersebut
    - Tambahkan komentar: `// Feature: plant-doctor-auth-navigation, Property 5: Tab Index to Fragment Mapping Consistency`

  - [ ]* 10.6 Tulis widget tests untuk KoleksiFragment dan property test untuk Property 6
    - Buat `test/widgets/main_nav/koleksi_fragment_test.dart`
    - Test: `SkeletonLoader` muncul saat loading (fake async), hilang setelah 1,5 detik
    - **Property 6: Health Status Badge Correctness**
    - **Validates: Requirements 6.4, 9.4**
    - Iterasi semua item `PlantCollection.mockData` dan `DetectionHistory.mockData`, verifikasi: badge "Sehat" + `successGreen` ↔ `isHealthy == true`, badge "Sakit/Terinfeksi" + `errorRed` ↔ `isHealthy == false`
    - Tambahkan komentar: `// Feature: plant-doctor-auth-navigation, Property 6: Health Status Badge Correctness`

  - [ ]* 10.7 Tulis widget test untuk ProfilFragment
    - Buat `test/widgets/main_nav/profil_fragment_test.dart`
    - Test: dialog konfirmasi muncul saat tombol "Keluar" ditekan
    - _Requirements: 8.5_

- [ ] 11. Final checkpoint — Semua tests pass
  - Jalankan `flutter test` untuk memastikan semua unit dan widget tests lulus.
  - Jalankan `flutter analyze` untuk memastikan tidak ada linting error.
  - Tanyakan jika ada pertanyaan sebelum dianggap selesai.

## Notes

- Tasks bertanda `*` adalah opsional (property-based tests dan beberapa widget tests) dan dapat dilewati untuk MVP lebih cepat
- `DashboardScreen` lama (`lib/screens/dashboard_screen.dart`) bisa dipertahankan sementara sebagai referensi saat mengekstrak body ke `HomeFragment`, lalu bisa dihapus atau dibiarkan deprecated
- Semua mock data dibuat sebagai static list di dalam masing-masing model class agar mudah diakses
- Property tests menggunakan `dart:math` `Random` tanpa library tambahan, sesuai `dev_dependencies` yang ada
- Setiap property test dijalankan minimal 200 iterasi untuk validator, 100 iterasi untuk widget tests

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1", "1.2", "1.3", "1.4"] },
    { "id": 1, "tasks": ["2.1", "2.2", "2.3", "2.4"] },
    { "id": 2, "tasks": ["2.5", "3.1", "3.2", "3.3"] },
    { "id": 3, "tasks": ["5.1", "5.2", "5.3", "5.4", "6.1"] },
    { "id": 4, "tasks": ["6.2", "6.3", "6.4"] },
    { "id": 5, "tasks": ["6.5"] },
    { "id": 6, "tasks": ["7.1", "7.2"] },
    { "id": 7, "tasks": ["9.1", "10.1", "10.4"] },
    { "id": 8, "tasks": ["9.2", "9.3", "9.4", "9.5", "10.2", "10.3", "10.5", "10.6", "10.7"] }
  ]
}
```
