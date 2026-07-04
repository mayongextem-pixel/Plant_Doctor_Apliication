# Prompt Vibe Coding untuk Aplikasi Pemindai Tanaman

Gunakan prompt di bawah ini pada AI asisten (seperti Cursor, GitHub Copilot, atau ChatGPT) untuk membangun aplikasi Anda. Anda bisa menyesuaikan bagian dalam kurung siku `[...]` jika diperlukan.

---

**Prompt:**

"Tolong buatkan kode untuk aplikasi mobile (misalnya menggunakan Flutter) dengan fitur dan antarmuka sebagai berikut:

1. **Global Styling & Tema:**
   - Gunakan font **Poppins** untuk seluruh tipografi dalam aplikasi.
   - Tema warna utama menggunakan kombinasi putih (background utama) dan hijau (untuk tombol, aksen, dan beberapa teks), mengambil inspirasi dari desain onboarding yang bersih.

2. **Welcome Screen (Onboarding):**
   - Buat 2 halaman Welcome Screen yang muncul pertama kali saat aplikasi dibuka (sebelum halaman login/daftar).
   - Gunakan 2 gambar yang sudah ada di dalam folder `lib/assets/` (satu gambar untuk screen pertama, satu lagi untuk screen kedua).
   - **UI Screen 1:** Tampilkan gambar pertama di tengah, teks judul (misal: tulisan warna hitam dan hijau), deskripsi singkat di bawahnya. Di bagian paling bawah, letakkan indikator halaman (3 dots, dot pertama aktif) di sebelah kiri, dan tombol kecil **'Next'** (background hijau, teks gelap) di sebelah kanan.
   - **UI Screen 2:** Tampilkan logo aplikasi di atas, gambar kedua di tengah, judul, dan deskripsi singkat. Di bagian bawah, buat satu tombol lebar di tengah bertuliskan **'Lets Started'** (background hijau) yang berfungsi mengarahkan pengguna ke halaman Daftar/Login.

3. **Sistem Autentikasi (Login & Register):**
   - Buat halaman Daftar Akun dan Login.
   - Sistem login harus berjalan secara dinamis. Validasi data pengguna: jika email atau password yang dimasukkan salah saat login, tolak akses masuk dan tampilkan pesan error yang jelas (misal melalui Snackbar).
   - Sediakan tombol **Logout (Keluar Akun)** di dalam halaman profil/pengaturan yang berfungsi menghapus sesi login dan mengembalikan pengguna ke halaman Login.

4. **Fitur Inti (Scan & Riwayat):**
   - Sediakan fitur simulasi/integrasi scan tanaman.
   - Setelah scan berhasil dan hasil (result) keluar, **wajib simpan data hasil scan tersebut** secara lokal (misal dengan SQLite atau SharedPreferences) maupun cloud (jika pakai Firebase).
   - Tampilkan data yang sudah disimpan tersebut di halaman **Riwayat (History)** dan bagian lain yang relevan di dalam aplikasi agar pengguna bisa melihat riwayat scan tanaman mereka sebelumnya."

---
