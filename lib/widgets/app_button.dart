import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// Variant sesuai Design.md.md:
/// • [primary]   → button-primary: background kuning tertiary (#FCCC62), teks gelap
/// • [secondary] → button-secondary: background hijau primary (#0B3D33), teks putih
/// • [outlined]  → border primary, teks primary, background transparan
enum AppButtonVariant { primary, secondary, outlined }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final double? width;
  final IconData? leadingIcon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = width ?? double.infinity;

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary
                    ? AppTheme.onSurfaceColor
                    : AppTheme.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 20),
                const SizedBox(width: AppTheme.spacingXS),
              ],
              Text(label),
            ],
          );

    // button-primary: kuning (#FCCC62) + teks gelap
    if (variant == AppButtonVariant.primary) {
      return SizedBox(
        width: buttonWidth,
        height: 48,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.tertiaryColor,
            foregroundColor: AppTheme.onSurfaceColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            textStyle: AppTheme.labelLarge.copyWith(
              fontFamily: AppTheme.fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: child,
        ),
      );
    }

    // button-secondary: hijau tua (#0B3D33) + teks putih
    if (variant == AppButtonVariant.secondary) {
      return SizedBox(
        width: buttonWidth,
        height: 48,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: AppTheme.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            textStyle: AppTheme.labelLarge.copyWith(
              fontFamily: AppTheme.fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: child,
        ),
      );
    }

    // outlined
    return SizedBox(
      width: buttonWidth,
      height: 48,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryColor,
          side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          textStyle: AppTheme.labelLarge.copyWith(
            fontFamily: AppTheme.fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: child,
      ),
    );
  }
}
