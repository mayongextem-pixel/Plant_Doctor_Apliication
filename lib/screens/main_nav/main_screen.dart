import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/page_transitions.dart';
import '../camera_screen.dart';
import '../menus/artikel_screen.dart';
import 'home_fragment.dart';
import 'profile_fragment.dart';
import 'koleksi_fragment.dart';

/// Main screen with BottomAppBar, notched FAB camera, and tab switching.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeFragment(),
    KoleksiFragment(),
    ArtikelScreen(),
    ProfileFragment(),
  ];

  void _navigateToCamera() {
    Navigator.of(
      context,
    ).push(PageTransitions.slideAndFadeTransition(const CameraScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),

      // Prominent Center-Docked FAB for Camera
      floatingActionButton: _buildCameraFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCameraFAB() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _navigateToCamera,
        elevation: 0,
        backgroundColor: Colors.transparent,
        tooltip: 'Scan Tanaman',
        child: const Icon(
          Icons.camera_alt_rounded,
          size: 30,
          color: AppTheme.white,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: AppTheme.surfaceColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              0,
              Icons.home_rounded,
              Icons.home_outlined,
              'Beranda',
            ),
            _buildNavItem(1, Icons.eco_rounded, Icons.eco_outlined, 'Koleksi'),
            const SizedBox(width: 56), // Space for FAB
            _buildNavItem(
              2,
              Icons.article_rounded,
              Icons.article_outlined,
              'Artikel',
            ),
            _buildNavItem(
              3,
              Icons.person_rounded,
              Icons.person_outline_rounded,
              'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : inactiveIcon,
                color: isActive ? AppTheme.primaryColor : AppTheme.textLight,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppTheme.primaryColor : AppTheme.textLight,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
