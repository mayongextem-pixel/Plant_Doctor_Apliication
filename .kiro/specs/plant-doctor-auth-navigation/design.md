# Design Document: Auth Flow & Navigation Routing — Plant Doctor

## Overview

Dokumen ini mendeskripsikan desain teknis untuk fitur Auth Flow dan Navigation Routing pada aplikasi Flutter "Plant Doctor". Fitur ini menambahkan modul autentikasi (WelcomeScreen, LoginScreen, RegisterScreen) dan merefaktor halaman utama menjadi `MainScreen` dengan `BottomNavigationBar` + `IndexedStack`.

Desain ini dibangun di atas fondasi yang sudah ada:
- **AppTheme** (`lib/config/app_theme.dart`) — design system hijau-putih dengan warna, tipografi, dan spacing yang sudah terdefinisi.
- **PageTransitions** (`lib/utils/page_transitions.dart`) — utilitas transisi `fade`, `slide`, `slideAndFade`, dan `scale`.
- **DashboardScreen** (`lib/screens/dashboard_screen.dart`) — UI beranda yang sudah berjalan, diintegrasikan sebagai `HomeFragment`.
- **CameraScreen** (`lib/screens/camera_screen.dart`) — screen kamera yang dipertahankan.
- **Model `Article`** (`lib/models/article.dart`) — model artikel yang sudah lengkap.
- **Provider** (`provider: ^6.1.1`) — state management yang sudah ada di `pubspec.yaml`.

Strategi utama adalah **mengekstrak body DashboardScreen menjadi HomeFragment** sehingga navigasi bawah, FAB kamera, dan konten beranda dikelola secara terpusat di `MainScreen`.

---

## Architecture

### Navigation Flow

```
SplashScreen
    |
    | (auto-navigate setelah animasi selesai)
    ↓
WelcomeScreen
    |               |
    | "Masuk"       | "Daftar"
    ↓               ↓
LoginScreen    RegisterScreen
    |               |
    | (mock success, pushAndRemoveUntil)
    ↓
MainScreen  ←────────────────────────────────┐
    |                                         |
    ├── Tab 0: HomeFragment                   |
    │       ├── → RiwayatScreen (push)        |
    │       ├── → ArtikelScreen (push)        |
    │       ├── → TipsHarianScreen (push)     |
    │       └── → TersimpanScreen (push)      |
    ├── Tab 1: KoleksiFragment                |
    ├── Tab 2: ArtikelFragment                |
    ├── Tab 3: ProfilFragment                 |
    │               └── "Keluar" → WelcomeScreen (pushAndRemoveUntil)
    └── FAB → CameraScreen (push)
```

### State Management Architecture

State management menggunakan dua pendekatan:
1. **`setState` lokal** di `MainScreen` untuk `currentIndex` BottomNavBar.
2. **`Provider`** untuk state yang mungkin di-share lintas tab (misal: status loading di KoleksiFragment).

```
lib/
├── main.dart                    ← Entry point, MaterialApp + ProviderScope
├── config/
│   ├── app_theme.dart           ← Design tokens (existing)
│   └── app_constants.dart       ← Constants (existing)
├── models/
│   ├── article.dart             ← Model artikel (existing)
│   ├── plant.dart               ← Model tanaman (existing)
│   ├── plant_diagnosis.dart     ← Model diagnosis (existing)
│   ├── models.dart              ← Barrel export (existing)
│   ├── detection_history.dart   ← NEW: model riwayat deteksi
│   ├── plant_collection.dart    ← NEW: model koleksi tanaman
│   ├── saved_item.dart          ← NEW: model item tersimpan
│   └── tip_item.dart            ← NEW: model tips harian
├── screens/
│   ├── auth/
│   │   ├── welcome_screen.dart  ← NEW
│   │   ├── login_screen.dart    ← NEW
│   │   └── register_screen.dart ← NEW
│   ├── main_nav/
│   │   ├── main_screen.dart     ← NEW: host BottomNavBar + IndexedStack + FAB
│   │   ├── home_fragment.dart   ← NEW: ekstrak body dari DashboardScreen
│   │   ├── koleksi_fragment.dart← NEW
│   │   ├── artikel_fragment.dart← NEW
│   │   └── profil_fragment.dart ← NEW
│   ├── menus/
│   │   ├── riwayat_screen.dart  ← NEW
│   │   ├── artikel_screen.dart  ← NEW
│   │   ├── tips_harian_screen.dart ← NEW
│   │   └── tersimpan_screen.dart   ← NEW
│   ├── splash_screen.dart       ← MODIFIED: navigasi ke WelcomeScreen
│   ├── dashboard_screen.dart    ← DEPRECATED: logika dipindah ke HomeFragment
│   ├── camera_screen.dart       ← UNTOUCHED
│   └── diagnosis_result_screen.dart ← UNTOUCHED
├── widgets/
│   ├── app_button.dart          ← NEW: reusable button (primary + outlined)
│   ├── app_text_field.dart      ← NEW: reusable text field
│   └── skeleton_loader.dart     ← NEW: skeleton loading widget
├── services/                    ← Existing, untouched
└── utils/
    ├── page_transitions.dart    ← Existing, untouched
    └── logger.dart              ← Existing, untouched
```

