import 'package:flutter/cupertino.dart';
import '../constants/app_constants.dart';

class CupertinoPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Color? color;
  final double? minSize;
  final EdgeInsetsGeometry? padding;

  const CupertinoPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.color,
    this.minSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: isLoading ? null : onPressed,
      color: color ?? const Color(AppConstants.primaryBlue),
      borderRadius: BorderRadius.circular(12),
      minimumSize: Size.fromHeight(minSize ?? 50),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: isLoading
          ? const CupertinoActivityIndicator(
              color: CupertinoColors.white,
              radius: 12,
            )
          : DefaultTextStyle(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.white,
              ),
              child: child,
            ),
    );
  }
}

class CupertinoSecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Color? borderColor;
  final Color? textColor;
  final double? minSize;
  final EdgeInsetsGeometry? padding;

  const CupertinoSecondaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.borderColor,
    this.textColor,
    this.minSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? const Color(AppConstants.systemGray3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CupertinoButton(
        onPressed: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        minimumSize: Size.fromHeight(minSize ?? 50),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: isLoading
            ? CupertinoActivityIndicator(
                color: textColor ?? const Color(AppConstants.primaryBlue),
                radius: 12,
              )
            : DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? const Color(AppConstants.primaryBlue),
                ),
                child: child,
              ),
      ),
    );
  }
}

class CupertinoDestructiveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final double? minSize;
  final EdgeInsetsGeometry? padding;

  const CupertinoDestructiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.minSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: isLoading ? null : onPressed,
      color: const Color(AppConstants.systemRed),
      borderRadius: BorderRadius.circular(12),
      minimumSize: Size.fromHeight(minSize ?? 50),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: isLoading
          ? const CupertinoActivityIndicator(
              color: CupertinoColors.white,
              radius: 12,
            )
          : DefaultTextStyle(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.white,
              ),
              child: child,
            ),
    );
  }
} 