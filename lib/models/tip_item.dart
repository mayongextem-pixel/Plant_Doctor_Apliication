import 'package:flutter/material.dart';

enum TipCategory { penyiraman, pemupukan, pencahayaan }

class TipItem {
  final String id;
  final String title;
  final String description;
  final TipCategory category;
  final IconData icon;

  const TipItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
  });

  String get categoryLabel {
    switch (category) {
      case TipCategory.penyiraman:
        return 'Penyiraman';
      case TipCategory.pemupukan:
        return 'Pemupukan';
      case TipCategory.pencahayaan:
        return 'Pencahayaan';
    }
  }

  static List<TipItem> get mockData => [
    const TipItem(
      id: '1',
      title: 'Siram di Pagi Hari',
      description:
          'Siram tanaman di pagi hari sebelum matahari terik untuk mengurangi penguapan dan menjaga kelembapan tanah lebih lama.',
      category: TipCategory.penyiraman,
      icon: Icons.water_drop_rounded,
    ),
    const TipItem(
      id: '2',
      title: 'Jangan Terlalu Banyak Air',
      description:
          'Pastikan pot memiliki lubang drainase. Penyiraman berlebihan dapat menyebabkan akar membusuk dan tanaman mati.',
      category: TipCategory.penyiraman,
      icon: Icons.water_drop_rounded,
    ),
    const TipItem(
      id: '3',
      title: 'Pupuk Organik Setiap Bulan',
      description:
          'Gunakan pupuk organik seperti kompos atau pupuk kandang setiap bulan untuk menjaga kesuburan tanah secara alami.',
      category: TipCategory.pemupukan,
      icon: Icons.grass_rounded,
    ),
    const TipItem(
      id: '4',
      title: 'Hindari Pupuk Kimia Berlebih',
      description:
          'Penggunaan pupuk kimia yang berlebihan dapat merusak struktur tanah. Ikuti dosis yang dianjurkan pada kemasan.',
      category: TipCategory.pemupukan,
      icon: Icons.grass_rounded,
    ),
    const TipItem(
      id: '5',
      title: 'Cahaya Tidak Langsung',
      description:
          'Sebagian besar tanaman hias tumbuh optimal dengan cahaya terang tidak langsung. Hindari paparan sinar matahari langsung di siang hari.',
      category: TipCategory.pencahayaan,
      icon: Icons.wb_sunny_rounded,
    ),
    const TipItem(
      id: '6',
      title: 'Rotasi Tanaman Mingguan',
      description:
          'Putar posisi pot tanaman setiap minggu agar semua sisi mendapat cahaya merata dan pertumbuhan tanaman lebih seimbang.',
      category: TipCategory.pencahayaan,
      icon: Icons.wb_sunny_rounded,
    ),
  ];
}
