import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          width: AppConstants.sidebarWidth,
          decoration: const BoxDecoration(
            color: CupertinoColors.white,
            border: Border(
              right: BorderSide(
                color: Color(AppConstants.systemGray4),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // Logo and App Name
              Container(
                height: AppConstants.headerHeight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(AppConstants.primaryBlue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        CupertinoIcons.heart_fill,
                        size: 24,
                        color: CupertinoColors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Pet Clinic',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(AppConstants.labelColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Navigation Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    _buildNavItem(
                      context,
                      'Dashboard',
                      CupertinoIcons.house_fill,
                      '/dashboard',
                      true, // Always visible
                    ),
                    
                    if (authProvider.isOwner) ...[
                      _buildNavItem(
                        context,
                        'My Pets',
                        CupertinoIcons.heart,
                        '/my-pets',
                        true,
                      ),
                      _buildNavItem(
                        context,
                        'My Bookings',
                        CupertinoIcons.calendar,
                        '/my-bookings',
                        true,
                      ),
                    ],
                    
                    if (authProvider.isOwner)
                      _buildNavItem(
                        context,
                        'Services',
                        CupertinoIcons.star,
                        '/services',
                        true,
                      ),
                    
                    if (authProvider.canManageBookings) ...[
                      const SizedBox(height: 16),
                      _buildSectionHeader('Management'),
                      _buildNavItem(
                        context,
                        'All Bookings',
                        CupertinoIcons.calendar,
                        '/bookings',
                        true,
                      ),
                    ],
                    
                    if (authProvider.canManageCages)
                      _buildNavItem(
                        context,
                        'Cages',
                        CupertinoIcons.building_2_fill,
                        '/cages',
                        true,
                      ),
                    
                    if (authProvider.canManageMedicalRecords)
                      _buildNavItem(
                        context,
                        'Medical Records',
                        CupertinoIcons.doc_text,
                        '/medical-records',
                        true,
                      ),
                    
                    if (authProvider.canManageUsers) ...[
                      const SizedBox(height: 16),
                      _buildSectionHeader('Administration'),
                      _buildNavItem(
                        context,
                        'Users',
                        CupertinoIcons.person_2,
                        '/users',
                        true,
                      ),
                      if (authProvider.canManageServices)
                        _buildNavItem(
                          context,
                          'Manage Services',
                          CupertinoIcons.star_circle,
                          '/services',
                          true,
                        ),
                    ],
                  ],
                ),
              ),
              
              // User Profile and Logout
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(AppConstants.systemGray4),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildNavItem(
                      context,
                      'Profile',
                      CupertinoIcons.person_circle,
                      '/profile',
                      true,
                    ),
                    const SizedBox(height: 8),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      onPressed: () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.square_arrow_left,
                            size: 20,
                            color: Color(AppConstants.systemRed),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(AppConstants.systemRed),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.systemGray),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    IconData icon,
    String route,
    bool isVisible,
  ) {
    if (!isVisible) return const SizedBox.shrink();

    final currentRoute = GoRouterState.of(context).matchedLocation;
    final isActive = currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isActive ? const Color(AppConstants.primaryBlue).withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(12),
        onPressed: () => context.go(route),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? const Color(AppConstants.primaryBlue)
                  : const Color(AppConstants.systemGray),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? const Color(AppConstants.primaryBlue)
                      : const Color(AppConstants.labelColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 