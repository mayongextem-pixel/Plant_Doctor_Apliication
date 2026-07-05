# Dokumen Pembaruan & Spesifikasi Aplikasi Plant Doctor (REST API Laravel)

## 1. Arsitektur Backend & Database
* **Arsitektur:** Mengubah aplikasi menjadi sistem berbasis **REST API** menggunakan framework **Laravel**.
* **Database:** Menggunakan sistem manajemen basis data **MySQL** (di-host secara lokal menggunakan Laragon).
* **Nama Database:** `Plant_Doctor`

## 2. Manajemen Peran (Role Management) & Hak Akses
* **Penambahan Role Admin:** Menambahkan sistem role (peran) pada tabel pengguna, secara spesifik menambahkan role `admin`.
* **Akses Admin (CRUD):** Admin diberikan hak akses penuh untuk membuat (Create), membaca (Read), mengubah (Update), dan menghapus (Delete) data pada **Koleksi Tanamanku** (seperti status tanaman sehat/sakit, tanggal scan, dll) yang nantinya tampil pada user page (merujuk pada halaman koleksi yang berisi Monstera Deliciosa, Sansevieria, dll).

## 3. Autentikasi Pengguna (Login & Register)
* **Sistem Auth:** Menggunakan Laravel Sanctum atau Laravel Passport untuk memproduksi Bearer Token guna kebutuhan REST API.
* **Penyimpanan Data:** Seluruh data pengguna yang mendaftar maupun masuk akan disimpan, diverifikasi, dan ditarik dari database `Plant_Doctor` di MySQL (Laragon).

## 4. Validasi Pendaftaran Akun Baru
Endpoint untuk registrasi (`/api/register`) akan dilengkapi dengan validasi data yang ketat untuk menjaga keamanan dan integritas data:
* **Nama Lengkap:** Wajib diisi (`required`).
* **Email:** Wajib diisi, harus berupa format email yang valid, dan tidak boleh duplikat (`required|email|unique:users`).
* **Password:** Wajib diisi, **minimal 8 karakter** (`required|min:8`), dan disarankan menggunakan kombinasi angka/huruf.

## 5. Peningkatan Fitur Scan AI (Diagnosis Penyakit Tanaman)
Fitur *image recognition* (scan kamera) akan diperbarui:
* **Kondisi Saat Ini:** Fitur scan hanya mengenali kelas spesies tanaman.
* **Pembaruan Target:** Model klasifikasi/endpoint scan harus mendeteksi kelainan atau penyakit pada daun/batang, bukan sekadar mengenali jenis tanamannya.
* **Contoh Output API (JSON):**
    ```json
    {
        "status": "success",
        "data": {
            "plant_name": "Monstera Deliciosa",
            "health_status": "Sakit",
            "disease_name": "Bercak Daun Coklat (Leaf Spot)",
            "accuracy": "92%",
            "recommendation": "Gunting daun yang terinfeksi, kurangi penyiraman, dan semprotkan fungisida berbahan aktif tembaga."
        }
    }
    ```

## 6. Integrasi Menu pada UI Utama & Data Dummy Artikel
Semua menu yang ada di *home screen* (merujuk pada desain aplikasi: Riwayat, Artikel, Tips Harian, Tersimpan) akan terhubung secara dinamis dengan database melalui API.

* **Riwayat:** Endpoint API khusus untuk menarik history scan diagnosis yang pernah dilakukan user.
* **Tips Harian:** Mengambil *quotes* atau panduan merawat tanaman singkat setiap harinya berdasarkan tanggal (Daily tip of the day).
* **Tersimpan:** Menampilkan daftar artikel atau koleksi tanaman yang di-bookmark oleh user.

### Data Dummy Untuk Menu Artikel
Berikut adalah referensi data *dummy* (untuk database seeder) pada menu **Artikel**:

1.  **Judul Artikel:** Panduan Lengkap Merawat Monstera Deliciosa Agar Daun Cepat Pecah
    * **Kategori:** Perawatan
    * **Isi Singkat:** Monstera dikenal dengan daunnya yang terbelah indah. Untuk mempercepat proses pecah daun (fenestrasi), pastikan tanaman mendapatkan cahaya matahari tidak langsung yang cukup, serta jaga kelembapan tanah agar tidak terlalu basah...
    * **Gambar:** dummy_monstera_article.jpg
    
2.  **Judul Artikel:** 5 Penyakit Umum yang Sering Menyerang Tanaman Hias Indoor
    * **Kategori:** Kesehatan Tanaman
    * **Isi Singkat:** Daun menguning, bercak coklat, hingga serangan kutu putih adalah masalah umum bagi pecinta tanaman hias. Mari kita kenali tanda-tandanya dan bagaimana cara membasminya dengan bahan alami di rumah...
    * **Gambar:** dummy_plant_disease.jpg

3.  **Judul Artikel:** Manfaat Sansevieria: Si Lidah Mertua Pembersih Udara Ruangan
    * **Kategori:** Ensiklopedia Tanaman
    * **Isi Singkat:** Berdasarkan penelitian NASA, Sansevieria atau lidah mertua tidak hanya mudah dirawat dan tahan banting, tetapi juga terbukti sangat efektif dalam menyerap polutan berbahaya di udara seperti benzena dan formaldehida...
    * **Gambar:** dummy_sansevieria.jpg
