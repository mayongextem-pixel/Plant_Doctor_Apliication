import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../utils/page_transitions.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import 'register_screen.dart';
import '../main_nav/main_screen.dart';
import '../admin/admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.laravelApiBaseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['data']['token'];
        final role = responseData['data']['user']['role']['slug'];

        final prefs = await SharedPreferences.getInstance();
        final userId = responseData['data']['user']['id']?.toString() ?? '';
        final userName = responseData['data']['user']['name']?.toString() ?? '';
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('api_token', token);
        await prefs.setString('user_role', role);
        await prefs.setString('user_id', userId);
        await prefs.setString('user_name', userName);

        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          PageTransitions.fadeTransition(
            role == 'admin' ? const AdminScreen() : const MainScreen(),
          ),
          (route) => false,
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showErrorSnackBar(errorData['message'] ?? 'Email atau password salah!');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Gagal terhubung ke server. Pastikan server aktif.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Hero header (dark primary background) ─────────────────
              Container(
                color: AppTheme.primaryColor,
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingS,
                  AppTheme.spacingS,
                  AppTheme.spacingS,
                  AppTheme.spacingM,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppTheme.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: AppTheme.primaryColor,
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingS,
                  0,
                  AppTheme.spacingS,
                  AppTheme.spacingL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang',
                      style: AppTheme.displayMedium.copyWith(
                        color: AppTheme.white,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'Kembali!',
                      style: AppTheme.displayMedium.copyWith(
                        color: AppTheme.tertiaryColor,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'Masuk untuk melanjutkan diagnosis tanaman.',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.white.withValues(alpha: 0.75),
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Form area (white card) ──────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.neutralColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusXLarge),
                  ),
                ),
                padding: const EdgeInsets.all(AppTheme.spacingS),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        'Masuk ke Akun',
                        style: AppTheme.titleMedium.copyWith(
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      AppTextField(
                        label: 'Email',
                        controller: _emailController,
                        validator: Validators.email,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      AppTextField(
                        label: 'Password',
                        controller: _passwordController,
                        validator: Validators.password,
                        isPasswordField: true,
                        prefixIcon: Icons.lock_outlined,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      // ── button-primary: kuning CTA ─────────────────
                      AppButton(
                        label: 'Masuk',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                        variant: AppButtonVariant.primary,
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      // ── Daftar link ────────────────────────────────
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: AppTheme.bodySmall.copyWith(
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageTransitions.slideAndFadeTransition(
                                    const RegisterScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.secondaryColor,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Daftar Sekarang',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.secondaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
