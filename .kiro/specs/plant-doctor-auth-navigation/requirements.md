# Requirements Document

## Introduction

Fitur ini menambahkan modul Authentication (Auth) dan refaktor navigasi utama pada aplikasi Flutter "Plant Doctor" — aplikasi deteksi penyakit tanaman berbasis AI dengan tema warna hijau-putih. Cakupan pekerjaan meliputi tiga area utama:

1. **Authentication Flow**: Welcome Screen, Login Screen, dan Register Screen dengan UI clean dan minimalis.
2. **Top Menu Screens**: Empat screen terpisah (Riwayat, Artikel, Tips Harian, Tersimpan) yang diakses dari Quick Action menu di Beranda.
3. **Bottom Navigation Bar & Main Screen**: Refaktor DashboardScreen menjadi MainScreen dengan BottomNavigationBar, IndexedStack untuk empat tab (Beranda, Koleksi, Artikel, Profil), dan FloatingActionButton kamera di tengah.

Aplikasi ini sudah memiliki desain sistem hijau-putih (AppTheme), transisi halaman (PageTransitions), dan screen kamera yang harus dipertahankan. State management menggunakan Provider yang sudah tersedia di pubspec, routing menggunakan Navigator.push/pop bawaan Flutter.

---

## Glossary

- **App**: Aplikasi Flutter "Plant Doctor".
- **Auth_Module**: Modul autentikasi yang mencakup WelcomeScreen, LoginScreen, dan RegisterScreen.
- **WelcomeScreen**: Halaman pertama setelah SplashScreen; pintu masuk ke alur autentikasi.
- **LoginScreen**: Halaman form masuk dengan input Email dan Password.
- **RegisterScreen**: Halaman form daftar akun baru.
- **MainScreen**: Halaman utama pasca-login yang memuat BottomNavigationBar dan IndexedStack.
- **HomeFragment**: Widget beranda (tab index 0) berisi UI Dashboard yang sudah ada.
- **KoleksiFragment**: Widget koleksi tanaman (tab index 1) dengan skeleton loading dan mock data.
- **ArtikelFragment**: Widget daftar artikel (tab index 2).
- **ProfilFragment**: Widget profil pengguna (tab index 3) dengan tombol Logout.
- **RiwayatScreen**: Screen riwayat deteksi penyakit dengan ListView.
- **ArtikelScreen**: Screen daftar artikel yang dapat digunakan bersama ArtikelFragment.
- **TipsHarianScreen**: Screen tips perawatan tanaman harian.
- **TersimpanScreen**: Screen koleksi tanaman/artikel yang di-bookmark.
- **CameraScreen**: Screen kamera yang sudah ada untuk alur deteksi.
- **Mock_Data**: Data statis yang digunakan sebagai pengganti data dari API/backend.
- **Validator**: Komponen validasi form input.
- **AppTheme**: Design system warna dan tipografi hijau-putih yang sudah ada.
- **PageTransitions**: Utilitas transisi animasi antar halaman yang sudah ada.
- **BottomNavigationBar**: Komponen navigasi bawah dengan empat tab.
- **IndexedStack**: Widget Flutter untuk menyimpan state semua tab aktif.
- **FloatingActionButton**: Tombol aksi melayang untuk membuka CameraScreen.
- **SkeletonLoader**: Komponen placeholder loading berbentuk skeleton/shimmer.

---

## Requirements

### Requirement 1: Welcome Screen

**User Story:** Sebagai pengguna baru, saya ingin melihat halaman sambutan yang menarik setelah splash screen, agar saya dapat memilih untuk masuk atau mendaftar.

#### Acceptance Criteria

