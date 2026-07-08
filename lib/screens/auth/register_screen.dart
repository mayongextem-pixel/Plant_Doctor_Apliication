import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_theme.dart';
import '../../utils/page_transitions.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/app_constants.dart';
import '../main_nav/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.laravelApiBaseUrl}/auth/register'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final token = responseData['data']['token'];
        final role = responseData['data']['user']['role']['slug'];
        final userId = responseData['data']['user']['id'].toString();
        final userName = responseData['data']['user']['name'].toString();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('api_token', token);
        await prefs.setString('user_role', role);
        await prefs.setString('user_id', userId);
        await prefs.setString('user_name', userName);

        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          PageTransitions.fadeTransition(const MainScreen()),
          (route) => false,
        );
      } else {
        String msg = responseData['message'] ?? 'Gagal mendaftar.';
        if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          msg = errors.values.first[0];
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: AppTheme.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Koneksi bermasalah: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
              // ── Hero header ────────────────────────────────────────────
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
                      'Buat Akun',
                      style: AppTheme.displayMedium.copyWith(
                        color: AppTheme.white,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'Baru.',
                      style: AppTheme.displayMedium.copyWith(
                        color: AppTheme.tertiaryColor,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'Bergabung dan mulai rawat tanamanmu.',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.white.withValues(alpha: 0.75),
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Form area ─────────────────────────────────────────────
              Container(
                decoration: const BoxDecoration(
                  color: AppTheme.neutralColor,
                  borderRadius: BorderRadius.vertical(
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
                        'Detail Akun',
                        style: AppTheme.titleMedium.copyWith(
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      AppTextField(
                        label: 'Nama Lengkap',
                        controller: _nameController,
                        validator: Validators.name,
                        prefixIcon: Icons.person_outline_rounded,
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
                      const SizedBox(height: AppTheme.spacingXS),
                      AppTextField(
                        label: 'Konfirmasi Password',
                        controller: _confirmPasswordController,
                        validator: Validators.confirmPassword(_passwordController),
                        isPasswordField: true,
                        prefixIcon: Icons.lock_outline_rounded,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      AppButton(
                        label: 'Daftar',
                        onPressed: _handleRegister,
                        isLoading: _isLoading,
                        variant: AppButtonVariant.primary,
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
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
