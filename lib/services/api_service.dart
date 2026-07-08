import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../config/app_constants.dart';
import '../utils/logger.dart';

/// Service for communicating with the Plant Doctor Laravel backend.
class ApiService {
  static ApiService? _instance;
  final http.Client _client;

  // Private constructor
  ApiService._({http.Client? client})
      : _client = client ?? http.Client();

  // Singleton instance
  static ApiService get instance {
    _instance ??= ApiService._();
    return _instance!;
  }

  // For testing purposes
  static void setInstance(ApiService instance) {
    _instance = instance;
  }

  /// Identify plant species & disease using Laravel Backend API
  Future<PlantDiagnosis> diagnosePlant(String imagePath) async {
    try {
      Logger.info('Starting plant diagnosis via Laravel for: $imagePath', tag: 'ApiService');

      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      final url = Uri.parse('${AppConstants.laravelApiBaseUrl}/scan');
      var request = http.MultipartRequest('POST', url);

      // Ambil token jika ada
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('api_token');
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      // Tambah file gambar
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      Logger.info('Sending POST to $url', tag: 'ApiService');
      final streamedResponse = await _client.send(request).timeout(
        const Duration(seconds: 45),
        onTimeout: () {
          throw TimeoutException('API request timed out (Laravel backend)');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);
      Logger.info('Laravel response status: ${response.statusCode}', tag: 'ApiService');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        
        // Asumsi respons dari Laravel: { "status": "success", "data": { ... } }
        final data = jsonResponse['data'] ?? jsonResponse;

        final diagnosisId = const Uuid().v4();
        final diagnosis = PlantDiagnosis.fromLaravelApi(data, imagePath, diagnosisId);

        Logger.info('Diagnosis success: ${diagnosis.diseaseName}', tag: 'ApiService');
        return diagnosis;
      } else {
        Logger.error('API Error: ${response.body}', tag: 'ApiService');
        String errorMessage = 'Gagal melakukan diagnosis (Status ${response.statusCode})';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody['message'] != null) {
            errorMessage = errorBody['message'];
          }
        } catch (e) {
          // Ignored if response is not json
        }
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception(AppConstants.errorNoInternet);
    } on TimeoutException {
      throw Exception('Koneksi timeout saat menghubungi server');
    } catch (e) {
      Logger.error('Error diagnosing plant', tag: 'ApiService', error: e);
      rethrow;
    }
  }


  /// Check API health/status (ping Laravel backend)
  Future<bool> checkApiHealth() async {
    try {
      final url = Uri.parse(AppConstants.laravelApiBaseUrl);
      final response = await _client.head(url).timeout(
            const Duration(seconds: 5),
          );
      return response.statusCode < 500;
    } catch (e) {
      Logger.error('API health check failed', tag: 'ApiService', error: e);
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}

/// Exception class for API-specific errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: $message (Status: $statusCode)';
    }
    return 'ApiException: $message';
  }
}