1. THE App SHALL menampilkan WelcomeScreen sebagai halaman setelah SplashScreen selesai.
2. THE WelcomeScreen SHALL menampilkan ikon logo aplikasi (ikon tanaman), teks judul "Plant Doctor", dan tagline "Rawat Tanamanmu dengan AI".
3. THE WelcomeScreen SHALL menampilkan ilustrasi dekoratif berupa bentuk organik atau ikon tanaman sebagai elemen visual latar.
4. THE WelcomeScreen SHALL menyediakan tombol primary berwarna hijau dengan label "Masuk" yang menavigasi ke LoginScreen.
5. THE WelcomeScreen SHALL menyediakan tombol outlined/secondary dengan label "Daftar" yang menavigasi ke RegisterScreen.
6. WHEN pengguna menekan tombol "Masuk", THE App SHALL menavigasi ke LoginScreen menggunakan transisi slide atau fade dari PageTransitions.
7. WHEN pengguna menekan tombol "Daftar", THE App SHALL menavigasi ke RegisterScreen menggunakan transisi slide atau fade dari PageTransitions.
8. THE WelcomeScreen SHALL menggunakan warna, tipografi, dan spacing yang konsisten dengan AppTheme.

---

### Requirement 2: Login Screen

**User Story:** Sebagai pengguna terdaftar, saya ingin masuk ke aplikasi menggunakan email dan password, agar saya dapat mengakses fitur utama.

#### Acceptance Criteria

1. THE LoginScreen SHALL menampilkan form dengan dua field input: Email dan Password menggunakan TextFormField.
2. THE LoginScreen SHALL menampilkan AppBar dengan back button untuk kembali ke WelcomeScreen.
3. THE Validator SHALL memvalidasi bahwa field Email tidak kosong dan mengandung format email yang valid (mengandung karakter "@" dan domain).
4. THE Validator SHALL memvalidasi bahwa field Password tidak kosong dan memiliki panjang minimal 6 karakter.
5. IF field Email atau Password tidak valid saat tombol "Masuk" ditekan, THEN THE Validator SHALL menampilkan pesan error di bawah field yang tidak valid.
6. WHEN pengguna menekan tombol "Masuk" dan semua validasi lolos, THE App SHALL mensimulasikan proses autentikasi berhasil (mock success) dan menavigasi ke MainScreen.
7. THE App SHALL menggantikan seluruh tumpukan navigasi (pushReplacement atau pushAndRemoveUntil) saat menavigasi ke MainScreen agar pengguna tidak dapat kembali ke LoginScreen dengan tombol back.
8. THE LoginScreen SHALL menyediakan tautan atau tombol teks "Belum punya akun? Daftar" yang menavigasi ke RegisterScreen.
9. THE LoginScreen SHALL menggunakan SafeArea, Padding konsisten, dan komponen form yang sesuai dengan AppTheme.

---

### Requirement 3: Register Screen

**User Story:** Sebagai pengguna baru, saya ingin membuat akun baru dengan mengisi data diri saya, agar saya dapat menggunakan fitur aplikasi.

#### Acceptance Criteria

1. THE RegisterScreen SHALL menampilkan form dengan empat field input: Nama Lengkap, Email, Password, dan Konfirmasi Password menggunakan TextFormField.
2. THE RegisterScreen SHALL menampilkan AppBar dengan back button untuk kembali ke WelcomeScreen.
3. THE Validator SHALL memvalidasi bahwa field Nama Lengkap tidak kosong dan memiliki panjang minimal 2 karakter.
4. THE Validator SHALL memvalidasi bahwa field Email tidak kosong dan mengandung format email yang valid.
5. THE Validator SHALL memvalidasi bahwa field Password tidak kosong dan memiliki panjang minimal 6 karakter.
6. THE Validator SHALL memvalidasi bahwa field Konfirmasi Password identik dengan nilai field Password.
7. IF salah satu field tidak valid saat tombol "Daftar" ditekan, THEN THE Validator SHALL menampilkan pesan error di bawah field yang tidak valid.
8. WHEN pengguna menekan tombol "Daftar" dan semua validasi lolos, THE App SHALL mensimulasikan proses pendaftaran berhasil (mock success) dan menavigasi ke MainScreen.
9. THE App SHALL menggantikan seluruh tumpukan navigasi saat menavigasi ke MainScreen agar pengguna tidak dapat kembali ke RegisterScreen.
10. THE RegisterScreen SHALL menggunakan SafeArea, Padding konsisten, dan komponen form yang sesuai dengan AppTheme.

