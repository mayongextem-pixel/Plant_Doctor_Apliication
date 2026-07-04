import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/tip_item.dart';

class TipsHarianScreen extends StatelessWidget {
  const TipsHarianScreen({super.key});

  Color _getCategoryColor(TipCategory category) {
    switch (category) {
      case TipCategory.penyiraman:
        return const Color(0xFF5B9BD5);
      case TipCategory.pemupukan:
        return AppTheme.successGreen;
      case TipCategory.pencahayaan:
        return AppTheme.accentYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tips = TipItem.mockData;

    return Scaffold(
      appBar: AppBar(title: const Text('Tips Harian')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          itemCount: tips.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingS),
          itemBuilder: (context, index) {
            final tip = tips[index];
            final catColor = _getCategoryColor(tip.category);
            return Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Icon(tip.icon, color: catColor, size: 24),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(tip.title, style: AppTheme.titleSmall),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingS,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tip.categoryLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: catColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(tip.description, style: AppTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
