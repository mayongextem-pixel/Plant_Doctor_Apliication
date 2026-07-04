import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_theme.dart';
import '../../utils/page_transitions.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
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

    // Mock registration delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    if (!mounted) return;

    setState(() => _isLoading = false);

    Navigator.of(context).pushAndRemoveUntil(
      PageTransitions.fadeTransition(const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingXL),
                const Text(
                  'Buat Akun Baru',
                  style: AppTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  'Bergabung dan mulai rawat tanamanmu',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                AppTextField(
                  label: 'Nama Lengkap',
                  controller: _nameController,
                  validator: Validators.name,
                  prefixIcon: Icons.person_rounded,
                ),
                const SizedBox(height: AppTheme.spacingM),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_rounded,
                ),
                const SizedBox(height: AppTheme.spacingM),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  validator: Validators.password,
                  isPasswordField: true,
                  prefixIcon: Icons.lock_rounded,
                ),
                const SizedBox(height: AppTheme.spacingM),
                AppTextField(
                  label: 'Konfirmasi Password',
                  controller: _confirmPasswordController,
                  validator: Validators.confirmPassword(_passwordController),
                  isPasswordField: true,
                  prefixIcon: Icons.lock_outline_rounded,
                ),
                const SizedBox(height: AppTheme.spacingXL),
                AppButton(
                  label: 'Daftar',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppTheme.spacingL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
