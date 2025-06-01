import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/cupertino_form_field.dart';
import '../widgets/cupertino_button_primary.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ApiService _apiService = ApiService();
  List<User> _users = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedRole = 'All';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _apiService.get(AppConstants.users);
      
      if (response is List) {
        _users = response.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          final data = response['data'] as List;
          _users = data.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          _users = [User.fromJson(response)];
        }
      } else {
        _users = [];
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  List<User> get _filteredUsers {
    return _users.where((user) {
      final matchesSearch = user.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           user.phone.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole = _selectedRole == 'All' || user.roles.contains(_selectedRole);
      return matchesSearch && matchesRole;
    }).toList();
  }

  List<String> get _availableRoles {
    final roles = _users.expand((user) => user.roles.split(',')).map((role) => role.trim()).toSet().toList();
    roles.sort();
    return ['All', ...roles];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAdmin) {
          return const Center(
            child: Text(
              'Access Denied: Admin privileges required',
              style: TextStyle(
                fontSize: 18,
                color: Color(AppConstants.systemRed),
              ),
            ),
          );
        }

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
                            'User Management',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Spacer(),
                          CupertinoButton(
                            onPressed: () => _showAddUserDialog(context, authProvider),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.person_add,
                                  size: 16,
                                  color: Color(AppConstants.primaryBlue),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Add User',
                                  style: TextStyle(
                                    color: Color(AppConstants.primaryBlue),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          CupertinoButton(
                            onPressed: _loadUsers,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.refresh,
                                  size: 16,
                                  color: Color(AppConstants.primaryBlue),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Refresh',
                                  style: TextStyle(
                                    color: Color(AppConstants.primaryBlue),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Search and Filter Bar
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: CupertinoColors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Color(AppConstants.systemGray5),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Search Field
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(AppConstants.systemGray6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CupertinoTextField(
                                placeholder: 'Search users...',
                                prefix: const Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Icon(
                                    CupertinoIcons.search,
                                    color: Color(AppConstants.systemGray),
                                  ),
                                ),
                                decoration: const BoxDecoration(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Role Filter
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(AppConstants.systemGray6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => CupertinoActionSheet(
                                    title: const Text('Filter by Role'),
                                    actions: _availableRoles.map((role) {
                                      return CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            _selectedRole = role;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(role),
                                      );
                                    }).toList(),
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _selectedRole,
                                    style: const TextStyle(
                                      color: Color(AppConstants.labelColor),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 16,
                                    color: Color(AppConstants.systemGray),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Users Content
                    Expanded(
                      child: _buildContent(authProvider),
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

  Widget _buildContent(AuthProvider authProvider) {
    if (_isLoading) {
      return const Center(
        child: CupertinoActivityIndicator(radius: 20),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 64,
              color: Color(AppConstants.systemRed),
            ),
            const SizedBox(height: 16),
            const Text(
              'Error loading users',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.labelColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Color(AppConstants.secondaryLabelColor),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: _loadUsers,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final filteredUsers = _filteredUsers;

    if (filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.person_3,
              size: 64,
              color: Color(AppConstants.systemGray),
            ),
            const SizedBox(height: 16),
            const Text(
              'No users found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.labelColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : 'Add your first user to get started',
              style: const TextStyle(
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: () => _showAddUserDialog(context, authProvider),
                child: const Text('Add Your First User'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(32),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _UserCard(
          user: user,
          authProvider: authProvider,
          onEdit: () => _showEditUserDialog(context, authProvider, user),
          onDelete: () => _showDeleteUserDialog(context, user),
          onChangeRole: () => _showChangeRoleDialog(context, user),
        );
      },
    );
  }

  void _showAddUserDialog(BuildContext context, AuthProvider authProvider) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _UserFormDialog(
        authProvider: authProvider,
        onSave: (userCreate) async {
          try {
            await _apiService.post(AppConstants.users, body: userCreate.toJson());
            await _loadUsers();
            if (context.mounted) {
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'User added successfully!');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, 'Failed to add user: $e');
            }
          }
        },
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, AuthProvider authProvider, User user) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _UserFormDialog(
        authProvider: authProvider,
        user: user,
        onSave: (userUpdate) async {
          try {
            await _apiService.put('${AppConstants.users}/${user.id}', body: userUpdate.toJson());
            await _loadUsers();
            if (context.mounted) {
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'User updated successfully!');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, 'Failed to update user: $e');
            }
          }
        },
      ),
    );
  }

  void _showChangeRoleDialog(BuildContext context, User user) {
    final roles = ['OWNER', 'STAFF', 'DOCTOR', 'ADMIN'];
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Change Role for ${user.userName}'),
        message: Text('Current role: ${user.roles}'),
        actions: roles.map((role) {
          return CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _apiService.patchWithQuery(
                  '${AppConstants.users}/${user.id}/role',
                  {'newRole': role.toLowerCase()},
                );
                await _loadUsers();
                if (context.mounted) {
                  _showSuccessDialog(context, 'User role updated successfully!');
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorDialog(context, 'Failed to update role: $e');
                }
              }
            },
            child: Text(role),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showDeleteUserDialog(BuildContext context, User user) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.userName}? This action cannot be undone.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await _apiService.delete('${AppConstants.users}/${user.id}');
                await _loadUsers();
                if (context.mounted) {
                  _showSuccessDialog(context, 'User deleted successfully!');
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorDialog(context, 'Failed to delete user: $e');
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;
  final AuthProvider authProvider;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onChangeRole;

  const _UserCard({
    required this.user,
    required this.authProvider,
    required this.onEdit,
    required this.onDelete,
    required this.onChangeRole,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.roles).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getRoleIcon(user.roles),
                    color: _getRoleColor(user.roles),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(AppConstants.labelColor),
                              ),
                            ),
                          ),
                          _buildRoleBadge(user.roles),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(AppConstants.secondaryLabelColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // User Details
            Row(
              children: [
                const Icon(
                  CupertinoIcons.phone,
                  size: 16,
                  color: Color(AppConstants.systemGray),
                ),
                const SizedBox(width: 8),
                Text(
                  user.phone,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(AppConstants.labelColor),
                  ),
                ),
                const SizedBox(width: 24),
                const Icon(
                  CupertinoIcons.person_badge_plus,
                  size: 16,
                  color: Color(AppConstants.systemGray),
                ),
                const SizedBox(width: 8),
                Text(
                  'ID: ${user.id}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(AppConstants.systemGray),
                  ),
                ),
              ],
            ),
            
            // Actions
            const SizedBox(height: 16),
            Row(
              children: [
                CupertinoSecondaryButton(
                  onPressed: onEdit,
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 12),
                CupertinoSecondaryButton(
                  onPressed: onChangeRole,
                  child: const Text('Change Role'),
                ),
                const SizedBox(width: 12),
                if (user.id != authProvider.currentUser?.id) // Don't allow deleting self
                  CupertinoDestructiveButton(
                    onPressed: onDelete,
                    child: const Text('Delete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String roles) {
    final color = _getRoleColor(roles);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        roles.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getRoleColor(String roles) {
    if (roles.contains('ADMIN')) {
      return const Color(AppConstants.systemRed);
    } else if (roles.contains('DOCTOR')) {
      return const Color(0xFF34C759); // Green
    } else if (roles.contains('STAFF')) {
      return const Color(0xFFFF9500); // Orange
    } else if (roles.contains('OWNER')) {
      return const Color(AppConstants.primaryBlue);
    } else {
      return const Color(AppConstants.systemGray);
    }
  }

  IconData _getRoleIcon(String roles) {
    if (roles.contains('ADMIN')) {
      return CupertinoIcons.shield_fill;
    } else if (roles.contains('DOCTOR')) {
      return CupertinoIcons.heart_fill;
    } else if (roles.contains('STAFF')) {
      return CupertinoIcons.person_badge_plus;
    } else if (roles.contains('OWNER')) {
      return CupertinoIcons.person_fill;
    } else {
      return CupertinoIcons.person;
    }
  }
}

class _UserFormDialog extends StatefulWidget {
  final AuthProvider authProvider;
  final User? user;
  final Function(dynamic) onSave;

  const _UserFormDialog({
    required this.authProvider,
    this.user,
    required this.onSave,
  });

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _selectedRole = 'OWNER';
  bool _isLoading = false;

  final List<String> _roles = ['OWNER', 'STAFF', 'DOCTOR', 'ADMIN'];

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.userName;
      _emailController.text = widget.user!.email;
      _phoneController.text = widget.user!.phone;
      _selectedRole = widget.user!.roles.split(',').first.trim();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(AppConstants.systemGray6),
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.user == null ? 'Add User' : 'Edit User'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : _saveUser,
          child: _isLoading
              ? const CupertinoActivityIndicator()
              : const Text('Save'),
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoFormField(
                    controller: _nameController,
                    placeholder: 'Enter full name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoFormField(
                    controller: _emailController,
                    placeholder: 'Enter email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Phone
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoFormField(
                    controller: _phoneController,
                    placeholder: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Password (only for new users)
              if (widget.user == null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(AppConstants.labelColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CupertinoFormField(
                      controller: _passwordController,
                      placeholder: 'Enter password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              
              // Role Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Role',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(AppConstants.systemGray4),
                      ),
                    ),
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: const Text('Select Role'),
                            actions: _roles.map((role) {
                              return CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() {
                                    _selectedRole = role;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(role),
                              );
                            }).toList(),
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedRole,
                            style: const TextStyle(
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.chevron_down,
                            color: Color(AppConstants.systemGray),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.user == null) {
        // Create new user
        final userCreate = UserCreate(
          userName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text.trim(),
          roles: _selectedRole,
        );
        await widget.onSave(userCreate);
      } else {
        // Update existing user
        final userUpdate = UserUpdate(
          userName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
        );
        await widget.onSave(userUpdate);
      }
    } catch (e) {
      // Error handling is done in the parent
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class UserCreate {
  final String userName;
  final String email;
  final String phone;
  final String password;
  final String roles;

  UserCreate({
    required this.userName,
    required this.email,
    required this.phone,
    required this.password,
    required this.roles,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'email': email,
      'phone': phone,
      'password': password,
      'roles': roles,
    };
  }
}

class UserUpdate {
  final String userName;
  final String email;
  final String phone;

  UserUpdate({
    required this.userName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'email': email,
      'phone': phone,
    };
  }
} 