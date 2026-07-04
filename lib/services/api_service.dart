import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../config/app_constants.dart';
import '../utils/logger.dart';

/// Service for communicating with Plant Disease Detection API
class ApiService {
  static ApiService? _instance;
  final http.Client _client;
  final String _apiKey;
  final String _baseUrl;

  // Private constructor
  ApiService._({
    http.Client? client,
    String? apiKey,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _apiKey = apiKey ?? AppConstants.apiKey,
        _baseUrl = baseUrl ?? AppConstants.apiBaseUrl;

  // Singleton instance
  static ApiService get instance {
    _instance ??= ApiService._();
    return _instance!;
  }

  // For testing purposes
  static void setInstance(ApiService instance) {
    _instance = instance;
  }

  /// Diagnose plant disease from image file
  Future<PlantDiagnosis> diagnosePlant(String imagePath) async {
    try {
      Logger.info('Starting plant diagnosis for: $imagePath', tag: 'ApiService');

      // Read image file
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      // Generate unique diagnosis ID
      final diagnosisId = const Uuid().v4();

      // Call API (using MultipartFile via image path)
      final response = await _callHealthAssessmentApi(imagePath);

      // Parse response
      final diagnosis = PlantDiagnosis.fromApiResponse(
        response,
        imagePath,
        diagnosisId,
      );

      Logger.info(
        'Diagnosis completed: ${diagnosis.diseaseName} (${(diagnosis.accuracy * 100).toStringAsFixed(1)}%)',
        tag: 'ApiService',
      );

      return diagnosis;
    } catch (e) {
      Logger.error('Error diagnosing plant', tag: 'ApiService', error: e);
      rethrow;
    }
  }

  /// Call Plant.id Health Assessment API using HTTP POST Multipart
  Future<Map<String, dynamic>> _callHealthAssessmentApi(String imagePath) async {
    try {
      // Check if API key is configured
      if (_apiKey == 'YOUR_API_KEY_HERE' || _apiKey.isEmpty) {
        // Mock delay for loading indicator
        await Future.delayed(const Duration(seconds: 2));
        Logger.warning('API key not configured, using mock data', tag: 'ApiService');
        return _getMockResponse();
      }

      final url = Uri.parse('$_baseUrl/health_assessment');
      
      Logger.info('Calling API via POST (Multipart): $url', tag: 'ApiService');

      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Api-Key': _apiKey,
      });

      // Add image file as MultipartFile
      request.files.add(await http.MultipartFile.fromPath('images', imagePath));

      // Add other form data
      request.fields['latitude'] = '-6.2088';
      request.fields['longitude'] = '106.8456';
      request.fields['similar_images'] = 'true';

      final streamedResponse = await _client.send(request).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('API request timed out after 30 seconds');
        },
      );
      
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        Logger.info('API call successful', tag: 'ApiService');
        return jsonResponse;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your configuration.');
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        Logger.error(
          'API error: ${response.statusCode}',
          tag: 'ApiService',
          error: response.body,
        );
        throw Exception('API error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Connection timeout. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } catch (e) {
      Logger.error('API call failed', tag: 'ApiService', error: e);
      rethrow;
    }
  }

  /// Get mock response for testing/demo purposes
  Map<String, dynamic> _getMockResponse() {
    // Simulate API delay
    Logger.info('Returning mock diagnosis data', tag: 'ApiService');
    
    // Return mock data that simulates Plant.id API response
    return {
      'health_assessment': {
        'diseases': [
          {
            'name': 'Leaf Spot Disease',
            'probability': 0.85,
            'disease_details': {
              'common_names': ['Bercak Daun'],
              'description':
                  'Penyakit bercak daun adalah infeksi jamur yang menyebabkan bintik-bintik coklat atau hitam pada daun tanaman. Dapat menyebar dengan cepat jika tidak ditangani.',
              'symptoms': [
                'Bintik-bintik coklat atau hitam pada daun',
                'Daun menguning di sekitar bercak',
                'Daun gugur prematur',
                'Pertumbuhan tanaman terhambat',
              ],
              'treatment': {
                'biological': [
                  'Buang daun yang terinfeksi dan musnahkan',
                  'Tingkatkan sirkulasi udara di sekitar tanaman',
                  'Hindari penyiraman dari atas',
                ],
                'chemical': [
                  'Gunakan fungisida berbasis tembaga',
                  'Aplikasikan fungisida sesuai petunjuk',
                  'Ulangi treatment setiap 7-14 hari',
                ],
                'prevention': [
                  'Jaga jarak tanam yang cukup',
                  'Siram di pagi hari agar daun cepat kering',
                  'Gunakan mulsa untuk mencegah percikan tanah',
                  'Rotasi tanaman setiap musim',
                ],
              },
            },
          },
        ],
      },
    };
  }

  /// Alternative: Diagnose with multiple images for better accuracy
  Future<PlantDiagnosis> diagnosePlantMultipleImages(
    List<String> imagePaths,
  ) async {
    try {
      if (imagePaths.isEmpty) {
        throw Exception('No images provided');
      }

      Logger.info(
        'Starting diagnosis with ${imagePaths.length} images',
        tag: 'ApiService',
      );

      // For now, just use the first image
      // In production, you would combine multiple images
      return await diagnosePlant(imagePaths.first);
    } catch (e) {
      Logger.error('Error in multi-image diagnosis', tag: 'ApiService', error: e);
      rethrow;
    }
  }

  /// Check API health/status
  Future<bool> checkApiHealth() async {
    try {
      // Simple ping to check if API is reachable
      final url = Uri.parse(_baseUrl);
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