---

## Components and Interfaces

### 1. Reusable Widgets

#### `AppButton` (`lib/widgets/app_button.dart`)

```dart
enum AppButtonVariant { primary, outlined }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final double? width;
  final IconData? leadingIcon;
}
```

- `primary`: `ElevatedButton` dengan `backgroundColor: AppTheme.primaryGreen`
- `outlined`: `OutlinedButton` dengan `side: BorderSide(color: AppTheme.primaryGreen)`
- `isLoading`: mengganti label dengan `CircularProgressIndicator`
- Lebar default `double.infinity` (full width)

#### `AppTextField` (`lib/widgets/app_text_field.dart`)

```dart
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool isPasswordField;   // toggle visibility icon
  final TextInputType keyboardType;
  final IconData? prefixIcon;
}
```

- Menggunakan `AppTheme.inputDecorationTheme` secara implisit dari tema Material.
- `isPasswordField: true` menambahkan suffix icon untuk toggle visibilitas.

#### `SkeletonLoader` (`lib/widgets/skeleton_loader.dart`)

```dart
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
}

class SkeletonGridLoader extends StatelessWidget {
  final int itemCount;  // default: 6
  final int crossAxisCount; // default: 2
}
```

Menggunakan `AnimationController` untuk shimmer effect — menambahkan overlay gradient bergerak di atas container abu-abu.

---

### 2. Auth Screens

#### `WelcomeScreen`

```
Scaffold (backgroundColor: AppTheme.backgroundColor)
  └─ SafeArea
       └─ Column
            ├─ Spacer
            ├─ Icon(Icons.local_florist_rounded, 80px, primaryGreen)
            ├─ Text "Plant Doctor" (displayLarge, primaryGreen)
            ├─ Text "Rawat Tanamanmu dengan AI" (bodyLarge, textMedium)
            ├─ Dekoratif: _OrganicShape (mirip SplashScreen)
            ├─ Spacer
            ├─ AppButton(label: "Masuk", variant: primary) → LoginScreen
            ├─ SizedBox(height: 12)
            └─ AppButton(label: "Daftar", variant: outlined) → RegisterScreen
```

Tidak memiliki AppBar. Navigasi ke LoginScreen/RegisterScreen menggunakan `PageTransitions.slideAndFadeTransition`.

#### `LoginScreen`

```
Scaffold
  ├─ AppBar (title: "Masuk", back button → WelcomeScreen)
  └─ SafeArea
       └─ SingleChildScrollView
            └─ Padding(horizontal: 24)
                 └─ Form(key: _formKey)
                      ├─ SizedBox(height: 32)
                      ├─ Text "Selamat datang kembali" (titleLarge)
                      ├─ SizedBox(height: 8)
                      ├─ Text "Masuk untuk melanjutkan" (bodyMedium, textMedium)
                      ├─ SizedBox(height: 32)
                      ├─ AppTextField(label: "Email", keyboardType: emailAddress,
                      │    validator: Validators.email)
                      ├─ SizedBox(height: 16)
                      ├─ AppTextField(label: "Password", isPasswordField: true,
                      │    validator: Validators.password)
                      ├─ SizedBox(height: 32)
                      ├─ AppButton(label: "Masuk", isLoading: _isLoading)
                      ├─ SizedBox(height: 16)
                      └─ Row "Belum punya akun? [Daftar]" → RegisterScreen
```

#### `RegisterScreen`