---

### Requirement 4: Main Screen dengan Bottom Navigation Bar

**User Story:** Sebagai pengguna yang sudah masuk, saya ingin menggunakan navigasi bawah untuk berpindah antar fitur utama, agar pengalaman navigasi terasa intuitif dan modern.

#### Acceptance Criteria

1. THE MainScreen SHALL menampilkan BottomNavigationBar dengan empat tab: Beranda (index 0), Koleksi (index 1), Artikel (index 2), dan Profil (index 3).
2. THE MainScreen SHALL menggunakan IndexedStack untuk menampilkan konten tab yang sesuai dengan currentIndex, sehingga state setiap tab dipertahankan saat berpindah tab.
3. WHEN pengguna menekan item tab, THE MainScreen SHALL memperbarui currentIndex dan menampilkan fragment yang sesuai.
4. THE MainScreen SHALL menampilkan FloatingActionButton di posisi centerDocked dengan ikon kamera berwarna hijau (sesuai AppTheme.primaryGreen).
5. WHEN pengguna menekan FloatingActionButton, THE App SHALL menavigasi ke CameraScreen menggunakan transisi dari PageTransitions.
6. THE BottomNavigationBar SHALL menggunakan warna selected item AppTheme.primaryGreen dan unselected item AppTheme.textLight.
7. THE MainScreen SHALL menampilkan BottomAppBar dengan notch di tengah untuk mengakomodasi FloatingActionButton.

---

### Requirement 5: Home Fragment (Tab Beranda)

**User Story:** Sebagai pengguna, saya ingin melihat dashboard beranda yang sudah ada di tab pertama, agar saya dapat mengakses fitur utama dari satu tempat.

#### Acceptance Criteria

1. THE HomeFragment SHALL menampilkan seluruh UI Dashboard yang sudah ada dari DashboardScreen (search bar, quick action menu, banner tips, grid koleksi).
2. THE HomeFragment SHALL menavigasi ke RiwayatScreen ketika item "Riwayat" di quick action menu ditekan.
3. THE HomeFragment SHALL menavigasi ke ArtikelScreen ketika item "Artikel" di quick action menu ditekan.
4. THE HomeFragment SHALL menavigasi ke TipsHarianScreen ketika item "Tips Harian" di quick action menu ditekan.
5. THE HomeFragment SHALL menavigasi ke TersimpanScreen ketika item "Tersimpan" di quick action menu ditekan.
6. THE HomeFragment SHALL menggunakan AppTheme yang konsisten dan tidak menduplikasi BottomNavigationBar.

---

### Requirement 6: Koleksi Fragment (Tab Koleksi)

**User Story:** Sebagai pengguna, saya ingin melihat semua koleksi tanaman saya dalam tampilan grid, agar saya dapat mengelola tanaman dengan mudah.

#### Acceptance Criteria

1. THE KoleksiFragment SHALL menampilkan grid dua kolom berisi kartu tanaman menggunakan GridView.
2. WHEN KoleksiFragment pertama kali ditampilkan, THE SkeletonLoader SHALL menampilkan placeholder skeleton selama durasi 1,5 detik sebelum data muncul.
3. AFTER durasi skeleton selesai, THE KoleksiFragment SHALL menampilkan Mock_Data tanaman yang mencakup minimal 6 item dengan atribut nama tanaman, status kesehatan, dan tanggal scan.
4. THE KoleksiFragment SHALL menampilkan badge status "Sehat" (warna AppTheme.successGreen) atau "Sakit" (warna AppTheme.errorRed) pada setiap kartu tanaman.
5. THE KoleksiFragment SHALL menggunakan AppBar atau judul bagian dengan label "Koleksi Tanamanku".

---

### Requirement 7: Artikel Fragment (Tab Artikel)

