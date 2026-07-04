/// Model for plant diagnosis result
class PlantDiagnosis {
  final String id;
  final String imagePath;
  final String diseaseName;
  final String commonName;
  final double accuracy;
  final String severity; // healthy, mild, moderate, severe
  final List<String> symptoms;
  final List<String> treatments;
  final String description;
  final DateTime diagnosisDate;
  final bool isSaved;

  PlantDiagnosis({
    required this.id,
    required this.imagePath,
    required this.diseaseName,
    required this.commonName,
    required this.accuracy,
    required this.severity,
    required this.symptoms,
    required this.treatments,
    required this.description,
    required this.diagnosisDate,
    this.isSaved = false,
  });

  // Factory constructor to create from JSON
  factory PlantDiagnosis.fromJson(Map<String, dynamic> json) {
    return PlantDiagnosis(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      diseaseName: json['diseaseName'] as String,
      commonName: json['commonName'] as String? ?? '',
      accuracy: (json['accuracy'] as num).toDouble(),
      severity: json['severity'] as String? ?? 'unknown',
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      treatments: (json['treatments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      description: json['description'] as String? ?? '',
      diagnosisDate: DateTime.parse(json['diagnosisDate'] as String),
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'diseaseName': diseaseName,
      'commonName': commonName,
      'accuracy': accuracy,
      'severity': severity,
      'symptoms': symptoms,
      'treatments': treatments,
      'description': description,
      'diagnosisDate': diagnosisDate.toIso8601String(),
      'isSaved': isSaved,
    };
  }

  // Factory constructor to create from API response (Plant.id format)
  factory PlantDiagnosis.fromApiResponse(
    Map<String, dynamic> apiData,
    String imagePath,
    String diagnosisId,
  ) {
    // ── Lapisan validasi kedua: cek is_plant di dalam model ──
    // Plant.id v3 mengembalikan result.is_plant dengan probability dan binary flag.
    final isPlantData = apiData['result']?['is_plant'];
    if (isPlantData != null) {
      final probability = (isPlantData['probability'] as num?)?.toDouble() ?? 1.0;
      final binary = isPlantData['binary'] as bool? ?? true;
      if (!binary || probability < 0.2) {
        final pct = (probability * 100).toStringAsFixed(0);
        throw Exception(
          'Gambar yang difoto bukan tanaman ($pct% kemungkinan tanaman). '
          'Arahkan kamera ke daun atau bagian tanaman yang jelas.',
        );
      }
    }

    // Extract the best matching disease
    final suggestions = apiData['health_assessment']?['diseases'] as List<dynamic>? ?? [];
    
    if (suggestions.isEmpty) {
      // Healthy plant
      return PlantDiagnosis(
        id: diagnosisId,
        imagePath: imagePath,
        diseaseName: 'Healthy Plant',
        commonName: 'Tanaman Sehat',
        accuracy: 1.0,
        severity: 'healthy',
        symptoms: ['Tidak ada gejala penyakit'],
        treatments: ['Lanjutkan perawatan rutin', 'Pastikan penyiraman dan pencahayaan yang cukup'],
        description: 'Tanaman Anda dalam kondisi sehat. Tidak ditemukan tanda-tanda penyakit.',
        diagnosisDate: DateTime.now(),
        isSaved: false,
      );
    }

    final topDisease = suggestions[0] as Map<String, dynamic>;
    final diseaseName = topDisease['name'] as String? ?? 'Unknown Disease';
    final probability = (topDisease['probability'] as num?)?.toDouble() ?? 0.0;
    final diseaseDetails = topDisease['disease_details'] as Map<String, dynamic>? ?? {};

    // Determine severity based on probability and disease info
    String severity = 'moderate';
    if (probability >= 0.8) {
      severity = 'severe';
    } else if (probability >= 0.5) {
      severity = 'moderate';
    } else {
      severity = 'mild';
    }

    // Extract symptoms and treatments
    final description = diseaseDetails['description'] as String? ?? 
        'Penyakit yang mempengaruhi tanaman Anda.';
    
    final symptomsData = diseaseDetails['symptoms'] as List<dynamic>? ?? [];
    final symptoms = symptomsData.isEmpty
        ? ['Gejala tidak terdeteksi secara detail']
        : symptomsData.map((e) => e.toString()).toList();

    final treatmentsData = diseaseDetails['treatment'] as Map<String, dynamic>? ?? {};
    final treatmentsList = <String>[];
    
    // Extract biological, chemical, and prevention methods
    if (treatmentsData['biological'] != null) {
      final biological = treatmentsData['biological'] as List<dynamic>? ?? [];
      treatmentsList.addAll(biological.map((e) => 'Biologis: $e'));
    }
    if (treatmentsData['chemical'] != null) {
      final chemical = treatmentsData['chemical'] as List<dynamic>? ?? [];
      treatmentsList.addAll(chemical.map((e) => 'Kimia: $e'));
    }
    if (treatmentsData['prevention'] != null) {
      final prevention = treatmentsData['prevention'] as List<dynamic>? ?? [];
      treatmentsList.addAll(prevention.map((e) => 'Pencegahan: $e'));
    }

    if (treatmentsList.isEmpty) {
      treatmentsList.add('Konsultasikan dengan ahli pertanian');
      treatmentsList.add('Isolasi tanaman yang terinfeksi');
      treatmentsList.add('Jaga kebersihan area tanam');
    }

    return PlantDiagnosis(
      id: diagnosisId,
      imagePath: imagePath,
      diseaseName: diseaseName,
      commonName: diseaseDetails['common_names']?.first ?? diseaseName,
      accuracy: probability,
      severity: severity,
      symptoms: symptoms,
      treatments: treatmentsList,
      description: description,
      diagnosisDate: DateTime.now(),
      isSaved: false,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Factory: buat dari respons Pl@ntNet API v2
  // Pl@ntNet mengidentifikasi SPESIES tanaman, bukan penyakit.
  // Kita tampilkan nama spesies sebagai hasil identifikasi + saran perawatan umum.
  // ─────────────────────────────────────────────────────────────────────────
  factory PlantDiagnosis.fromPlantNetResponse(
    Map<String, dynamic> apiData,
    String imagePath,
    String diagnosisId,
  ) {
    final results = apiData['results'] as List<dynamic>? ?? [];

    if (results.isEmpty) {
      return PlantDiagnosis(
        id: diagnosisId,
        imagePath: imagePath,
        diseaseName: 'Tanaman Tidak Dikenali',
        commonName: 'Unknown Plant',
        accuracy: 0.0,
        severity: 'unknown',
        symptoms: ['Tidak dapat mengidentifikasi tanaman dari gambar ini.'],
        treatments: [
          'Coba ambil foto dengan pencahayaan yang lebih baik',
          'Pastikan daun atau bunga terlihat jelas',
          'Hindari foto yang buram atau terlalu jauh',
        ],
        description: 'Aplikasi tidak dapat mengidentifikasi tanaman dari gambar yang diberikan.',
        diagnosisDate: DateTime.now(),
        isSaved: false,
      );
    }

    // Ambil hasil terbaik (index 0 sudah diurutkan berdasarkan skor tertinggi)
    final top = results[0] as Map<String, dynamic>;
    final score = (top['score'] as num?)?.toDouble() ?? 0.0;
    final species = top['species'] as Map<String, dynamic>? ?? {};

    final scientificName = species['scientificNameWithoutAuthor'] as String? ?? 'Unknown';
    final authorship = species['scientificNameAuthorship'] as String? ?? '';
    final genus = (species['genus'] as Map<String, dynamic>?)?['scientificNameWithoutAuthor'] as String? ?? '';
    final family = (species['family'] as Map<String, dynamic>?)?['scientificNameWithoutAuthor'] as String? ?? '';
    final commonNames = (species['commonNames'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final commonName = commonNames.isNotEmpty ? commonNames.first : scientificName;

    // Tentukan tingkat kepercayaan identifikasi
    String severity;
    if (score >= 0.7) {
      severity = 'sehat'; // identifikasi sangat yakin
    } else if (score >= 0.4) {
      severity = 'ringan'; // identifikasi cukup yakin
    } else {
      severity = 'sedang'; // identifikasi kurang yakin
    }

    // Bangun deskripsi dari data yang tersedia
    final scorePct = (score * 100).toStringAsFixed(1);
    final description = 'Tanaman ini teridentifikasi sebagai $scientificName $authorship '
        '(Famili: $family, Genus: $genus) dengan tingkat kepercayaan $scorePct%. '
        '${commonNames.isNotEmpty ? "Nama umum: ${commonNames.join(', ')}." : ""}';

    // Saran perawatan umum
    final treatments = [
      'Pastikan tanaman mendapatkan cahaya yang sesuai dengan jenisnya',
      'Siram secara teratur — cek kelembaban tanah sebelum menyiram',
      'Gunakan pupuk yang sesuai untuk keluarga ${family.isNotEmpty ? family : "tanaman ini"}',
      'Periksa secara rutin adanya tanda-tanda hama atau penyakit pada daun',
      'Jaga sirkulasi udara yang baik di sekitar tanaman',
    ];

    // Daftar nama alternatif dari semua hasil teratas
    final alternativeNames = results
        .take(3)
        .map((r) {
          final sp = r['species'] as Map<String, dynamic>? ?? {};
          final sc = (r['score'] as num?)?.toDouble() ?? 0.0;
          final name = sp['scientificNameWithoutAuthor'] as String? ?? 'Unknown';
          final pct = (sc * 100).toStringAsFixed(0);
          return 'Kemungkinan $name ($pct%)';
        })
        .toList();

    return PlantDiagnosis(
      id: diagnosisId,
      imagePath: imagePath,
      diseaseName: scientificName,
      commonName: commonName,
      accuracy: score,
      severity: severity,
      symptoms: alternativeNames.isNotEmpty ? alternativeNames : ['Identifikasi berhasil'],
      treatments: treatments,
      description: description,
      diagnosisDate: DateTime.now(),
      isSaved: false,
    );
  }


  // Create a copy with modified fields
  PlantDiagnosis copyWith({
    String? id,
    String? imagePath,
    String? diseaseName,
    String? commonName,
    double? accuracy,
    String? severity,
    List<String>? symptoms,
    List<String>? treatments,
    String? description,
    DateTime? diagnosisDate,
    bool? isSaved,
  }) {
    return PlantDiagnosis(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      diseaseName: diseaseName ?? this.diseaseName,
      commonName: commonName ?? this.commonName,
      accuracy: accuracy ?? this.accuracy,
      severity: severity ?? this.severity,
      symptoms: symptoms ?? this.symptoms,
      treatments: treatments ?? this.treatments,
      description: description ?? this.description,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  String toString() {
    return 'PlantDiagnosis(id: $id, diseaseName: $diseaseName, accuracy: $accuracy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlantDiagnosis && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
