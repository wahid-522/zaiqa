import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

enum ZaiqaButtonType { primary, secondary, outline }

class ZaiqaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ZaiqaButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const ZaiqaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ZaiqaButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (type) {
      case ZaiqaButtonType.primary:
        bg = AppColors.primary;
        fg = Colors.white;
        break;
      case ZaiqaButtonType.secondary:
        bg = AppColors.primaryLight;
        fg = AppColors.primaryDark;
        break;
      case ZaiqaButtonType.outline:
        bg = Colors.transparent;
        fg = AppColors.primary;
        border = const BorderSide(color: AppColors.primary, width: 1.5);
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: type == ZaiqaButtonType.primary ? 2 : 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            side: border,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
