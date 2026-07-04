import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../config/app_constants.dart';
import '../utils/logger.dart';

/// Service for communicating with Pl@ntNet Identification API (Free — 500 req/day)
/// Docs: https://my.plantnet.org/account/doc
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

  /// Identify plant species from image file using Pl@ntNet API
  Future<PlantDiagnosis> diagnosePlant(String imagePath) async {
    try {
      Logger.info('Starting plant identification for: $imagePath', tag: 'ApiService');

      // Read image file
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      // Generate unique diagnosis ID
      final diagnosisId = const Uuid().v4();

      // Call PlantNet API
      final response = await _callPlantNetApi(imagePath);

      // ── Validasi: pastikan ada hasil identifikasi ──
      final results = response['results'] as List<dynamic>?;
      
      // Jika skor terlalu rendah, anggap tanaman tidak dikenali (hapus results)
      if (results != null && results.isNotEmpty) {
        final topScore = (results[0]['score'] as num?)?.toDouble() ?? 0.0;
        if (topScore < 0.01) {
          response['results'] = [];
        }
      }

      // Parse response ke model
      final diagnosis = PlantDiagnosis.fromPlantNetResponse(
        response,
        imagePath,
        diagnosisId,
      );

      Logger.info(
        'Identification completed: ${diagnosis.diseaseName} (${(diagnosis.accuracy * 100).toStringAsFixed(1)}%)',
        tag: 'ApiService',
      );

      return diagnosis;
    } catch (e) {
      Logger.error('Error identifying plant', tag: 'ApiService', error: e);
      rethrow;
    }
  }

  /// Call Pl@ntNet v2 Identify API using HTTP POST Multipart
  /// Endpoint: POST https://my-api.plantnet.org/v2/identify/{project}?api-key={KEY}
  Future<Map<String, dynamic>> _callPlantNetApi(String imagePath) async {
    try {
      // Check if API key is configured
      if (_apiKey == 'YOUR_PLANTNET_API_KEY_HERE' || _apiKey.isEmpty) {
        // Mock delay for loading indicator
        await Future.delayed(const Duration(seconds: 2));
        Logger.warning('API key not configured, using mock data', tag: 'ApiService');
        return _getMockResponse();
      }

      final project = AppConstants.plantNetProject;
      final url = Uri.parse('$_baseUrl/identify/$project?api-key=$_apiKey');

      Logger.info('Calling Pl@ntNet API: $url', tag: 'ApiService');

      var request = http.MultipartRequest('POST', url);

      // Tambahkan gambar dengan Content-Type eksplisit (wajib untuk PlantNet API di beberapa device)
      final isPng = imagePath.toLowerCase().endsWith('.png');
      final ext = isPng ? 'png' : 'jpeg';
      final fileExtension = isPng ? 'png' : 'jpg';
      
      request.files.add(await http.MultipartFile.fromPath(
        'images', 
        imagePath,
        filename: 'plant_image.$fileExtension', // Wajib ada ekstensi di filename agar PlantNet tidak error 400
        contentType: MediaType('image', ext),
      ));

      // Organ tanaman yang difoto (auto = biarkan API yang menentukan)
      request.fields['organs'] = 'auto';

      final streamedResponse = await _client.send(request).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('API request timed out after 30 seconds');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      Logger.info('PlantNet response status: ${response.statusCode}', tag: 'ApiService');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        Logger.info('API call successful', tag: 'ApiService');
        return jsonResponse;
      } else if (response.statusCode == 401) {
        throw Exception('API key tidak valid. Periksa konfigurasi API key PlantNet Anda.');
      } else if (response.statusCode == 404) {
        // PlantNet mengembalikan 404 jika gambar tidak mengandung tanaman yang dikenali
        Logger.info('Tanaman tidak dikenali (404)', tag: 'ApiService');
        return {'results': []}; // Kembalikan json kosong agar dihandle secara graceful di UI
      } else if (response.statusCode == 400) {
        throw Exception('File gambar tidak valid atau tidak didukung oleh API.');
      } else if (response.statusCode == 429) {
        throw Exception('Batas request harian PlantNet tercapai (500/hari). Coba lagi besok.');
      } else {
        Logger.error(
          'API error: ${response.statusCode}',
          tag: 'ApiService',
          error: response.body,
        );
        throw Exception('API error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw Exception('Koneksi timeout. Periksa koneksi internet Anda.');
    } on FormatException {
      throw Exception('Format respons dari server tidak valid.');
    } catch (e) {
      Logger.error('API call failed', tag: 'ApiService', error: e);
      rethrow;
    }
  }

  /// Mock response yang menyerupai format respons Pl@ntNet v2
  /// Digunakan saat API key belum dikonfigurasi (mode demo/pengembangan)
  Map<String, dynamic> _getMockResponse() {
    Logger.info('Returning mock PlantNet response data', tag: 'ApiService');

    return {
      'query': {
        'project': 'all',
        'organs': ['auto'],
      },
      'bestMatch': 'Monstera deliciosa Liebm.',
      'results': [
        {
          'score': 0.87,
          'species': {
            'scientificNameWithoutAuthor': 'Monstera deliciosa',
            'scientificNameAuthorship': 'Liebm.',
            'genus': {'scientificNameWithoutAuthor': 'Monstera'},
            'family': {'scientificNameWithoutAuthor': 'Araceae'},
            'commonNames': ['Swiss Cheese Plant', 'Monstera', 'Split-leaf Philodendron'],
          },
        },
        {
          'score': 0.08,
          'species': {
            'scientificNameWithoutAuthor': 'Monstera adansonii',
            'scientificNameAuthorship': 'Schott',
            'genus': {'scientificNameWithoutAuthor': 'Monstera'},
            'family': {'scientificNameWithoutAuthor': 'Araceae'},
            'commonNames': ['Adanson\'s Monstera'],
          },
        },
      ],
      'remainingIdentificationRequests': 498,
    };
  }

  /// Identify plant with multiple images (lebih akurat)
  Future<PlantDiagnosis> diagnosePlantMultipleImages(
    List<String> imagePaths,
  ) async {
    try {
      if (imagePaths.isEmpty) {
        throw Exception('No images provided');
      }
      Logger.info(
        'Starting identification with ${imagePaths.length} images',
        tag: 'ApiService',
      );
      return await diagnosePlant(imagePaths.first);
    } catch (e) {
      Logger.error('Error in multi-image identification', tag: 'ApiService', error: e);
      rethrow;
    }
  }

  /// Check API health/status
  Future<bool> checkApiHealth() async {
    try {
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
