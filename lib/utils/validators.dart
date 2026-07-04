import 'package:flutter/material.dart';

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong';
    if (value.trim().length < 2) return 'Nama minimal 2 karakter';
    return null;
  }

  static String? Function(String?) confirmPassword(
      TextEditingController passwordController) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Konfirmasi password tidak boleh kosong';
      }
      if (value != passwordController.text) return 'Password tidak cocok';
      return null;
    };
  }
}
