# Update Desain UI - Plant Doctor

Berdasarkan referensi visual terbaru dan spesifikasi fitur serta alur aplikasi yang ada pada file `Fitur.md` dan `Flow.md`, berikut adalah panduan pembaruan antarmuka (UI) untuk mengawinkan estetika visual pada gambar dengan kebutuhan fungsional aplikasi Plant Doctor.

## 1. Tema dan Gaya Visual
Mengadaptasi dari gambar referensi, aplikasi Plant Doctor akan menggunakan gaya desain yang lebih modern, bersih, dan bertema alam:
* **Palet Warna:** Didominasi oleh warna hijau bumi (*earthy greens*) seperti hijau lumut dan hijau zaitun, dipadukan dengan latar belakang putih atau krem lembut untuk memberikan kesan segar.
* **Tipografi:** Menggunakan *font sans-serif* tebal untuk *heading* (seperti pada teks "Magical Things" dan "Discover") dan *font* reguler yang bersih untuk paragraf/deskripsi langkah penanganan.
* **Bentuk (Shapes):** Menggunakan sudut membulat (*rounded corners*) yang cukup besar pada kartu (*cards*), tombol, dan batas bawah *header*. Penggunaan elemen grafis geometris dan bentuk daun organik (seperti pada *splash screen*) sangat dianjurkan.

## 2. Pembaruan Halaman (Berdasarkan Flow & Fitur)

### A. Splash Screen / Onboarding (Adaptasi Gambar Kiri)
* **Visual:** Menampilkan ilustrasi bergaya geometris dan organik (gabungan pot tanaman, daun, dan bumi) dengan dominasi hijau, senada dengan gambar referensi pertama.
* **Konten Teks:** Judul "Plant Doctor" (menggantikan tulisan "Magical Things") dengan *tagline* (misal: "Let's make the world green again" atau "Jaga Tanamanmu Tetap Sehat").
* **Tombol Aksi:** Tombol "Get Started" berbentuk kapsul berwarna hijau tua untuk membawa pengguna ke *Dashboard*.

### B. Dashboard / "Koleksi Tanamanku" (Adaptasi Gambar Tengah)
* **Header:** Menampilkan teks sapaan dan judul halaman (misal: "Tanamanku" atau "Dashboard").
* **Search Bar:** Dipertahankan untuk memudahkan pengguna mencari tanaman di riwayat diagnosis atau mencari artikel tertentu.
* **Menu Kategori (Ikon):** Kategori toko pada gambar (Green Plants, Flowers) diadaptasi menjadi pintasan fitur utama: **"Riwayat Diagnosis"**, **"Artikel"**, dan **"Tips Harian"**.
* **Banner Informasi:** Menggunakan tata letak kartu promosi 20% pada gambar untuk diubah menjadi *banner* "Tips Perawatan Tanaman Harian" (berisi ringkasan satu tips).
* **Grid Koleksi:** Menampilkan daftar tanaman yang pernah dipindai (sesuai *happy flow*). Di mana harga ($60) diganti dengan tanggal pindai atau status tanaman (sehat/sakit).
* **Navigasi Bawah & Floating Action Button (FAB):** Sesuai instruksi pada `Flow.md`, wajib terdapat **Tombol Kamera Utama**. Tombol ini bisa disematkan di bagian tengah *bottom bar* dengan desain menonjol (warna solid atau bentuk lebih besar) untuk masuk ke mode diagnosis instan.

### C. Halaman Kamera & Loading State (Transisi Fungsional)
* **Tampilan Layar:** Tampilan penuh akses kamera dengan antarmuka yang bersih (hanya *overlay* bingkai bidikan daun). Tersedia opsi unggah dari Galeri di pojok layar.
* **Loading State:** Sesuai `Fitur.md` (keandalan performa), setelah memotret, sistem mengirim *request* HTTP ke *API PlantId / PlantNet*. Pada tahap ini, transisi layar harus menampilkan *skeleton loading indicator* dengan warna hijau pudar yang berkedip, mempertahankan estetika visual.

### D. Halaman Hasil Diagnosis (Adaptasi Gambar Kanan)
* **Gambar Utama (Header):** Menampilkan gambar daun yang sakit/dipindai secara penuh di bagian atas (menggantikan gambar lidah buaya), dengan tombol *back* (kiri atas) dan tombol bagikan/favorit (kanan atas).
* **Kartu Informasi (Bottom Sheet):** Desain membulat di bagian atas, berisikan:
  * **Judul & Akurasi:** Nama Penyakit Tanaman (sebagai judul utama) dan persentase akurasi di posisi sekunder (misal di sisi kanan).
  * **Deskripsi:** Hasil *parsing* data respons JSON API yang berisi langkah-langkah detail cara penanganan.
  * **Ikon Panduan Penanganan:** Ikon cuaca (Drained, Full Sun, dll) pada referensi diadaptasi menjadi ikon tindakan penanganan, seperti: "Kebutuhan Air", "Kebutuhan Cahaya", "Tindakan Karantina", atau "Pemupukan".
  * **Tombol Aksi Utama:** Tombol "Checkout" diganti menjadi **"Simpan Diagnosis"** atau **"Tandai Telah Diobati"**.

## 3. Navigasi dan Routing
* Sesuai *flow*, seluruh interaksi akan dibalut dengan transisi *fade* atau *slide* agar pengalaman berpindah antar *screen* (terutama dari Dashboard ke Kamera dan Hasil Diagnosis) terasa mulus dan responsif.
