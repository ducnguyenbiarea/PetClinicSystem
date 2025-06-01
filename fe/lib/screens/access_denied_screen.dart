import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../widgets/cupertino_button_primary.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(AppConstants.systemGray6),
      child: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            margin: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(AppConstants.systemRed).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    CupertinoIcons.lock_shield,
                    size: 60,
                    color: Color(AppConstants.systemRed),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Title
                const Text(
                  'Access Denied',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(AppConstants.labelColor),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Message
                const Text(
                  "You don't have permission to access this resource.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(AppConstants.secondaryLabelColor),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                const Text(
                  'Please contact your administrator if you believe this is an error.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(AppConstants.tertiaryLabelColor),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Action Buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CupertinoPrimaryButton(
                      onPressed: () => context.go('/dashboard'),
                      child: const Text('Go to Dashboard'),
                    ),
                    const SizedBox(height: 16),
                    CupertinoSecondaryButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 