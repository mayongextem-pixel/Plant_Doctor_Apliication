import 'package:flutter/material.dart';

class DetectionHistory {
  final String id;
  final String plantName;
  final DateTime detectionDate;
  final bool isHealthy;
  final String diseaseName;
  final IconData placeholderIcon;

  const DetectionHistory({
    required this.id,
    required this.plantName,
    required this.detectionDate,
    required this.isHealthy,
    this.diseaseName = '',
    this.placeholderIcon = Icons.local_florist_rounded,
  });

  static List<DetectionHistory> get mockData => [
    DetectionHistory(
      id: '1',
      plantName: 'Monstera Deliciosa',
      detectionDate: DateTime.now().subtract(const Duration(days: 2)),
      isHealthy: true,
    ),
    DetectionHistory(
      id: '2',
      plantName: 'Sansevieria',
      detectionDate: DateTime.now().subtract(const Duration(days: 5)),
      isHealthy: false,
      diseaseName: 'Bercak Daun',
      placeholderIcon: Icons.grass_rounded,
    ),
    DetectionHistory(
      id: '3',
      plantName: 'Pothos',
      detectionDate: DateTime.now().subtract(const Duration(days: 7)),
      isHealthy: true,
      placeholderIcon: Icons.eco_rounded,
    ),
    DetectionHistory(
      id: '4',
      plantName: 'Mawar Merah',
      detectionDate: DateTime.now().subtract(const Duration(days: 10)),
      isHealthy: false,
      diseaseName: 'Karat Daun',
      placeholderIcon: Icons.spa_rounded,
    ),
    DetectionHistory(
      id: '5',
      plantName: 'Lidah Buaya',
      detectionDate: DateTime.now().subtract(const Duration(days: 14)),
      isHealthy: true,
      placeholderIcon: Icons.yard_rounded,
    ),
  ];
}
