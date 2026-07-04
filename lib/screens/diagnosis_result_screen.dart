import 'dart:io';
import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// Modern Diagnosis Result Screen following update_design.md
/// Features: SliverAppBar with full-screen image, Bottom sheet info, Care guides
class DiagnosisResultScreen extends StatefulWidget {
  final String imagePath;

  const DiagnosisResultScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<DiagnosisResultScreen> createState() => _DiagnosisResultScreenState();
}

class _DiagnosisResultScreenState extends State<DiagnosisResultScreen> {
  bool _isSaved = false;
  
  // Mock diagnosis data (will be replaced with API response)
  final DiagnosisResult _mockResult = DiagnosisResult(
    diseaseName: 'Bercak Daun Coklat',
    scientificName: 'Phyllosticta leaf spot',
    accuracy: 0.87,
    severity: 'Sedang',
    description: 'Penyakit jamur yang menyebabkan bercak coklat pada daun. Biasanya disebabkan oleh kelembaban tinggi dan sirkulasi udara yang buruk.',
    careInstructions: [
      'Buang daun yang terinfeksi segera',
      'Kurangi penyiraman dan hindari membasahi daun',
      'Tingkatkan sirkulasi udara di sekitar tanaman',
      'Aplikasikan fungisida organik jika diperlukan',
      'Karantina tanaman dari tanaman sehat lainnya',
    ],
    careGuides: [
      CareGuide(
        icon: Icons.water_drop_rounded,
        label: 'Air',
        value: 'Sedang',
        description: 'Siram 2-3x seminggu',
      ),
      CareGuide(
        icon: Icons.wb_sunny_rounded,
        label: 'Cahaya',
        value: 'Penuh',
        description: 'Sinar tidak langsung',
      ),
      CareGuide(
        icon: Icons.warning_amber_rounded,
        label: 'Karantina',
        value: 'Ya',
        description: 'Pisahkan 2 minggu',
      ),
      CareGuide(
        icon: Icons.science_rounded,
        label: 'Treatment',
        value: 'Fungisida',
        description: 'Seminggu sekali',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with full-screen image
          _buildSliverAppBar(),

          // Diagnosis Info Bottom Sheet
          _buildDiagnosisInfo(),

          // Care Instructions Section
          _buildCareInstructions(),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // Action Button
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  /// SliverAppBar with full-screen captured image
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.backgroundColor,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          decoration: BoxDecoration(
            color: AppTheme.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.textDark,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Implement share
          },
          icon: Container(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            decoration: BoxDecoration(
              color: AppTheme.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share_rounded,
              color: AppTheme.textDark,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isSaved = !_isSaved;
            });
          },
          icon: Container(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            decoration: BoxDecoration(
              color: AppTheme.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isSaved ? AppTheme.primaryGreen : AppTheme.textDark,
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingS),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'plant_image_${widget.imagePath}',
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              image: File(widget.imagePath).existsSync()
                  ? DecorationImage(
                      image: FileImage(File(widget.imagePath)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !File(widget.imagePath).existsSync()
                ? Center(
                    child: Icon(
                      Icons.image_rounded,
                      size: 80,
                      color: AppTheme.textLight.withValues(alpha: 0.3),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  /// Diagnosis Information Bottom Sheet Style
  Widget _buildDiagnosisInfo() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: AppTheme.spacingM),
        padding: const EdgeInsets.all(AppTheme.spacingL),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusLarge),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disease Name & Accuracy
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _mockResult.diseaseName,
                        style: AppTheme.displayMedium.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        _mockResult.scientificName,
                        style: AppTheme.bodyMedium.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                _AccuracyBadge(accuracy: _mockResult.accuracy),
              ],
            ),

            const SizedBox(height: AppTheme.spacingM),

            // Severity Badge
            _SeverityBadge(severity: _mockResult.severity),

            const SizedBox(height: AppTheme.spacingL),

            // Description
            Text(
              'Deskripsi',
              style: AppTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              _mockResult.description,
              style: AppTheme.bodyMedium.copyWith(height: 1.6),
            ),

            const SizedBox(height: AppTheme.spacingL),

            // Care Guides Icons
            Text(
              'Panduan Perawatan',
              style: AppTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            _buildCareGuidesRow(),
          ],
        ),
      ),
    );
  }

  /// Care Guides Icon Row
  Widget _buildCareGuidesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _mockResult.careGuides.map((guide) {
        return _CareGuideItem(guide: guide);
      }).toList(),
    );
  }

  /// Care Instructions List
  Widget _buildCareInstructions() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(AppTheme.spacingM),
        padding: const EdgeInsets.all(AppTheme.spacingL),
        decoration: AppTheme.cardDecorationElevated,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: const Icon(
                    Icons.healing_rounded,
                    color: AppTheme.primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                const Text(
                  'Langkah Penanganan',
                  style: AppTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            ..._mockResult.careInstructions.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTheme.bodyMedium.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Bottom Action Bar
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              _showSaveConfirmation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_rounded, size: 24),
                SizedBox(width: AppTheme.spacingS),
                Text(
                  'Simpan Diagnosis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSaveConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        icon: Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: AppTheme.successGreen,
            size: 48,
          ),
        ),
        title: const Text('Diagnosis Tersimpan'),
        content: const Text(
          'Hasil diagnosis telah disimpan ke koleksi Anda.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to dashboard
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Accuracy Badge Widget
class _AccuracyBadge extends StatelessWidget {
  final double accuracy;

  const _AccuracyBadge({required this.accuracy});

  @override
  Widget build(BuildContext context) {
    final percentage = (accuracy * 100).toInt();
    final color = accuracy >= 0.8
        ? AppTheme.successGreen
        : accuracy >= 0.6
            ? AppTheme.warningYellow
            : AppTheme.errorRed;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            'Akurasi',
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Severity Badge Widget
class _SeverityBadge extends StatelessWidget {
  final String severity;

  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    final color = _getSeverityColor(severity);
    final icon = _getSeverityIcon(severity);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            'Tingkat: $severity',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'ringan':
        return AppTheme.successGreen;
      case 'sedang':
        return AppTheme.warningYellow;
      case 'parah':
        return AppTheme.errorRed;
      default:
        return AppTheme.textMedium;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'ringan':
        return Icons.check_circle_rounded;
      case 'sedang':
        return Icons.warning_rounded;
      case 'parah':
        return Icons.error_rounded;
      default:
        return Icons.info_rounded;
    }
  }
}

/// Care Guide Item Widget
class _CareGuideItem extends StatelessWidget {
  final CareGuide guide;

  const _CareGuideItem({required this.guide});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Icon(
            guide.icon,
            color: AppTheme.primaryGreen,
            size: 28,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          guide.label,
          style: AppTheme.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        Text(
          guide.value,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textLight,
          ),
        ),
      ],
    );
  }
}

// Data Models
class DiagnosisResult {
  final String diseaseName;
  final String scientificName;
  final double accuracy;
  final String severity;
  final String description;
  final List<String> careInstructions;
  final List<CareGuide> careGuides;

  DiagnosisResult({
    required this.diseaseName,
    required this.scientificName,
    required this.accuracy,
    required this.severity,
    required this.description,
    required this.careInstructions,
    required this.careGuides,
  });
}

class CareGuide {
  final IconData icon;
  final String label;
  final String value;
  final String description;

  CareGuide({
    required this.icon,
    required this.label,
    required this.value,
    required this.description,
  });
}

