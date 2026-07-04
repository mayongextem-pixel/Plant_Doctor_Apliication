import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../menus/riwayat_screen.dart';

/// Koleksi Fragment — Shows user's scanned plant collection & detection history
class KoleksiFragment extends StatelessWidget {
  const KoleksiFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Koleksi Saya'),
          bottom: TabBar(
            indicatorColor: AppTheme.primaryGreen,
            labelColor: AppTheme.primaryGreen,
            unselectedLabelColor: AppTheme.textLight,
            tabs: const [
              Tab(text: 'Tanaman'),
              Tab(text: 'Riwayat Scan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TanamanTab(),
            RiwayatScreen(showAsTab: true),
          ],
        ),
      ),
    );
  }
}

class _TanamanTab extends StatelessWidget {
  const _TanamanTab();

  @override
  Widget build(BuildContext context) {
    // Mock collection data
    final plants = [
      {'name': 'Monstera Deliciosa', 'status': 'Sehat', 'healthy': true},
      {'name': 'Sansevieria', 'status': 'Terinfeksi', 'healthy': false},
      {'name': 'Pothos', 'status': 'Sehat', 'healthy': true},
      {'name': 'Lidah Buaya', 'status': 'Sehat', 'healthy': true},
    ];

    if (plants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.eco_rounded,
              size: 80,
              color: AppTheme.textLight.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Belum ada tanaman tersimpan',
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.textLight),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Scan tanaman dengan kamera untuk memulai',
              style: AppTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppTheme.spacingM,
        mainAxisSpacing: AppTheme.spacingM,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        final isHealthy = plant['healthy'] as bool;

        return Container(
          decoration: AppTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.local_florist_rounded,
                          size: 52,
                          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      Positioned(
                        top: AppTheme.spacingS,
                        right: AppTheme.spacingS,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isHealthy
                                ? AppTheme.successGreen
                                : AppTheme.errorRed,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            isHealthy ? 'Sehat' : 'Sakit',
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plant['name'] as String,
                        style: AppTheme.titleSmall.copyWith(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        plant['status'] as String,
                        style: AppTheme.bodySmall.copyWith(
                          color: isHealthy
                              ? AppTheme.successGreen
                              : AppTheme.errorRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
