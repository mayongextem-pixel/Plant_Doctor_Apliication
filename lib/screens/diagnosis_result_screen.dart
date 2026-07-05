import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../config/app_theme.dart';
import '../services/history_service.dart';
import '../services/api_service.dart';
import '../models/plant_diagnosis.dart';
import '../utils/logger.dart';

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
  bool _isLoading = true;
  String? _errorMessage;
  PlantDiagnosis? _diagnosis;
  
  @override
  void initState() {
    super.initState();
    _fetchDiagnosis();
  }

  Future<void> _fetchDiagnosis() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final result = await ApiService.instance.diagnosePlant(widget.imagePath);

      if (mounted) {
        setState(() {
          _diagnosis = result;
          _isLoading = false;
        });
        
        // Auto-save the result
        _autoSaveDiagnosis(result);
      }
    } catch (e) {
      Logger.error('Diagnosis failed', tag: 'DiagnosisResult', error: e);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage ?? 'Terjadi kesalahan'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _autoSaveDiagnosis(PlantDiagnosis diagnosis) async {
    if (_isSaved) return;
    
    try {
      final history = ScanHistory(
        id: diagnosis.id,
        imagePath: diagnosis.imagePath,
        diseaseName: diagnosis.diseaseName,
        accuracy: diagnosis.accuracy,
        date: diagnosis.diagnosisDate,
        description: diagnosis.description,
        treatments: diagnosis.treatments,
      );
      
      await HistoryService.saveScanResult(history);
      if (mounted) {
        setState(() {
          _isSaved = true;
        });
      }
    } catch (e) {
      Logger.error('Failed to auto-save diagnosis', tag: 'DiagnosisResult', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with full-screen image
          _buildSliverAppBar(),

          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryGreen),
                    SizedBox(height: 16),
                    Text('Menganalisis tanaman...', style: AppTheme.titleMedium),
                  ],
                ),
              ),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: AppTheme.errorRed, size: 64),
                      const SizedBox(height: 16),
                      const Text('Gagal Menganalisis', style: AppTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: AppTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _fetchDiagnosis,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // Diagnosis Info Bottom Sheet
            _buildDiagnosisInfo(),

            // Care Instructions Section
            _buildCareInstructions(),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ],
      ),

      // Action Button
      bottomNavigationBar: (!_isLoading && _errorMessage == null) ? _buildBottomActionBar() : null,
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
            // Disease Name & Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _diagnosis!.commonName,
                        style: AppTheme.displayMedium.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      // Tampilkan nama penyakit HANYA jika sakit
                      if (_diagnosis!.severity == 'sakit')
                        Text(
                          'Terdeteksi: ${_diagnosis!.diseaseName}',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.errorRed,
                          ),
                        ),
                    ],
                  ),
                ),
                _AccuracyBadge(accuracy: _diagnosis!.accuracy),
              ],
            ),

            const SizedBox(height: AppTheme.spacingM),

            // Status Badge (Sehat / Sakit)
            _SeverityBadge(severity: _diagnosis!.severity),

            const SizedBox(height: AppTheme.spacingL),

            // Description
            const Text(
              'Informasi Tanaman',
              style: AppTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              _diagnosis!.description,
              style: AppTheme.bodyMedium.copyWith(height: 1.6),
            ),

            const SizedBox(height: AppTheme.spacingL),

            // Kemungkinan spesies alternatif
            if (_diagnosis!.symptoms.isNotEmpty) ...[
              const Text(
                'Kemungkinan Spesies',
                style: AppTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.spacingS),
              ..._diagnosis!.symptoms.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingXS),
                child: Row(
                  children: [
                    const Icon(Icons.eco_rounded, size: 16, color: AppTheme.lightGreen),
                    const SizedBox(width: AppTheme.spacingS),
                    Expanded(
                      child: Text(s, style: AppTheme.bodyMedium),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: AppTheme.spacingL),
            ],

            // Care Guides Icons
            const Text(
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
    final guides = [
      CareGuide(
        icon: Icons.water_drop_rounded,
        label: 'Air',
        value: 'Sesuai',
        description: 'Jaga kelembaban',
      ),
      CareGuide(
        icon: Icons.wb_sunny_rounded,
        label: 'Cahaya',
        value: 'Optimal',
        description: 'Cahaya cukup',
      ),
      CareGuide(
        icon: Icons.science_rounded,
        label: 'Tindakan',
        value: 'Segera',
        description: 'Lihat panduan',
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: guides.map((guide) {
        return _CareGuideItem(guide: guide);
      }).toList(),
    );
  }

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
                    color: _diagnosis!.severity == 'sehat' 
                        ? AppTheme.primaryGreen.withValues(alpha: 0.1)
                        : AppTheme.errorRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    _diagnosis!.severity == 'sehat' ? Icons.eco_rounded : Icons.medical_services_rounded,
                    color: _diagnosis!.severity == 'sehat' ? AppTheme.primaryGreen : AppTheme.errorRed,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Text(
                  _diagnosis!.severity == 'sehat' ? 'Saran Perawatan' : 'Rekomendasi Pengobatan',
                  style: AppTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            // Rekomendasi Text Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: _diagnosis!.severity == 'sehat'
                    ? AppTheme.lightGreen.withValues(alpha: 0.1)
                    : AppTheme.warningYellow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(
                  color: _diagnosis!.severity == 'sehat'
                      ? AppTheme.lightGreen
                      : AppTheme.warningYellow,
                ),
              ),
              child: Text(
                _diagnosis!.treatments.isNotEmpty 
                    ? _diagnosis!.treatments.first 
                    : 'Tidak ada rekomendasi spesifik.',
                style: AppTheme.bodyMedium.copyWith(height: 1.5, color: AppTheme.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSaved ? AppTheme.surfaceColor : AppTheme.primaryGreen,
              foregroundColor: _isSaved ? AppTheme.primaryGreen : AppTheme.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_isSaved ? Icons.check_circle_rounded : Icons.save_rounded, size: 24),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  _isSaved ? 'Tersimpan di Riwayat' : 'Simpan Diagnosis',
                  style: const TextStyle(
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
    if (severity.toLowerCase() == 'sehat') {
      return AppTheme.successGreen;
    } else {
      return AppTheme.errorRed;
    }
  }

  IconData _getSeverityIcon(String severity) {
    if (severity.toLowerCase() == 'sehat') {
      return Icons.check_circle_rounded;
    } else {
      return Icons.warning_rounded;
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