Struktur mirip `LoginScreen`, dengan empat `AppTextField`:
1. Nama Lengkap (`validator: Validators.name`)
2. Email (`validator: Validators.email`)
3. Password (`validator: Validators.password`)
4. Konfirmasi Password (`validator: Validators.confirmPassword(passwordController)`)

---

### 3. MainScreen & Fragments

#### `MainScreen` (`lib/screens/main_nav/main_screen.dart`)

```dart
class MainScreen extends StatefulWidget { ... }

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _fragments = [
    const HomeFragment(),
    const KoleksiFragment(),
    const ArtikelFragment(),
    const ProfilFragment(),
  ];

  // build()
  // - Scaffold dengan BottomAppBar (notch) + FAB centerDocked
  // - body: IndexedStack(index: _currentIndex, children: _fragments)
}
```

Widget tree `MainScreen`:

```
Scaffold
  ├─ body: IndexedStack
  │    ├─ [0] HomeFragment
  │    ├─ [1] KoleksiFragment
  │    ├─ [2] ArtikelFragment
  │    └─ [3] ProfilFragment
  ├─ floatingActionButton: FAB (kamera, primaryGreen, size 72)
  ├─ floatingActionButtonLocation: centerDocked
  └─ bottomNavigationBar: BottomAppBar (shape: CircularNotchedRectangle)
       └─ BottomNavigationBar
            ├─ Beranda (index 0)
            ├─ Koleksi (index 1)
            ├─ Artikel (index 2)
            └─ Profil (index 3)
```

#### `HomeFragment` (`lib/screens/main_nav/home_fragment.dart`)

Mengekstrak seluruh body dari `DashboardScreen` yang sudah ada — `CustomScrollView` berisi AppBar greeting, `_buildQuickActionMenu`, `_buildPromotionalBanner`, dan `_buildPlantCollectionGrid`. 

**Integrasi DashboardScreen:**
- `HomeFragment` meng-copy logika body `DashboardScreen` secara langsung.
- Quick action menu items kini menggunakan `Navigator.of(context).push(PageTransitions.slideAndFadeTransition(const RiwayatScreen()))` dll.
- Tidak ada duplikasi `BottomNavigationBar` atau `FloatingActionButton` — keduanya ada di `MainScreen`.

#### `KoleksiFragment`

```
SafeArea
  └─ Column
       ├─ Padding: Text "Koleksi Tanamanku" (titleLarge)
       └─ Expanded
            └─ FutureBuilder (simulasi delay 1.5 detik)
                 ├─ loading: SkeletonGridLoader(itemCount: 6)
                 └─ data: GridView.builder
                          ├─ crossAxisCount: 2
                          └─ _PlantCollectionCard (nama, status badge, tanggal)
```

#### `ArtikelFragment`

```
SafeArea
  └─ Column
       ├─ Padding: Text "Artikel Tanaman" (titleLarge)
       └─ Expanded
            └─ ListView.builder
                 └─ _ArtikelCard (judul, deskripsi, kategori, tanggal)
```

Menggunakan `MockData.articles` yang sama dengan `ArtikelScreen`.

#### `ProfilFragment`

```
SafeArea
  └─ Column
       ├─ Padding: CircleAvatar (radius 48, primaryGreen background, ikon person)
       ├─ Text "Pengguna Demo" (titleMedium)
       ├─ Text "demo@plantdoctor.id" (bodyMedium, textLight)
       ├─ Divider
       ├─ ListTile "Notifikasi" (leading: Icon notifications)
       ├─ ListTile "Bahasa" (leading: Icon language)
       ├─ ListTile "Tentang Aplikasi" (leading: Icon info)
       ├─ ListTile "Kebijakan Privasi" (leading: Icon privacy_tip)
       ├─ Spacer
       └─ AppButton(label: "Keluar", variant: outlined) → dialog → WelcomeScreen
```

---

### 4. Top Menu Screens

Semua screen menu mengikuti pola yang sama:

```
Scaffold
  ├─ AppBar(title: "Judul Screen", leading: back button)
  └─ SafeArea
       └─ ListView / GridView berisi mock data
```

---

## Data Models

### `DetectionHistory` (`lib/models/detection_history.dart`)

```dart
class DetectionHistory {
  final String id;
  final String plantName;
  final DateTime detectionDate;
  final bool isHealthy;       // true = Sehat, false = Terinfeksi
  final String diseaseName;   // kosong jika sehat
  final IconData placeholderIcon; // ikon tanaman sebagai thumbnail

  const DetectionHistory({...});
}
```

