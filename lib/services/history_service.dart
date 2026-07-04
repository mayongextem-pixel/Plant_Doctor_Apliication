import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScanHistory {
  final String id;
  final String imagePath;
  final String diseaseName;
  final double accuracy;
  final DateTime date;
  final String? description;
  final List<String>? treatments;

  ScanHistory({
    required this.id,
    required this.imagePath,
    required this.diseaseName,
    required this.accuracy,
    required this.date,
    this.description,
    this.treatments,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'imagePath': imagePath,
        'diseaseName': diseaseName,
        'accuracy': accuracy,
        'date': date.toIso8601String(),
        'description': description,
        'treatments': treatments,
      };

  factory ScanHistory.fromJson(Map<String, dynamic> json) => ScanHistory(
        id: json['id'],
        imagePath: json['imagePath'],
        diseaseName: json['diseaseName'],
        accuracy: json['accuracy'],
        date: DateTime.parse(json['date']),
        description: json['description'],
        treatments: (json['treatments'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      );
}

class HistoryService {
  static const String _key = 'scan_history';

  static Future<void> saveScanResult(ScanHistory history) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList(_key) ?? [];
    
    savedList.insert(0, jsonEncode(history.toJson()));
    
    await prefs.setStringList(_key, savedList);
  }

  static Future<List<ScanHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList(_key) ?? [];
    
    return savedList
        .map((item) => ScanHistory.fromJson(jsonDecode(item)))
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