**User Story:** Sebagai pengguna, saya ingin membaca artikel perawatan tanaman dari tab Artikel, agar saya dapat memperluas pengetahuan saya.

#### Acceptance Criteria

1. THE ArtikelFragment SHALL menampilkan ListView vertikal berisi kartu artikel.
2. THE ArtikelFragment SHALL menggunakan Mock_Data artikel yang mencakup minimal 5 item dengan atribut judul, deskripsi singkat, kategori, dan tanggal publikasi.
3. THE ArtikelFragment SHALL menampilkan judul bagian "Artikel Tanaman".
4. THE ArtikelFragment SHALL menggunakan model data Article yang sudah ada di `lib/models/article.dart`.

---

### Requirement 8: Profil Fragment (Tab Profil)

**User Story:** Sebagai pengguna, saya ingin melihat profil saya dan dapat keluar dari akun, agar saya dapat mengelola sesi penggunaan aplikasi.

#### Acceptance Criteria

1. THE ProfilFragment SHALL menampilkan avatar pengguna berupa ikon placeholder berbentuk lingkaran berwarna AppTheme.primaryGreen.
2. THE ProfilFragment SHALL menampilkan nama pengguna dan alamat email (menggunakan Mock_Data statis, contoh: "Pengguna Demo" dan "demo@plantdoctor.id").
3. THE ProfilFragment SHALL menampilkan daftar pengaturan statis berupa ListTile yang mencakup: Notifikasi, Bahasa, Tentang Aplikasi, dan Kebijakan Privasi.
4. THE ProfilFragment SHALL menampilkan tombol "Keluar" di bagian bawah.
5. WHEN pengguna menekan tombol "Keluar", THE App SHALL menampilkan dialog konfirmasi dengan dua pilihan: "Batalkan" dan "Keluar".
6. WHEN pengguna mengkonfirmasi "Keluar" pada dialog, THE App SHALL menavigasi ke WelcomeScreen dan menghapus seluruh tumpukan navigasi.

---

### Requirement 9: Riwayat Screen

**User Story:** Sebagai pengguna, saya ingin melihat riwayat deteksi penyakit tanaman saya, agar saya dapat memantau kondisi tanaman dari waktu ke waktu.

#### Acceptance Criteria

1. THE RiwayatScreen SHALL menampilkan AppBar dengan judul "Riwayat Deteksi" dan back button.
2. THE RiwayatScreen SHALL menampilkan ListView dari riwayat deteksi penyakit menggunakan Mock_Data.
3. THE Mock_Data untuk RiwayatScreen SHALL mencakup minimal 5 item dengan atribut: gambar thumbnail (placeholder ikon), nama tanaman, tanggal deteksi, dan status penyakit (Sehat/Terinfeksi).
4. THE RiwayatScreen SHALL menampilkan badge status berwarna AppTheme.successGreen untuk "Sehat" dan AppTheme.errorRed untuk "Terinfeksi".
5. THE RiwayatScreen SHALL menggunakan SafeArea dan Padding konsisten dengan AppTheme.

---

### Requirement 10: Artikel Screen (Top Menu)

**User Story:** Sebagai pengguna, saya ingin mengakses daftar artikel dari menu Artikel di beranda, agar saya dapat membaca konten tanpa harus beralih ke tab bawah.

#### Acceptance Criteria

1. THE ArtikelScreen SHALL menampilkan AppBar dengan judul "Artikel Tanaman" dan back button.
2. THE ArtikelScreen SHALL menampilkan ListView vertikal berisi kartu artikel menggunakan Mock_Data.
3. THE ArtikelScreen SHALL menggunakan data dan komponen tampilan yang sama dengan ArtikelFragment untuk konsistensi.
4. THE ArtikelScreen SHALL menggunakan SafeArea dan Padding konsisten dengan AppTheme.

---

### Requirement 11: Tips Harian Screen