**Mock Data (min. 5 item):**
| id | plantName | detectionDate | isHealthy | diseaseName |
|----|-----------|---------------|-----------|-------------|
| 1 | Monstera Deliciosa | -2 hari | true | - |
| 2 | Sansevieria | -5 hari | false | Bercak Daun |
| 3 | Pothos | -7 hari | true | - |
| 4 | Mawar Merah | -10 hari | false | Karat Daun |
| 5 | Lidah Buaya | -14 hari | true | - |

---

### `PlantCollection` (`lib/models/plant_collection.dart`)

```dart
class PlantCollection {
  final String id;
  final String plantName;
  final bool isHealthy;
  final DateTime lastScanDate;
  final IconData placeholderIcon;

  const PlantCollection({...});
}
```

**Mock Data (min. 6 item)** — mencakup campuran Sehat dan Sakit.

---

### `TipItem` (`lib/models/tip_item.dart`)

```dart
enum TipCategory { penyiraman, pemupukan, pencahayaan }

class TipItem {
  final String id;
  final String title;
  final String description;
  final TipCategory category;
  final IconData icon;          // icon relevan per kategori

  const TipItem({...});
}
```

Mapping ikon:
- `penyiraman` → `Icons.water_drop_rounded`
- `pemupukan` → `Icons.grass_rounded`
- `pencahayaan` → `Icons.wb_sunny_rounded`

**Mock Data (min. 5 item, tersebar di 3 kategori).**

---

### `SavedItem` (`lib/models/saved_item.dart`)

```dart
enum SavedItemType { tanaman, artikel }

class SavedItem {
  final String id;
  final String name;
  final SavedItemType type;
  final IconData icon;

  const SavedItem({...});
}
```

**Mock Data (min. 4 item).**

---

### `Article` (existing — `lib/models/article.dart`)

Model ini sudah lengkap dan digunakan langsung oleh `ArtikelFragment` dan `ArtikelScreen`. Mock data dibuat secara statis menggunakan `Article.fromMap`.

---

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system — essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

---

### Property 1: Email Validator Consistency

*For any* string input, the email validator SHALL accept the string if and only if it is non-empty, contains exactly one `@` character, and has at least one character before and after `@` with a dot in the domain part.

**Validates: Requirements 2.3, 3.4**

---

### Property 2: Password Validator Length Invariant

*For any* string input, the password validator SHALL accept the string if and only if its length is greater than or equal to 6. Conversely, for any string with length less than 6 (including empty string), the validator SHALL always return an error message.

**Validates: Requirements 2.4, 3.5**

---

### Property 3: Confirm Password Equality Check

*For any* two strings `password` and `confirmPassword`, the confirm password validator SHALL accept if and only if `confirmPassword == password`. This must hold for all string pairs including empty strings, Unicode characters, and special characters.

**Validates: Requirements 3.6**

---

### Property 4: Name Validator Minimum Length

*For any* string input, the name validator SHALL accept the string if and only if its trimmed length is greater than or equal to 2. For any string whose trimmed form has length less than 2, the validator SHALL always return an error message.

**Validates: Requirements 3.3**

---

### Property 5: Tab Index to Fragment Mapping Consistency

*For any* valid tab index value `i` in `{0, 1, 2, 3}`, when `currentIndex` is set to `i` in `MainScreen`, the `IndexedStack` SHALL display the fragment at position `i` and exactly one fragment SHALL be visible at a time.

**Validates: Requirements 4.2, 4.3**

---

### Property 6: Health Status Badge Correctness

*For any* `PlantCollection` or `DetectionHistory` item in the displayed list, the rendered status badge SHALL display "Sehat" with `AppTheme.successGreen` if and only if `isHealthy == true`, and SHALL display "Sakit" / "Terinfeksi" with `AppTheme.errorRed` if and only if `isHealthy == false`.

**Validates: Requirements 6.4, 9.4**

---

## Error Handling

### Form Validation Errors

- Semua error validasi ditampilkan **inline** di bawah field yang bermasalah menggunakan `errorText` dari `InputDecoration`.
- `Form` menggunakan `autovalidateMode: AutovalidateMode.onUserInteraction` agar error muncul setelah pengguna pertama kali mengisi field.
- Tombol submit tidak di-disable saat invalid, melainkan memanggil `_formKey.currentState!.validate()` yang memperlihatkan semua error sekaligus.

