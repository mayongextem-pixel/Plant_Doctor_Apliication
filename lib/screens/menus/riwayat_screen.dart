import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/history_service.dart';

/// Riwayat Deteksi Screen — shows detection history
/// [showAsTab] - when true, hides the AppBar (used inside KoleksiFragment tab)
class RiwayatScreen extends StatefulWidget {
  final bool showAsTab;
  const RiwayatScreen({super.key, this.showAsTab = false});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<ScanHistory> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await HistoryService.getHistory();
    if (!mounted) return;
    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Hari ini';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_history.isEmpty) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded,
                size: 80,
                color: AppTheme.textLight.withValues(alpha: 0.4)),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Belum ada riwayat scan',
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.textLight),
            ),
          ],
        ),
      );
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: _history.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingS),
        itemBuilder: (context, index) {
          final item = _history[index];
          final isHealthy = item.diseaseName.toLowerCase().contains('sehat');
          
          return Container(
            decoration: AppTheme.cardDecoration,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              leading: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: (isHealthy
                          ? AppTheme.successGreen
                          : AppTheme.errorRed)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(
                  isHealthy ? Icons.eco_rounded : Icons.warning_rounded,
                  color: isHealthy ? AppTheme.successGreen : AppTheme.errorRed,
                  size: 28,
                ),
              ),
              title: Text(item.diseaseName, style: AppTheme.titleSmall),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(item.date),
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  '${(item.accuracy * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: item.accuracy >= 0.8
                        ? AppTheme.successGreen
                        : AppTheme.warningYellow,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    if (widget.showAsTab) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Deteksi'),
      ),
      body: SafeArea(child: body),
    );
  }
}
