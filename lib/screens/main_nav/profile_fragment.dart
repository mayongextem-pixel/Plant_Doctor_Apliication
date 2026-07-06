import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../services/history_service.dart';
import '../../services/storage_service.dart';
import '../../utils/page_transitions.dart';
import '../auth/welcome_screen.dart';

/// Profile / Akun Fragment
class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  String _userName = 'Pengguna Plant Doctor';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? '';
    if (mounted && name.isNotEmpty) {
      setState(() => _userName = name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          children: [
            const SizedBox(height: AppTheme.spacingM),

            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 60,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Center(
              child: Text(_userName, style: AppTheme.titleMedium),
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Stat cards
            Row(
              children: [
                _StatCard(
                  label: 'Tanaman',
                  value: '4',
                  icon: Icons.eco_rounded,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(width: AppTheme.spacingM),
                _StatCard(
                  label: 'Scan',
                  value: '7',
                  icon: Icons.camera_alt_rounded,
                  color: AppTheme.accentOrange,
                ),
                const SizedBox(width: AppTheme.spacingM),
                _StatCard(
                  label: 'Artikel Dibaca',
                  value: '3',
                  icon: Icons.article_rounded,
                  color: AppTheme.accentYellow,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Menu items
            _buildMenuTile(
              icon: Icons.notifications_outlined,
              title: 'Notifikasi',
              onTap: () {},
            ),
            _buildMenuTile(
              icon: Icons.info_outline_rounded,
              title: 'Tentang Aplikasi',
              onTap: () => _showAboutDialog(context),
            ),
            _buildMenuTile(
              icon: Icons.help_outline_rounded,
              title: 'Bantuan & FAQ',
              onTap: () {},
            ),
            const SizedBox(height: AppTheme.spacingM),
            OutlinedButton.icon(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('api_token');

                // 1. Panggil backend logout agar token server ikut dihapus
                if (token != null && token.isNotEmpty) {
                  try {
                    await http.post(
                      Uri.parse('${AppConstants.laravelApiBaseUrl}/auth/logout'),
                      headers: {
                        'Authorization': 'Bearer $token',
                        'Accept': 'application/json',
                      },
                    ).timeout(const Duration(seconds: 5));
                  } catch (_) {
                    // Abaikan jika server tidak bisa dijangkau; logout tetap lanjut
                  }
                }

                // 2. Hapus riwayat scan milik user ini (sebelum user_id dihapus)
                await HistoryService.clearHistory();

                // 3. Reset StorageService singleton agar tidak cached untuk user berikutnya
                StorageService.resetInstance();

                // 4. Hapus semua session key — jangan gunakan prefs.clear()
                //    agar data user LAIN yang tersimpan dengan key berbeda tetap aman.
                await prefs.remove('isLoggedIn');
                await prefs.remove('api_token');
                await prefs.remove('user_role');
                await prefs.remove('user_id');
                await prefs.remove('user_name');

                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  PageTransitions.fadeTransition(const WelcomeScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Keluar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorRed,
                side: const BorderSide(color: AppTheme.errorRed),
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryGreen),
      title: Text(title, style: AppTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textLight),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Plant Doctor',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.local_florist_rounded,
        color: AppTheme.primaryGreen,
        size: 48,
      ),
      children: const [
        Text('Aplikasi deteksi penyakit tanaman berbasis AI.\n\nDikembangkan sebagai UAS Pemrograman Mobile.'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
        decoration: AppTheme.cardDecoration,
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppTheme.spacingXS),
            Text(value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
            Text(label, style: AppTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
