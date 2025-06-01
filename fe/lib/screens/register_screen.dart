import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../widgets/cupertino_form_field.dart';
import '../widgets/cupertino_button_primary.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final registration = UserRegistration(
        userName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      final success = await authProvider.register(registration);

      if (success && mounted) {
        // Show success message and redirect to login
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Registration Successful'),
            content: const Text('Your account has been created successfully. Please sign in to continue.'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/login');
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(AppConstants.systemGray6),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              margin: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and Title
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(AppConstants.primaryBlue),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      CupertinoIcons.heart_fill,
                      size: 60,
                      color: CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Join our pet clinic community',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(AppConstants.secondaryLabelColor),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Registration Form
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CupertinoFormField(
                            controller: _nameController,
                            placeholder: 'Full Name',
                            prefix: const Icon(
                              CupertinoIcons.person,
                              color: Color(AppConstants.systemGray),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your full name';
                              }
                              if (value!.length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          CupertinoFormField(
                            controller: _emailController,
                            placeholder: 'Email',
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
                            keyboardType: TextInputType.phone,
                            prefix: const Icon(
                              CupertinoIcons.phone,
                              color: Color(AppConstants.systemGray),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your phone number';
                              }
                              if (value!.length < 10) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          CupertinoFormField(
                            controller: _passwordController,
                            placeholder: 'Password',
                            obscureText: _obscurePassword,
                            prefix: const Icon(
                              CupertinoIcons.lock,
                              color: Color(AppConstants.systemGray),
                            ),
                            suffix: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: Icon(
                                _obscurePassword
                                    ? CupertinoIcons.eye
                                    : CupertinoIcons.eye_slash,
                                color: const Color(AppConstants.systemGray),
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter a password';
                              }
                              if (value!.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          CupertinoFormField(
                            controller: _confirmPasswordController,
                            placeholder: 'Confirm Password',
                            obscureText: _obscureConfirmPassword,
                            prefix: const Icon(
                              CupertinoIcons.lock,
                              color: Color(AppConstants.systemGray),
                            ),
                            suffix: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                              child: Icon(
                                _obscureConfirmPassword
                                    ? CupertinoIcons.eye
                                    : CupertinoIcons.eye_slash,
                                color: const Color(AppConstants.systemGray),
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (authProvider.errorMessage != null)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: const Color(AppConstants.systemRed)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(AppConstants.systemRed),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        authProvider.errorMessage!,
                                        style: const TextStyle(
                                          color: Color(AppConstants.systemRed),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                  CupertinoPrimaryButton(
                                    onPressed: authProvider.isLoading ? null : _handleRegister,
                                    isLoading: authProvider.isLoading,
                                    child: const Text('Create Account'),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Color(AppConstants.secondaryLabelColor),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.go('/login'),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Color(AppConstants.primaryBlue),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 