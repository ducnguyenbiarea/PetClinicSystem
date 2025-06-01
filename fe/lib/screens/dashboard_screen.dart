import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return CupertinoPageScaffold(
          backgroundColor: const Color(AppConstants.systemGray6),
          child: Row(
            children: [
              // Sidebar Navigation
              const SidebarNavigation(),
              
              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Header
                    Container(
                      height: AppConstants.headerHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      decoration: const BoxDecoration(
                        color: CupertinoColors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Color(AppConstants.systemGray4),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Welcome, ${authProvider.currentUser?.userName ?? 'User'}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(AppConstants.secondaryLabelColor),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(AppConstants.primaryBlue),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              authProvider.currentUserRole ?? 'USER',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Dashboard Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: AppConstants.maxWebWidth,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Quick Stats
                              _buildQuickStats(authProvider),
                              const SizedBox(height: 32),
                              
                              // Quick Actions
                              _buildQuickActions(context, authProvider),
                              const SizedBox(height: 32),
                              
                              // Recent Activity (placeholder)
                              _buildRecentActivity(),
                            ],
                          ),
                        ),
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

  Widget _buildQuickStats(AuthProvider authProvider) {
    final List<Map<String, dynamic>> stats = [];
    
    if (authProvider.isOwner) {
      stats.addAll([
        {
          'title': 'My Pets',
          'value': '3',
          'icon': CupertinoIcons.heart_fill,
          'color': AppConstants.systemRed,
        },
        {
          'title': 'Active Bookings',
          'value': '2',
          'icon': CupertinoIcons.calendar,
          'color': AppConstants.primaryBlue,
        },
      ]);
    }
    
    if (authProvider.canManageBookings) {
      stats.addAll([
        {
          'title': 'Total Bookings',
          'value': '24',
          'icon': CupertinoIcons.calendar,
          'color': AppConstants.primaryBlue,
        },
        {
          'title': 'Pending Bookings',
          'value': '5',
          'icon': CupertinoIcons.clock,
          'color': AppConstants.systemOrange,
        },
      ]);
    }
    
    if (authProvider.canManageMedicalRecords) {
      stats.addAll([
        {
          'title': 'Medical Records',
          'value': '18',
          'icon': CupertinoIcons.doc_text,
          'color': AppConstants.systemGreen,
        },
      ]);
    }
    
    if (authProvider.canManageUsers) {
      stats.addAll([
        {
          'title': 'Total Users',
          'value': '42',
          'icon': CupertinoIcons.person_2,
          'color': AppConstants.systemGray,
        },
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.labelColor),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: stats.map((stat) => DashboardCard(
            title: stat['title'],
            value: stat['value'],
            icon: stat['icon'],
            color: Color(stat['color']),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, AuthProvider authProvider) {
    final List<Map<String, dynamic>> actions = [];
    
    if (authProvider.isOwner) {
      actions.addAll([
        {
          'title': 'Book Service',
          'subtitle': 'Schedule an appointment',
          'icon': CupertinoIcons.add_circled,
          'route': '/bookings',
        },
        {
          'title': 'My Pets',
          'subtitle': 'Manage your pets',
          'icon': CupertinoIcons.heart,
          'route': '/pets',
        },
      ]);
    }
    
    if (authProvider.canManageBookings) {
      actions.add({
        'title': 'Manage Bookings',
        'subtitle': 'View and update bookings',
        'icon': CupertinoIcons.calendar,
        'route': '/bookings',
      });
    }
    
    if (authProvider.canManageMedicalRecords) {
      actions.add({
        'title': 'Medical Records',
        'subtitle': 'View and create records',
        'icon': CupertinoIcons.doc_text,
        'route': '/medical-records',
      });
    }
    
    if (authProvider.canManageUsers) {
      actions.add({
        'title': 'User Management',
        'subtitle': 'Manage system users',
        'icon': CupertinoIcons.person_2,
        'route': '/users',
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.labelColor),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: actions.map((action) => _buildActionCard(
            context,
            action['title'],
            action['subtitle'],
            action['icon'],
            action['route'],
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => context.go(route),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: const Color(AppConstants.primaryBlue),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.labelColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.labelColor),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'No recent activity',
              style: TextStyle(
                fontSize: 16,
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 