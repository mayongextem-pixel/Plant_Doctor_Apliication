import 'package:flutter/material.dart';

enum SavedItemType { tanaman, artikel }

class SavedItem {
  final String id;
  final String name;
  final SavedItemType type;
  final IconData icon;

  const SavedItem({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });

  String get typeLabel {
    switch (type) {
      case SavedItemType.tanaman:
        return 'Tanaman';
      case SavedItemType.artikel:
        return 'Artikel';
    }
  }

  static List<SavedItem> get mockData => [
    const SavedItem(
      id: '1',
      name: 'Cara Merawat Monstera',
      type: SavedItemType.artikel,
      icon: Icons.article_rounded,
    ),
    const SavedItem(
      id: '2',
      name: 'Lavender',
      type: SavedItemType.tanaman,
      icon: Icons.filter_vintage_rounded,
    ),
    const SavedItem(
      id: '3',
      name: 'Panduan Pemupukan Organik',
      type: SavedItemType.artikel,
      icon: Icons.article_rounded,
    ),
    const SavedItem(
      id: '4',
      name: 'Mawar Merah',
      type: SavedItemType.tanaman,
      icon: Icons.spa_rounded,
    ),
  ];
}
