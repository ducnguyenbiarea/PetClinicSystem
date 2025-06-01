class AppConstants {
  // API Base URL
  static const String baseUrl = 'http://localhost:8080';
  
  // API Endpoints
  static const String authLogin = '/api/auth/login';
  static const String authRegister = '/api/auth/register';
  static const String authLogout = '/api/auth/logout';
  static const String authAccessDenied = '/api/auth/access-denied';
  
  static const String users = '/api/users';
  static const String userMyInfo = '/api/users/my-info';
  static const String userByEmail = '/api/users/email';
  static const String userRole = '/role';
  
  static const String pets = '/api/pets';
  static const String petsByUser = '/api/pets/user';
  static const String myPets = '/api/pets/my-pets';
  
  static const String services = '/api/services';
  
  static const String bookings = '/api/bookings';
  static const String bookingsByUser = '/api/bookings/user';
  static const String bookingsByService = '/api/bookings/service';
  static const String myBookings = '/api/bookings/my-bookings';
  static const String bookingStatus = '/status';
  static const String bookingCancel = '/cancel';
  
  static const String medicalRecords = '/api/records';
  static const String recordsByPet = '/api/records/pet';
  static const String recordsByUser = '/api/records/user';
  static const String myRecords = '/api/records/my-records';
  
  static const String cages = '/api/cages';
  static const String cagesByPet = '/api/cages/pet';
  static const String cagesByStatus = '/api/cages/status';
  static const String cagesFilter = '/api/cages/filter';
  
  // User Roles
  static const String roleOwner = 'OWNER';
  static const String roleStaff = 'STAFF';
  static const String roleDoctor = 'DOCTOR';
  static const String roleAdmin = 'ADMIN';
  
  // Booking Status
  static const String statusPending = 'PENDING';
  static const String statusConfirmed = 'CONFIRMED';
  static const String statusCompleted = 'COMPLETED';
  static const String statusCancelled = 'CANCELLED';
  
  // Pet Gender
  static const String genderMale = 'MALE';
  static const String genderFemale = 'FEMALE';
  
  // Cage Status
  static const String cageAvailable = 'AVAILABLE';
  static const String cageOccupied = 'OCCUPIED';
  static const String cageCleaning = 'CLEANING';
  static const String cageMaintenance = 'MAINTENANCE';
  
  // Cage Types
  static const String cageTypeDog = 'DOG';
  static const String cageTypeCat = 'CAT';
  
  // Cage Sizes
  static const String cageSizeSmall = 'Small';
  static const String cageSizeMedium = 'Medium';
  static const String cageSizeLarge = 'Large';
  
  // Service Categories
  static const String categoryHealth = 'Health';
  static const String categoryGrooming = 'Grooming';
  static const String categoryMedical = 'MEDICAL';
  
  // Storage Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserInfo = 'user_info';
  static const String keyUserRole = 'user_role';
  static const String keySessionCookie = 'session_cookie';
  
  // Default Account Credentials (for testing)
  static const Map<String, String> defaultAccounts = {
    'admin@example.com': 'admin123',
    'owner@example.com': 'owner123',
    'staff@example.com': 'staff123',
    'doctor@example.com': 'doctor123',
  };
  
  // UI Constants
  static const double maxWebWidth = 1200.0;
  static const double sidebarWidth = 280.0;
  static const double headerHeight = 80.0;
  
  // Colors (Cupertino-style)
  static const int primaryBlue = 0xFF007AFF;
  static const int systemGray = 0xFF8E8E93;
  static const int systemGray2 = 0xFFAEAEB2;
  static const int systemGray3 = 0xFFC7C7CC;
  static const int systemGray4 = 0xFFD1D1D6;
  static const int systemGray5 = 0xFFE5E5EA;
  static const int systemGray6 = 0xFFF2F2F7;
  static const int labelColor = 0xFF000000;
  static const int secondaryLabelColor = 0x993C3C43;
  static const int tertiaryLabelColor = 0x4C3C3C43;
  static const int quaternaryLabelColor = 0x2D3C3C43;
  static const int placeholderTextColor = 0x993C3C43;
  
  // Success/Error Colors
  static const int systemGreen = 0xFF34C759;
  static const int systemRed = 0xFFFF3B30;
  static const int systemOrange = 0xFFFF9500;
  static const int systemYellow = 0xFFFFCC00;
} 