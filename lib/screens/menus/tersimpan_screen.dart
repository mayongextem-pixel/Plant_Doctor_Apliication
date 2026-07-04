import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/saved_item.dart';

class TersimpanScreen extends StatelessWidget {
  const TersimpanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = SavedItem.mockData;

    return Scaffold(
      appBar: AppBar(title: const Text('Tersimpan')),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: AppTheme.spacingM,
            mainAxisSpacing: AppTheme.spacingM,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              decoration: AppTheme.cardDecoration,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Icon(item.icon, color: AppTheme.primaryGreen, size: 28),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      item.name,
                      style: AppTheme.titleSmall.copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.typeLabel,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    const Icon(
                      Icons.bookmark_rounded,
                      color: AppTheme.primaryGreen,
                      size: 20,
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
