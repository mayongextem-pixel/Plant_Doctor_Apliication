import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../utils/page_transitions.dart';
import 'camera_screen.dart';

/// Modern Dashboard Screen following update_design.md
/// Features: Search bar, Quick action menu, Promotional banner, Grid collection
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentBottomNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Mock data for plant history
  final List<PlantHistory> _plantHistory = [
    PlantHistory(
      id: '1',
      plantName: 'Monstera Deliciosa',
      status: 'Sehat',
      scanDate: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: '',
      isHealthy: true,
    ),
    PlantHistory(
      id: '2',
      plantName: 'Sansevieria',
      status: 'Terinfeksi',
      scanDate: DateTime.now().subtract(const Duration(days: 5)),
      imageUrl: '',
      isHealthy: false,
    ),
    PlantHistory(
      id: '3',
      plantName: 'Pothos',
      status: 'Sehat',
      scanDate: DateTime.now().subtract(const Duration(days: 7)),
      imageUrl: '',
      isHealthy: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom AppBar with Greeting and Search
            _buildAppBar(),

            // Quick Action Menu
            SliverToBoxAdapter(
              child: _buildQuickActionMenu(),
            ),

            // Promotional Banner (Tips Harian)
            SliverToBoxAdapter(
              child: _buildPromotionalBanner(),
            ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingM,
                  AppTheme.spacingXL,
                  AppTheme.spacingM,
                  AppTheme.spacingM,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Koleksi Tanamanku',
                      style: AppTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to full collection
                      },
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
              ),
            ),

            // Plant Collection Grid
            _buildPlantCollectionGrid(),

            // Bottom padding for FAB
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),

      // Prominent Center-Docked FAB for Camera
      floatingActionButton: _buildCameraFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Custom AppBar with greeting and search bar
  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const Text(
              'Selamat Datang! 👋',
              style: AppTheme.displayMedium,
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              'Mari rawat tanamanmu hari ini',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Search Bar
            SearchBar(
              controller: _searchController,
              hintText: 'Cari tanaman atau artikel...',
              leading: const Icon(Icons.search_rounded, size: 24),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  ),
              ],
              onChanged: (value) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Quick Action Menu (Horizontal scroll)
  Widget _buildQuickActionMenu() {
    final quickActions = [
      QuickAction(
        icon: Icons.history_rounded,
        label: 'Riwayat',
        color: AppTheme.primaryGreen,
        onTap: () {
          // TODO: Navigate to history
        },
      ),
      QuickAction(
        icon: Icons.article_rounded,
        label: 'Artikel',
        color: AppTheme.accentOrange,
        onTap: () {
          // TODO: Navigate to articles
        },
      ),
      QuickAction(
        icon: Icons.lightbulb_rounded,
        label: 'Tips Harian',
        color: AppTheme.accentYellow,
        onTap: () {
          // TODO: Navigate to tips
        },
      ),
      QuickAction(
        icon: Icons.bookmark_rounded,
        label: 'Tersimpan',
        color: AppTheme.lightGreen,
        onTap: () {
          // TODO: Navigate to saved
        },
      ),
    ];

    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
        itemCount: quickActions.length,
        itemBuilder: (context, index) {
          final action = quickActions[index];
          return _QuickActionCard(action: action);
        },
      ),
    );
  }

  /// Promotional Banner for Tips Harian
  Widget _buildPromotionalBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: InkWell(
        onTap: () {
          // TODO: Show daily tip details
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.lightGreen,
                AppTheme.primaryGreen,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: AppTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: const Text(
                        'Tips Hari Ini',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    const Text(
                      'Penyiraman Optimal',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'Siram tanaman di pagi hari untuk hasil terbaik',
                      style: TextStyle(
                        color: AppTheme.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppTheme.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: AppTheme.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Plant Collection Grid
  Widget _buildPlantCollectionGrid() {
    if (_plantHistory.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.eco_rounded,
                size: 80,
                color: AppTheme.textLight.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                'Belum ada tanaman terscan',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              TextButton.icon(
                onPressed: () {
                  _navigateToCamera();
                },
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Mulai Scan'),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: AppTheme.spacingM,
          mainAxisSpacing: AppTheme.spacingM,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final plant = _plantHistory[index];
            return _PlantCard(plant: plant);
          },
          childCount: _plantHistory.length,
        ),
      ),
    );
  }

  /// Prominent Center-Docked FAB for Camera
  Widget _buildCameraFAB() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppTheme.lightGreen,
            AppTheme.primaryGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _navigateToCamera,
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: const Icon(
          Icons.camera_alt_rounded,
          size: 32,
          color: AppTheme.white,
        ),
      ),
    );
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: (index) {
        setState(() {
          _currentBottomNavIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections_rounded),
          label: 'Koleksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_rounded),
          label: 'Artikel',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profil',
        ),
      ],
    );
  }

  void _navigateToCamera() {
    Navigator.of(context).push(
      PageTransitions.slideAndFadeTransition(
        const CameraScreen(),
      ),
    );
  }
}

/// Quick Action Card Widget
class _QuickActionCard extends StatelessWidget {
  final QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: AppTheme.spacingM),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(
                action.icon,
                color: action.color,
                size: 28,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              action.label,
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Plant Card Widget for Grid
class _PlantCard extends StatelessWidget {
  final PlantHistory plant;

  const _PlantCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to plant detail
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusMedium),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.local_florist_rounded,
                        size: 48,
                        color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    Positioned(
                      top: AppTheme.spacingS,
                      right: AppTheme.spacingS,
                      child: _StatusBadge(isHealthy: plant.isHealthy),
                    ),
                  ],
                ),
              ),
            ),

            // Plant Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plant.plantName,
                      style: AppTheme.titleSmall.copyWith(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: AppTheme.textLight,
                        ),
                        const SizedBox(width: AppTheme.spacingXS),
                        Text(
                          _formatDate(plant.scanDate),
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Status Badge Widget
class _StatusBadge extends StatelessWidget {
  final bool isHealthy;

  const _StatusBadge({required this.isHealthy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: isHealthy
            ? AppTheme.successGreen
            : AppTheme.errorRed,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        isHealthy ? 'Sehat' : 'Sakit',
        style: const TextStyle(
          color: AppTheme.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Data Models
class QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class PlantHistory {
  final String id;
  final String plantName;
  final String status;
  final DateTime scanDate;
  final String imageUrl;
  final bool isHealthy;

  PlantHistory({
    required this.id,
    required this.plantName,
    required this.status,
    required this.scanDate,
    required this.imageUrl,
    required this.isHealthy,
  });
}

