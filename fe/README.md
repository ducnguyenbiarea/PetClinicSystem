# Pet Clinic System - Flutter Web Frontend

A modern, responsive web application for managing a pet clinic system built with Flutter Web and Cupertino design system.

## Features

### ✅ Implemented Screens
- **Login Screen** - User authentication with demo account buttons
- **Registration Screen** - New user registration for pet owners
- **Dashboard Screen** - Role-based landing page with quick stats and navigation
- **Profile Screen** - View and edit user profile information
- **Services Screen** - Browse available clinic services with search and filtering

### 🚧 Placeholder Screens (Coming Soon)
- **My Pets** - Pet management for owners
- **My Bookings** - Booking management
- **Medical Records** - Medical history and records
- **User Management** - Admin-only user management
- **Cage Management** - Staff/Admin cage management

## Architecture

### Design System
- **Cupertino Design** - Apple-like UI components and styling
- **Responsive Layout** - Optimized for desktop/web browsers
- **Role-based UI** - Different interfaces based on user permissions

### State Management
- **Provider Pattern** - For authentication and app state
- **AuthProvider** - Centralized authentication management

### Navigation
- **GoRouter** - Declarative routing with authentication guards
- **Sidebar Navigation** - Role-based menu items

### API Integration
- **HTTP Client** - RESTful API communication
- **Cookie-based Sessions** - Browser session management
- **Error Handling** - Comprehensive error handling and user feedback

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Chrome browser for web testing
- Backend API running on `localhost:8080`

### Installation

1. **Navigate to frontend directory:**
   ```bash
   cd fe
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run -d chrome --web-port=3000
   ```

4. **Access the application:**
   Open your browser to `http://localhost:3000`

## Testing the Application

### Demo Accounts
The login screen provides quick access to demo accounts:

- **Admin Account:**
  - Email: `admin@example.com`
  - Password: `admin123`
  - Access: Full system access

- **Owner Account:**
  - Email: `owner@example.com`
  - Password: `owner123`
  - Access: Pet and booking management

- **Staff Account:**
  - Email: `staff@example.com`
  - Password: `staff123`
  - Access: Clinic operations

- **Doctor Account:**
  - Email: `doctor@example.com`
  - Password: `doctor123`
  - Access: Medical records and patient care

### Testing Flow

1. **Start with Login:**
   - Use demo account buttons for quick access
   - Test form validation with invalid inputs

2. **Explore Dashboard:**
   - Notice role-based content differences
   - Check sidebar navigation permissions

3. **Test Navigation:**
   - Use sidebar to navigate between screens
   - Verify role-based menu visibility

4. **Profile Management:**
   - Edit profile information
   - Test form validation and save functionality

5. **Services Browsing:**
   - Search and filter services
   - Test responsive grid layout

6. **Registration:**
   - Test new user registration flow
   - Verify form validation

## Project Structure

```
fe/
├── lib/
│   ├── constants/
│   │   └── app_constants.dart      # API endpoints, colors, roles
│   ├── models/                     # Data models
│   │   ├── user.dart
│   │   ├── pet.dart
│   │   ├── service.dart
│   │   ├── booking.dart
│   │   ├── medical_record.dart
│   │   └── cage.dart
│   ├── providers/
│   │   └── auth_provider.dart      # Authentication state management
│   ├── screens/                    # Application screens
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── services_screen.dart
│   │   ├── pets_screen.dart
│   │   ├── bookings_screen.dart
│   │   ├── medical_records_screen.dart
│   │   ├── users_screen.dart
│   │   ├── cages_screen.dart
│   │   └── access_denied_screen.dart
│   ├── services/
│   │   ├── api_service.dart        # HTTP client and API communication
│   │   └── auth_service.dart       # Authentication logic
│   ├── widgets/                    # Reusable UI components
│   │   ├── cupertino_form_field.dart
│   │   ├── cupertino_button_primary.dart
│   │   ├── sidebar_navigation.dart
│   │   └── dashboard_card.dart
│   └── main.dart                   # App entry point and routing
├── pubspec.yaml                    # Dependencies and configuration
└── README.md                       # This file
```

## Key Features

### Authentication
- Session-based authentication with browser cookies
- Role-based access control
- Automatic session persistence
- Secure logout functionality

### User Interface
- Modern Cupertino design system
- Responsive layout for web browsers
- Consistent form validation
- Loading states and error handling
- Role-based navigation menus

### API Integration
- RESTful API communication
- Comprehensive error handling
- Cookie-based session management
- Type-safe data models

## Development Notes

### Backend Integration
- Ensure backend is running on `localhost:8080`
- API endpoints are defined in `app_constants.dart`
- Session cookies are automatically managed

### Role-Based Features
- Navigation items are filtered by user role
- Dashboard content varies by permissions
- Access control is enforced at the UI level

### Future Enhancements
- Complete implementation of placeholder screens
- Add real-time notifications
- Implement advanced search and filtering
- Add data export functionality
- Mobile responsive improvements

## Troubleshooting

### Common Issues

1. **Backend Connection:**
   - Ensure backend is running on port 8080
   - Check CORS configuration for web requests

2. **Session Issues:**
   - Clear browser cookies if login fails
   - Check browser developer tools for network errors

3. **Build Issues:**
   - Run `flutter clean` and `flutter pub get`
   - Ensure Flutter SDK is up to date

### Development Commands

```bash
# Get dependencies
flutter pub get

# Run analysis
flutter analyze

# Run tests
flutter test

# Build for web
flutter build web

# Clean build cache
flutter clean
```

## Contributing

1. Follow the existing code structure and naming conventions
2. Use Cupertino design components consistently
3. Implement proper error handling and loading states
4. Add appropriate form validation
5. Test with different user roles
6. Update this README for new features

## License

This project is part of the Pet Clinic System and is intended for educational and demonstration purposes.
