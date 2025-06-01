import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  User? _currentUser;
  String? _currentUserRole;

  User? get currentUser => _currentUser;
  String? get currentUserRole => _currentUserRole;
  bool get isLoggedIn => _currentUser != null;

  // Initialize auth state from storage
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
      
      if (isLoggedIn) {
        final userInfoJson = prefs.getString(AppConstants.keyUserInfo);
        final userRole = prefs.getString(AppConstants.keyUserRole);
        
        if (userInfoJson != null) {
          final userMap = json.decode(userInfoJson);
          _currentUser = User.fromJson(userMap);
          _currentUserRole = userRole ?? _currentUser?.roles;
        }
      }
    } catch (e) {
      // If there's an error loading from storage, clear everything
      await clearSession();
    }
  }

  // Login with email and password
  Future<LoginResult> login(String email, String password) async {
    try {
      final response = await _apiService.postForm(
        AppConstants.authLogin,
        {
          'username': email,
          'password': password,
        },
      );

      if (response['message'] == 'Login successful') {
        // Get user info after successful login
        final userInfo = await _apiService.get(AppConstants.userMyInfo);
        _currentUser = User.fromJson(userInfo);
        _currentUserRole = _currentUser?.roles;

        // Save to storage
        await _saveSession();

        return LoginResult(
          success: true,
          user: _currentUser,
          message: response['message'],
        );
      } else {
        return LoginResult(
          success: false,
          message: response['message'] ?? 'Login failed',
        );
      }
    } on ApiException catch (e) {
      return LoginResult(
        success: false,
        message: e.message,
      );
    } catch (e) {
      return LoginResult(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Register new user
  Future<RegisterResult> register(UserRegistration registration) async {
    try {
      final response = await _apiService.post(
        AppConstants.authRegister,
        body: registration.toJson(),
      );

      final user = User.fromJson(response);
      return RegisterResult(
        success: true,
        user: user,
        message: 'Registration successful',
      );
    } on ApiException catch (e) {
      return RegisterResult(
        success: false,
        message: e.message,
      );
    } catch (e) {
      return RegisterResult(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post(AppConstants.authLogout);
    } catch (e) {
      // Even if logout fails on server, clear local session
    } finally {
      // Clear cookies from API service
      _apiService.clearCookies();
      await clearSession();
    }
  }

  // Get current user info from server
  Future<User?> getCurrentUserInfo() async {
    try {
      final response = await _apiService.get(AppConstants.userMyInfo);
      _currentUser = User.fromJson(response);
      _currentUserRole = _currentUser?.roles;
      await _saveSession();
      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  // Check if user has specific role
  bool hasRole(String role) {
    if (_currentUserRole == null) {
      return false;
    }
    final result = _currentUserRole!.contains(role);
    return result;
  }

  // Check if user is admin
  bool get isAdmin => hasRole(AppConstants.roleAdmin);

  // Check if user is staff
  bool get isStaff => hasRole(AppConstants.roleStaff);

  // Check if user is doctor
  bool get isDoctor => hasRole(AppConstants.roleDoctor);

  // Check if user is owner
  bool get isOwner => hasRole(AppConstants.roleOwner);

  // Check if user can manage users (admin only)
  bool get canManageUsers => isAdmin;

  // Check if user can manage services (admin only)
  bool get canManageServices => isAdmin;

  // Check if user can manage bookings (admin or staff)
  bool get canManageBookings => isAdmin || isStaff;

  // Check if user can manage medical records (admin, staff, or doctor)
  bool get canManageMedicalRecords => isAdmin || isStaff || isDoctor;

  // Check if user can manage cages (admin or staff)
  bool get canManageCages => isAdmin || isStaff;

  // Save session to storage
  Future<void> _saveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsLoggedIn, true);
      
      if (_currentUser != null) {
        await prefs.setString(
          AppConstants.keyUserInfo,
          json.encode(_currentUser!.toJson()),
        );
      }
      
      if (_currentUserRole != null) {
        await prefs.setString(AppConstants.keyUserRole, _currentUserRole!);
      }
    } catch (e) {
      // Handle storage error
    }
  }

  // Clear session from storage
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyIsLoggedIn);
      await prefs.remove(AppConstants.keyUserInfo);
      await prefs.remove(AppConstants.keyUserRole);
      
      _currentUser = null;
      _currentUserRole = null;
    } catch (e) {
      // Handle storage error
    }
  }

  // Update current user info
  Future<bool> updateUserInfo(UserUpdate userUpdate) async {
    try {
      if (_currentUser == null) return false;
      
      final response = await _apiService.put(
        '${AppConstants.users}/${_currentUser!.id}',
        body: userUpdate.toJson(),
      );
      
      _currentUser = User.fromJson(response);
      await _saveSession();
      return true;
    } catch (e) {
      return false;
    }
  }
}

class LoginResult {
  final bool success;
  final User? user;
  final String message;

  LoginResult({
    required this.success,
    this.user,
    required this.message,
  });
}

class RegisterResult {
  final bool success;
  final User? user;
  final String message;

  RegisterResult({
    required this.success,
    this.user,
    required this.message,
  });
} 