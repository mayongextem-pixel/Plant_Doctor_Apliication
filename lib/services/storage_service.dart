import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../config/app_constants.dart';
import '../utils/logger.dart';

/// Service for managing local storage using SharedPreferences
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// Reset singleton instance saat logout agar user berikutnya tidak mendapat
  /// instance yang masih di-cache dengan user_id lama.
  static void resetInstance() {
    _instance = null;
    _prefs = null;
  }

  /// Menghasilkan key unik per user agar data tidak bocor antar-akun
  String _userKey(String baseKey) {
    final userId = _prefs!.getString('user_id') ?? 'guest';
    return '${baseKey}_$userId';
  }

  Future<bool> savePlantCollection(List<Plant> plants) async {
    try {
      final jsonList = plants.map((plant) => plant.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await _prefs!.setString(_userKey(AppConstants.keyPlantHistory), jsonString);
    } catch (e) {
      Logger.error('Error saving plant collection', tag: 'StorageService', error: e);
      return false;
    }
  }

  Future<List<Plant>> loadPlantCollection() async {
    try {
      final jsonString = _prefs!.getString(_userKey(AppConstants.keyPlantHistory));
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => Plant.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Logger.error('Error loading plant collection', tag: 'StorageService', error: e);
      return [];
    }
  }

  Future<bool> addPlant(Plant plant) async {
    try {
      final plants = await loadPlantCollection();

      final existingIndex = plants.indexWhere((p) => p.id == plant.id);
      if (existingIndex != -1) {
        plants[existingIndex] = plant;
      } else {
        plants.add(plant);
      }

      return await savePlantCollection(plants);
    } catch (e) {
      Logger.error('Error adding plant', tag: 'StorageService', error: e);
      return false;
    }
  }

  Future<bool> updatePlant(Plant plant) async {
    try {
      final plants = await loadPlantCollection();
      final index = plants.indexWhere((p) => p.id == plant.id);

      if (index == -1) {
        Logger.warning('Plant not found: ${plant.id}', tag: 'StorageService');
        return false;
      }

      plants[index] = plant;
      return await savePlantCollection(plants);
    } catch (e) {
      Logger.error('Error updating plant', tag: 'StorageService', error: e);
      return false;
    }
  }

  Future<bool> deletePlant(String plantId) async {
    try {
      final plants = await loadPlantCollection();
      plants.removeWhere((p) => p.id == plantId);
      return await savePlantCollection(plants);
    } catch (e) {
      Logger.error('Error deleting plant', tag: 'StorageService', error: e);
      return false;
    }
  }

  Future<Plant?> getPlant(String plantId) async {
    try {
      final plants = await loadPlantCollection();
      return plants.firstWhere(
        (p) => p.id == plantId,
        orElse: () => throw Exception('Plant not found'),
      );
    } catch (e) {
      Logger.error('Error getting plant', tag: 'StorageService', error: e);
      return null;
    }
  }

  Future<bool> clearPlantCollection() async {
    try {
      return await _prefs!.remove(_userKey(AppConstants.keyPlantHistory));
    } catch (e) {
      Logger.error('Error clearing plant collection', tag: 'StorageService', error: e);
      return false;
    }
  }

  Future<bool> saveDiagnosis(PlantDiagnosis diagnosis) async {
    try {
      final plants = await loadPlantCollection();

      final existingPlantIndex = plants.indexWhere((p) => p.id == diagnosis.id);

      if (existingPlantIndex != -1) {
        final existingPlant = plants[existingPlantIndex];
        plants[existingPlantIndex] = existingPlant.addDiagnosis(diagnosis);
      } else {
        final newPlant = Plant.fromDiagnosis(diagnosis);
        plants.add(newPlant);
      }

      return await savePlantCollection(plants);
    } catch (e) {
      Logger.error('Error saving diagnosis', tag: 'StorageService', error: e);
      return false;
    }
  }

  Future<List<PlantDiagnosis>> getAllDiagnoses() async {
    try {
      final plants = await loadPlantCollection();
      final allDiagnoses = <PlantDiagnosis>[];

      for (var plant in plants) {
        allDiagnoses.addAll(plant.diagnosisHistory);
      }

      allDiagnoses.sort((a, b) => b.diagnosisDate.compareTo(a.diagnosisDate));
      return allDiagnoses;
    } catch (e) {
      Logger.error('Error getting all diagnoses', tag: 'StorageService', error: e);
      return [];
    }
  }

  Future<bool> saveSettings(Map<String, dynamic> settings) async {
    try {
      final jsonString = jsonEncode(settings);
      return await _prefs!.setString(_userKey(AppConstants.keyUserSettings), jsonString);
    } catch (e) {
      Logger.error('Error saving settings', tag: 'StorageService', error: e);
      return false;
    }
  }

  Future<Map<String, dynamic>> loadSettings() async {
    try {
      final jsonString = _prefs!.getString(_userKey(AppConstants.keyUserSettings));
      if (jsonString == null || jsonString.isEmpty) {
        return {};
      }
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      Logger.error('Error loading settings', tag: 'StorageService', error: e);
      return {};
    }
  }

  Future<bool> isFirstLaunch() async {
    final isFirst = _prefs!.getBool(AppConstants.keyFirstLaunch) ?? true;
    if (isFirst) {
      await _prefs!.setBool(AppConstants.keyFirstLaunch, false);
    }
    return isFirst;
  }

  Future<int> getPlantCount() async {
    final plants = await loadPlantCollection();
    return plants.length;
  }

  Future<int> getDiagnosisCount() async {
    final diagnoses = await getAllDiagnoses();
    return diagnoses.length;
  }

  Future<List<Plant>> getPlantsByStatus(String status) async {
    final plants = await loadPlantCollection();
    return plants.where((p) => p.currentHealthStatus == status).toList();
  }

  Future<int> getHealthyPlantsCount() async {
    final healthyPlants = await getPlantsByStatus('healthy');
    return healthyPlants.length;
  }

  Future<int> getSickPlantsCount() async {
    final plants = await loadPlantCollection();
    return plants.where((p) => p.currentHealthStatus != 'healthy').length;
  }

  /// Hapus hanya data milik user yang sedang login (user_id scoped).
  /// Dipanggil saat logout agar data user lain tidak ikut terhapus.
  Future<bool> clearCurrentUserData() async {
    try {
      await _prefs!.remove(_userKey(AppConstants.keyPlantHistory));
      await _prefs!.remove(_userKey(AppConstants.keyUserSettings));
      return true;
    } catch (e) {
      Logger.error('Error clearing user data', tag: 'StorageService', error: e);
      return false;
    }
  }

  Future<String?> exportData() async {
    try {
      final plants = await loadPlantCollection();
      final jsonList = plants.map((plant) => plant.toJson()).toList();
      return jsonEncode(jsonList);
    } catch (e) {
      Logger.error('Error exporting data', tag: 'StorageService', error: e);
      return null;
    }
  }

  Future<bool> importData(String jsonString) async {
    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final plants = jsonList
          .map((json) => Plant.fromJson(json as Map<String, dynamic>))
          .toList();
      return await savePlantCollection(plants);
    } catch (e) {
      Logger.error('Error importing data', tag: 'StorageService', error: e);
      return false;
    }
  }
}