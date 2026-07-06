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
            SnackBar(content: Text(msg), backgroundColor: AppTheme.errorRed),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Koneksi bermasalah: $e'), backgroundColor: AppTheme.errorRed),
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
