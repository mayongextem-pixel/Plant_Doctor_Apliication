# Update Spesifikasi V2 - Plant Doctor (Screen & Routing Expansion)

## 1. Authentication Flow (Welcome, Login, Register)
Buat modul Auth dengan UI yang *clean* dan minimalis.
* **Welcome Screen:**
  * Berisi Logo aplikasi, teks *tagline* (contoh: "Rawat Tanamanmu dengan AI"), dan ilustrasi vektor sederhana.
  * Dua tombol utama: `Login` (Primary Button - Hijau) dan `Daftar` (Outlined/Secondary Button).
* **Login Screen:**
  * Form input: `Email` dan `Password` (gunakan `TextFormField` dengan *basic validation*).
  * Tombol `Masuk` -> Jika berhasil (mock success), *route* ke `MainScreen` (berisi BottomNavBar).
* **Register Screen:**
  * Form input: `Nama Lengkap`, `Email`, `Password`, dan `Konfirmasi Password`.
  * Tombol `Daftar` -> Jika berhasil, *route* kembali ke `Login Screen` atau langsung ke `MainScreen`.

## 2. Top Menu Screens (Grid Menu)
Berdasarkan UI di Beranda, terdapat 4 menu di atas. Buatkan *Screen* terpisah untuk masing-masing menu dengan *Scaffold* dan `AppBar` ber-opsi *Back Button*. Gunakan *Mock Data* (data statis) untuk mengisi kontennya:
1. **RiwayatScreen (`/riwayat`):** Menampilkan `ListView` dari riwayat deteksi penyakit (Gambar thumbnail kecil, tanggal, status penyakit).
2. **ArtikelScreen (`/artikel`):** Menampilkan *list* artikel terkait tanaman. (*Catatan: Screen ini bisa digunakan ulang/share state dengan tab Artikel di Bottom NavBar*).
3. **TipsHarianScreen (`/tips-harian`):** Menampilkan *Card* berisi tips penyiraman, pemupukan, dan pencahayaan.
4. **TersimpanScreen (`/tersimpan`):** Menampilkan *Grid* atau *List* tanaman/artikel yang di-bookmark oleh pengguna.

## 3. Bottom Navigation Bar & Main Screen
Refaktor halaman utama untuk menggunakan `BottomNavigationBar` (atau `NavigationMenuBar`) untuk mengatur *state* index halaman.
* **Struktur MainScreen (`/main`):**
  * `currentIndex` untuk melacak tab aktif.
  * `FloatingActionButton` (FAB) berada di tengah (Docked/Center) dengan ikon Kamera warna Hijau. Jika di-klik, membuka `CameraScreen` / Alur deteksi (sudah didefinisikan di tahap 1).
* **Tab Items (Indexed Stack / PageView):**
  1. **Index 0 - Beranda (`HomeFragment`):** UI Dashboard yang saat ini sudah ada.
  2. **Index 1 - Koleksi (`KoleksiFragment`):** Menampilkan *Grid* semua koleksi tanaman pengguna (Gunakan UI *Skeleton loading* sebentar, lalu tampilkan mock data tanaman sehat/sakit).
  3. **Index 2 - Artikel (`ArtikelFragment`):** *List* vertikal artikel perawatan tanaman.
  4. **Index 3 - Profil (`ProfilFragment`):** Menampilkan Avatar pengguna, Nama, Email, pengaturan akun statis, dan tombol `Logout` (Kembali ke Welcome Screen).

## 4. Technical Rules & Constraints
* **State Management & Routing:** Gunakan navigasi bawaan `Navigator.push/pop` atau `go_router` (pilih yang paling ringkas).
* **Modularisasi File:** Pisahkan UI ke dalam direktori seperti:
  * `lib/screens/auth/`
  * `lib/screens/main_nav/`
  * `lib/screens/menus/`
* **Widgets:** Gunakan `SafeArea`, konsisten dengan `Padding`, dan manfaatkan komponen kustom jika ada tombol atau *Textfield* yang dipakai berulang.
* **Animasi:** Berikan transisi *fade* atau *slide* sederhana antar *screen* agar tidak kaku.