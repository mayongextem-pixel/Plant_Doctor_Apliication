import 'package:flutter/material.dart';

class PlantCollection {
  final String id;
  final String plantName;
  final bool isHealthy;
  final DateTime lastScanDate;
  final IconData placeholderIcon;

  const PlantCollection({
    required this.id,
    required this.plantName,
    required this.isHealthy,
    required this.lastScanDate,
    this.placeholderIcon = Icons.local_florist_rounded,
  });

  static List<PlantCollection> get mockData => [
    PlantCollection(
      id: '1',
      plantName: 'Monstera Deliciosa',
      isHealthy: true,
      lastScanDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PlantCollection(
      id: '2',
      plantName: 'Sansevieria',
      isHealthy: false,
      lastScanDate: DateTime.now().subtract(const Duration(days: 5)),
      placeholderIcon: Icons.grass_rounded,
    ),
    PlantCollection(
      id: '3',
      plantName: 'Pothos Golden',
      isHealthy: true,
      lastScanDate: DateTime.now().subtract(const Duration(days: 3)),
      placeholderIcon: Icons.eco_rounded,
    ),
    PlantCollection(
      id: '4',
      plantName: 'Mawar Merah',
      isHealthy: false,
      lastScanDate: DateTime.now().subtract(const Duration(days: 10)),
      placeholderIcon: Icons.spa_rounded,
    ),
    PlantCollection(
      id: '5',
      plantName: 'Lidah Buaya',
      isHealthy: true,
      lastScanDate: DateTime.now().subtract(const Duration(days: 1)),
      placeholderIcon: Icons.yard_rounded,
    ),
    PlantCollection(
      id: '6',
      plantName: 'Lavender',
      isHealthy: true,
      lastScanDate: DateTime.now().subtract(const Duration(days: 7)),
      placeholderIcon: Icons.filter_vintage_rounded,
    ),
  ];
}
