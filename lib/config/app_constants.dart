class AppConstants {
  // App Info
  static const String appName = 'Plant Doctor';
  static const String appVersion = '1.0.0';

  // API Configuration — Pl@ntNet (gratis 500 req/hari)
  // Daftar di: https://my.plantnet.org → My Account → API Keys
  static const String apiBaseUrl = 'https://my-api.plantnet.org/v2';
  static const String apiKey = '2b10TPnWALxXCXCODC1knvmI';
  static const String plantNetProject = 'all';

  // Backend Laravel API Configuration
  // Gunakan 'http://10.0.2.2:8000' untuk Android Emulator
  static const String laravelApiBaseUrl = 'http://192.168.18.42:8000/api';

  // Storage Keys
  static const String keyPlantHistory = 'plant_history';
  static const String keyUserSettings = 'user_settings';
  static const String keyFirstLaunch = 'first_launch';

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration shimmerDuration = Duration(milliseconds: 1500);
  static const Duration fadeTransitionDuration = Duration(milliseconds: 300);

  // Image Configuration
  static const double maxImageSize = 1024;
  static const int imageQuality = 85;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardElevation = 2.0;

  // Error Messages
  static const String errorNoInternet = 'Tidak ada koneksi internet';
  static const String errorApiFailure = 'Gagal menghubungi server';
  static const String errorImageProcessing = 'Gagal memproses gambar';

  // Sample Articles
  static const List<Map<String, String>> sampleArticles = [
    {
      'title': 'Tips Merawat Tanaman Indoor',
      'description': 'Panduan lengkap merawat tanaman di dalam ruangan',
      'image': 'https://via.placeholder.com/300x200',
      'category': 'care',
    },
  ];
}
