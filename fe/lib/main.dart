import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/pets_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/services_screen.dart';
import 'screens/medical_records_screen.dart';
import 'screens/users_screen.dart';
import 'screens/cages_screen.dart';
import 'screens/access_denied_screen.dart';
import 'screens/my_pets_screen.dart';
import 'screens/my_bookings_screen.dart';
import 'constants/app_constants.dart';

void main() {
  runApp(const PetClinicApp());
}

class PetClinicApp extends StatelessWidget {
  const PetClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return AppInitializer(
            child: CupertinoApp.router(
              title: 'Pet Clinic System',
              theme: const CupertinoThemeData(
                primaryColor: Color(AppConstants.primaryBlue),
                scaffoldBackgroundColor: Color(AppConstants.systemGray6),
                textTheme: CupertinoTextThemeData(
                  primaryColor: Color(AppConstants.labelColor),
                ),
              ),
              routerConfig: _createRouter(authProvider),
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }

  GoRouter _createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/dashboard',
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isLoginRoute = state.matchedLocation == '/login' || 
                           state.matchedLocation == '/register';

        // If not logged in and trying to access protected route, redirect to login
        if (!isLoggedIn && !isLoginRoute) {
          return '/login';
        }

        // If logged in and trying to access login/register, redirect to dashboard
        if (isLoggedIn && isLoginRoute) {
          return '/dashboard';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
      ),
        GoRoute(
          path: '/pets',
          builder: (context, state) => const PetsScreen(),
        ),
        GoRoute(
          path: '/bookings',
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesScreen(),
        ),
        GoRoute(
          path: '/medical-records',
          builder: (context, state) => const MedicalRecordsScreen(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const UsersScreen(),
        ),
        GoRoute(
          path: '/cages',
          builder: (context, state) => const CagesScreen(),
        ),
        GoRoute(
          path: '/access-denied',
          builder: (context, state) => const AccessDeniedScreen(),
        ),
        // Owner-specific routes
        GoRoute(
          path: '/my-pets',
          builder: (context, state) => const MyPetsScreen(),
        ),
        GoRoute(
          path: '/my-bookings',
          builder: (context, state) => const MyBookingsScreen(),
        ),
      ],
    );
  }
}

class AppInitializer extends StatefulWidget {
  final Widget child;

  const AppInitializer({super.key, required this.child});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();
    } catch (e) {
      // Handle initialization error
    } finally {
      if (mounted) {
    setState(() {
          _isInitialized = true;
    });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const CupertinoPageScaffold(
        backgroundColor: Color(AppConstants.systemGray6),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(
                radius: 20,
              ),
              SizedBox(height: 16),
            Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(AppConstants.secondaryLabelColor),
                ),
            ),
          ],
        ),
      ),
    );
    }

    return widget.child;
  }
}
