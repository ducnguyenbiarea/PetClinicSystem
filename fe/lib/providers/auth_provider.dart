import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _authService.isLoggedIn;
  User? get currentUser => _authService.currentUser;
  String? get currentUserRole => _authService.currentUserRole;
  
  // Role-based access getters
  bool get isAdmin => _authService.isAdmin;
  bool get isStaff => _authService.isStaff;
  bool get isDoctor => _authService.isDoctor;
  bool get isOwner => _authService.isOwner;
  bool get canManageUsers => _authService.canManageUsers;
  bool get canManageServices => _authService.canManageServices;
  bool get canManageBookings => _authService.canManageBookings;
  bool get canManageMedicalRecords => _authService.canManageMedicalRecords;
  bool get canManageCages => _authService.canManageCages;

  // Initialize authentication state
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _authService.initialize();
      _clearError();
    } catch (e) {
      _setError('Failed to initialize authentication: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.login(email, password);
      
      if (result.success) {
        _clearError();
        notifyListeners();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Login failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<bool> register(UserRegistration registration) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.register(registration);
      
      if (result.success) {
        _clearError();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh user info
  Future<void> refreshUserInfo() async {
    _setLoading(true);
    try {
      await _authService.getCurrentUserInfo();
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to refresh user info: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update user info
  Future<bool> updateUserInfo(UserUpdate userUpdate) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.updateUserInfo(userUpdate);
      
      if (success) {
        _clearError();
        notifyListeners();
        return true;
      } else {
        _setError('Failed to update user information');
        return false;
      }
    } catch (e) {
      _setError('Update failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Check if user has specific role
  bool hasRole(String role) {
    return _authService.hasRole(role);
  }

  // Clear error message
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 