### Navigation Guards

- `pushReplacement` / `pushAndRemoveUntil` digunakan saat berpindah dari auth ke `MainScreen` dan dari `MainScreen` ke `WelcomeScreen` (logout), sehingga pengguna tidak bisa kembali ke state auth setelah berhasil masuk.
- `if (mounted)` selalu dicek sebelum memanggil `Navigator` di dalam `async` callback untuk menghindari error `setState after dispose`.

### Async State (KoleksiFragment)

- `FutureBuilder` dengan `Future.delayed(Duration(seconds: 1, milliseconds: 500))` mensimulasikan loading.
- `SkeletonLoader` ditampilkan selama `ConnectionState.waiting`.
- Tidak ada error state karena data adalah mock statis — jika di masa depan diganti API, pola `AsyncSnapshot.hasError` sudah tersedia.

### Dialog Konfirmasi Logout

- Menggunakan `showDialog` dengan `barrierDismissible: false` agar pengguna harus memilih secara eksplisit.
- Pilihan "Batalkan" memanggil `Navigator.of(context).pop()`.
- Pilihan "Keluar" memanggil `Navigator.of(context).pushAndRemoveUntil(...)`.

---

## Testing Strategy

### Dual Testing Approach

Fitur ini menggunakan dua lapisan pengujian yang saling melengkapi:

1. **Unit Tests** — memverifikasi logika validasi (fungsi murni) dengan contoh spesifik dan kasus tepi.
2. **Property-Based Tests** — memverifikasi properti universal validator menggunakan library [fast_check](https://pub.dev/packages/fast_check) (atau alternatif: implementasi manual dengan `dart:math` jika library belum tersedia). Setiap property test dijalankan minimum **100 iterasi**.

### Unit Tests (Example-Based)

| File | Test Case |
|------|-----------|
| `test/widgets/auth/welcome_screen_test.dart` | WelcomeScreen menampilkan teks "Plant Doctor" dan tombol "Masuk", "Daftar" |
| `test/widgets/auth/login_screen_test.dart` | LoginScreen menampilkan 2 TextFormField; navigasi ke MainScreen saat valid |
| `test/widgets/auth/register_screen_test.dart` | RegisterScreen menampilkan 4 TextFormField |
| `test/widgets/main_nav/main_screen_test.dart` | FAB hadir; tapping tab mengubah konten IndexedStack |
| `test/widgets/main_nav/profil_fragment_test.dart` | Dialog konfirmasi muncul saat tombol Keluar ditekan |
| `test/widgets/main_nav/koleksi_fragment_test.dart` | SkeletonLoader muncul lalu hilang setelah 1,5 detik (fake async) |

### Property-Based Tests

Library: `test` bawaan Flutter dengan generator manual (Dart `Random`), atau `fast_check` jika ditambahkan ke `dev_dependencies`.

Setiap property test harus menyertakan komentar tag:

```dart
// Feature: plant-doctor-auth-navigation, Property 1: Email Validator Consistency
test('email validator accepts valid emails and rejects invalid ones', () {
  // 100+ iterations dengan random input
});
```

| Property | Test File | Iterasi |
|----------|-----------|---------|
| Property 1: Email Validator Consistency | `test/unit/validators_test.dart` | 200 |
| Property 2: Password Validator Length Invariant | `test/unit/validators_test.dart` | 200 |
| Property 3: Confirm Password Equality Check | `test/unit/validators_test.dart` | 200 |
| Property 4: Name Validator Minimum Length | `test/unit/validators_test.dart` | 200 |
| Property 5: Tab Index to Fragment Mapping | `test/widgets/main_nav/main_screen_test.dart` | 100 |
| Property 6: Health Status Badge Correctness | `test/widgets/main_nav/koleksi_fragment_test.dart` | 100 |

### Validators Module

Semua fungsi validator diekstrak ke `lib/utils/validators.dart` sebagai fungsi murni (tidak bergantung pada `BuildContext`) agar mudah diuji secara unit:

```dart
class Validators {
  static String? email(String? value);
  static String? password(String? value);
  static String? name(String? value);
  static String? Function(String?) confirmPassword(TextEditingController passwordController);
}
```

Pola ini memisahkan logika validasi dari widget dan memungkinkan property-based testing yang efisien.
