import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool isPasswordField;
  final TextInputType keyboardType;
  final IconData? prefixIcon;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.isPasswordField = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField || widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon:
            widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