**User Story:** Sebagai pengguna, saya ingin membaca tips perawatan tanaman harian, agar saya dapat merawat tanaman dengan lebih baik.

#### Acceptance Criteria

1. THE TipsHarianScreen SHALL menampilkan AppBar dengan judul "Tips Harian" dan back button.
2. THE TipsHarianScreen SHALL menampilkan ListView dari Card berisi tips perawatan menggunakan Mock_Data.
3. THE Mock_Data untuk TipsHarianScreen SHALL mencakup minimal 5 item tips yang dibagi dalam kategori: Penyiraman, Pemupukan, dan Pencahayaan.
4. THE TipsHarianScreen SHALL menampilkan ikon yang relevan untuk setiap kategori tips (contoh: ikon tetes air untuk Penyiraman).
5. THE TipsHarianScreen SHALL menggunakan SafeArea dan Padding konsisten dengan AppTheme.

---

### Requirement 12: Tersimpan Screen

**User Story:** Sebagai pengguna, saya ingin melihat daftar tanaman atau artikel yang telah saya bookmark, agar saya dapat mengaksesnya dengan cepat.

#### Acceptance Criteria

1. THE TersimpanScreen SHALL menampilkan AppBar dengan judul "Tersimpan" dan back button.
2. THE TersimpanScreen SHALL menampilkan GridView dua kolom berisi kartu item tersimpan menggunakan Mock_Data.
3. THE Mock_Data untuk TersimpanScreen SHALL mencakup minimal 4 item dengan atribut nama item, tipe (tanaman/artikel), dan ikon bookmark.
4. THE TersimpanScreen SHALL menggunakan SafeArea dan Padding konsisten dengan AppTheme.

---

### Requirement 13: Struktur File dan Modularisasi

**User Story:** Sebagai developer, saya ingin kode diorganisir dalam struktur direktori yang jelas, agar proyek mudah dipelihara dan dikembangkan.

#### Acceptance Criteria

1. THE App SHALL mengorganisir file screen autentikasi di direktori `lib/screens/auth/` (WelcomeScreen, LoginScreen, RegisterScreen).
2. THE App SHALL mengorganisir file screen navigasi utama di direktori `lib/screens/main_nav/` (MainScreen, HomeFragment, KoleksiFragment, ArtikelFragment, ProfilFragment).
3. THE App SHALL mengorganisir file top menu screen di direktori `lib/screens/menus/` (RiwayatScreen, ArtikelScreen, TipsHarianScreen, TersimpanScreen).
4. THE App SHALL menyediakan komponen tombol reusable (AppButton) di direktori `lib/widgets/` yang mendukung variant primary dan outlined.
5. THE App SHALL menyediakan komponen TextField reusable (AppTextField) di direktori `lib/widgets/` yang konsisten dengan AppTheme.inputDecorationTheme.
6. THE App SHALL memperbarui file `lib/main.dart` agar SplashScreen menavigasi ke WelcomeScreen (bukan langsung ke DashboardScreen).

---

### Requirement 14: Animasi dan Transisi

**User Story:** Sebagai pengguna, saya ingin transisi antar halaman terasa halus dan tidak kaku, agar pengalaman menggunakan aplikasi terasa modern dan nyaman.

#### Acceptance Criteria

1. WHEN navigasi dari WelcomeScreen ke LoginScreen atau RegisterScreen, THE App SHALL menggunakan PageTransitions.slideAndFadeTransition atau PageTransitions.slideTransition.
2. WHEN navigasi dari LoginScreen atau RegisterScreen ke MainScreen, THE App SHALL menggunakan PageTransitions.fadeTransition.
3. WHEN navigasi ke salah satu top menu screen (RiwayatScreen, ArtikelScreen, TipsHarianScreen, TersimpanScreen), THE App SHALL menggunakan PageTransitions.slideAndFadeTransition.
4. WHEN navigasi ke CameraScreen dari FloatingActionButton, THE App SHALL menggunakan PageTransitions.scaleTransition atau PageTransitions.slideAndFadeTransition.
