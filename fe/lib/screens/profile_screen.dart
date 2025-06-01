import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/cupertino_form_field.dart';
import '../widgets/cupertino_button_primary.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    if (user != null) {
      _nameController.text = user.userName;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final userUpdate = UserUpdate(
        userName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      final success = await authProvider.updateUserInfo(userUpdate);

      setState(() {
        _isLoading = false;
      });

      if (success && mounted) {
        setState(() {
          _isEditing = false;
        });
        
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Success'),
            content: const Text('Your profile has been updated successfully.'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text(authProvider.errorMessage ?? 'Failed to update profile.'),
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
  }

  void _handleCancel() {
    setState(() {
      _isEditing = false;
    });
    _loadUserData(); // Reset form data
  }

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
                            'My Profile',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Spacer(),
                          if (!_isEditing)
                            CupertinoButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.pencil,
                                    size: 16,
                                    color: Color(AppConstants.primaryBlue),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Edit',
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
                    
                    // Profile Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 600,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Card
                              Container(
                                padding: const EdgeInsets.all(32),
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
                                    // Profile Header
                                    Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: const Color(AppConstants.primaryBlue),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Icon(
                                            CupertinoIcons.person_fill,
                                            size: 40,
                                            color: CupertinoColors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                authProvider.currentUser?.userName ?? 'User',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(AppConstants.labelColor),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
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
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    
                                    // Profile Form
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            'Personal Information',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Color(AppConstants.labelColor),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          
                                          CupertinoFormField(
                                            controller: _nameController,
                                            placeholder: 'Full Name',
                                            enabled: _isEditing,
                                            prefix: const Icon(
                                              CupertinoIcons.person,
                                              color: Color(AppConstants.systemGray),
                                            ),
                                            validator: (value) {
                                              if (value?.isEmpty ?? true) {
                                                return 'Please enter your full name';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          CupertinoFormField(
                                            controller: _emailController,
                                            placeholder: 'Email',
                                            enabled: _isEditing,
                                            keyboardType: TextInputType.emailAddress,
                                            prefix: const Icon(
                                              CupertinoIcons.mail,
                                              color: Color(AppConstants.systemGray),
                                            ),
                                            validator: (value) {
                                              if (value?.isEmpty ?? true) {
                                                return 'Please enter your email';
                                              }
                                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                  .hasMatch(value!)) {
                                                return 'Please enter a valid email';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          CupertinoFormField(
                                            controller: _phoneController,
                                            placeholder: 'Phone Number',
                                            enabled: _isEditing,
                                            keyboardType: TextInputType.phone,
                                            prefix: const Icon(
                                              CupertinoIcons.phone,
                                              color: Color(AppConstants.systemGray),
                                            ),
                                            validator: (value) {
                                              if (value?.isEmpty ?? true) {
                                                return 'Please enter your phone number';
                                              }
                                              return null;
                                            },
                                          ),
                                          
                                          if (_isEditing) ...[
                                            const SizedBox(height: 32),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: CupertinoSecondaryButton(
                                                    onPressed: _isLoading ? null : _handleCancel,
                                                    child: const Text('Cancel'),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: CupertinoPrimaryButton(
                                                    onPressed: _isLoading ? null : _handleSave,
                                                    isLoading: _isLoading,
                                                    child: const Text('Save Changes'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
} 