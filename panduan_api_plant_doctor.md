# Panduan Plant Doctor API

Dokumen ini berisi informasi kredensial untuk login serta panduan cara menjalankan dan memulai ulang aplikasi backend (API) Laravel.

---

## 🔐 Kredensial Login Default

Sistem ini menggunakan Laravel Sanctum untuk autentikasi berbasis Token. Saat Anda melakukan request login, API akan mengembalikan `token` yang harus Anda pasang di header Authorization: `Bearer {token}` pada request-request selanjutnya.

### 1. Akun Administrator (Admin)
Digunakan untuk mengelola semua koleksi, membuat/mengedit artikel, dan menghapus data.
* **Email**: `admin@plantdoctor.com`
* **Password**: `admin12345`

### 2. Akun Pengguna Biasa (User)
Digunakan untuk fitur user reguler (menambah riwayat scan pribadi, simpan artikel, dll).
* **Email**: `user@plantdoctor.com`
* **Password**: `user12345`

> **Catatan:** Anda juga bisa mendaftarkan pengguna baru dengan melakukan HTTP POST ke endpoint `/api/auth/register` menggunakan data `name`, `email`, `password`, dan `password_confirmation`.

---

## 🚀 Cara Menjalankan Ulang Aplikasi Setelah Update

Jika Anda mematikan laptop, menutup terminal, atau melakukan perubahan kode pada sistem API, ikuti langkah-langkah di bawah ini untuk menjalankannya kembali:

### Langkah 1: Pastikan Database Aktif
1. Buka aplikasi **Laragon** (atau XAMPP).
2. Klik tombol **Start All** untuk menyalakan server MySQL.

### Langkah 2: Buka Terminal di Folder Proyek
1. Buka Terminal / Command Prompt / VS Code Terminal.
2. Arahkan direktori (cd) ke folder aplikasi backend:
   ```bash
   cd "D:\SEMESTER 4\PEMOGRAMAN MOBILE\UAS MOBILE\plant_doctor_api"
   ```

### Langkah 3: Menjalankan Server Laravel
Jalankan perintah berikut di dalam terminal tersebut:
```bash
php artisan serve
```
> Server akan berjalan secara default di `http://127.0.0.1:8000`. Biarkan terminal ini tetap terbuka agar API bisa diakses oleh aplikasi Flutter Anda.

### (Opsional) Langkah 4: Jika Ada Perubahan Database
Jika suatu saat Anda atau tim mengubah struktur tabel (migration) atau menambah data dummy baru (seeder), Anda wajib me-reset dan mengisi ulang database dengan perintah ini:
```bash
php artisan migrate:fresh --seed
```
*(⚠️ Perhatian: Perintah ini akan **menghapus semua data** yang ada di database Anda dan menggantinya dengan data dummy dari awal).*
