import 'package:flutter/cupertino.dart';
import '../constants/app_constants.dart';

class CupertinoFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;

  const CupertinoFormField({
    super.key,
    this.controller,
    this.placeholder,
    this.obscureText = false,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: enabled 
                    ? CupertinoColors.white 
                    : const Color(AppConstants.systemGray6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: field.hasError
                      ? const Color(AppConstants.systemRed)
                      : const Color(AppConstants.systemGray4),
                  width: 1,
                ),
              ),
              child: CupertinoTextField(
                controller: controller,
                placeholder: placeholder,
                obscureText: obscureText,
                keyboardType: keyboardType,
                maxLines: maxLines,
                enabled: enabled,
                onChanged: (value) {
                  field.didChange(value);
                  onChanged?.call(value);
                },
                decoration: const BoxDecoration(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefix: prefix != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: prefix,
                      )
                    : null,
                suffix: suffix != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: suffix,
                      )
                    : null,
                style: TextStyle(
                  fontSize: 16,
                  color: enabled
                      ? const Color(AppConstants.labelColor)
                      : const Color(AppConstants.systemGray),
                ),
                placeholderStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(AppConstants.systemGray),
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(AppConstants.systemRed),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
} 