import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../models/service.dart';
import '../models/pet.dart';
import '../services/api_service.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/cupertino_form_field.dart';
import '../widgets/cupertino_button_primary.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ApiService _apiService = ApiService();
  List<Service> _services = [];
  List<Pet> _pets = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      debugPrint('Loading services and pets...');
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Check if user is logged in
      if (!authProvider.isLoggedIn) {
        debugPrint('User not logged in, redirecting to login');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please log in to view services';
        });
        return;
      }
      
      debugPrint('User is logged in: ${authProvider.currentUser?.userName}');
      debugPrint('User role: ${authProvider.currentUserRole}');
      
      // Load services and pets in parallel
      final results = await Future.wait([
        _apiService.get(AppConstants.services),
        _apiService.get(AppConstants.myPets),
      ]);

      final servicesData = results[0];
      final petsData = results[1];

      debugPrint('Services response: $servicesData');
      debugPrint('Pets response: $petsData');

      // Parse services
      if (servicesData is List) {
        _services = servicesData.map((json) => Service.fromJson(json as Map<String, dynamic>)).toList();
        debugPrint('Parsed ${_services.length} services from List');
      } else if (servicesData is Map<String, dynamic>) {
        if (servicesData.containsKey('data') && servicesData['data'] is List) {
          final data = servicesData['data'] as List;
          _services = data.map((json) => Service.fromJson(json as Map<String, dynamic>)).toList();
          debugPrint('Parsed ${_services.length} services from Map with data key');
        } else {
          _services = [Service.fromJson(servicesData)];
          debugPrint('Parsed 1 service from single Map');
        }
      } else {
        _services = [];
        debugPrint('No services found - response type: ${servicesData.runtimeType}');
      }

      // Parse pets
      if (petsData is List) {
        _pets = petsData.map((json) => Pet.fromJson(json as Map<String, dynamic>)).toList();
        debugPrint('Parsed ${_pets.length} pets from List');
      } else if (petsData is Map<String, dynamic> && petsData.containsKey('data')) {
        final data = petsData['data'] as List;
        _pets = data.map((json) => Pet.fromJson(json as Map<String, dynamic>)).toList();
        debugPrint('Parsed ${_pets.length} pets from Map with data key');
      } else {
        _pets = [];
        debugPrint('No pets found - response type: ${petsData.runtimeType}');
      }

      debugPrint('Final services count: ${_services.length}');
      debugPrint('Final pets count: ${_pets.length}');
      
      if (_services.isNotEmpty) {
        debugPrint('Services loaded:');
        for (var service in _services) {
          debugPrint('- ${service.serviceName} (${service.category}) - \$${service.price}');
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      
      // Check if it's an authentication error
      if (e.toString().contains('Unauthorized') || e.toString().contains('login')) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Authentication required. Please log in to view services.';
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  List<Service> get _filteredServices {
    return _services.where((service) {
      final matchesSearch = service.serviceName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           service.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || service.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get _categories {
    final categories = _services.map((service) => service.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Debug authentication state
        debugPrint('=== Services Screen Debug ===');
        debugPrint('Is logged in: ${authProvider.isLoggedIn}');
        debugPrint('Current user: ${authProvider.currentUser?.userName}');
        debugPrint('Current user role: ${authProvider.currentUserRole}');
        debugPrint('Is owner: ${authProvider.isOwner}');
        debugPrint('Is admin: ${authProvider.isAdmin}');
        debugPrint('Is staff: ${authProvider.isStaff}');
        debugPrint('Is doctor: ${authProvider.isDoctor}');
        debugPrint('=============================');
        
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
                            'Services',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Spacer(),
                          // Debug: Add login button if not authenticated
                          if (!authProvider.isLoggedIn) ...[
                            CupertinoButton(
                              onPressed: () async {
                                final success = await authProvider.login('owner@example.com', 'owner123');
                                if (success) {
                                  _loadData();
                                }
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.person_circle,
                                    size: 16,
                                    color: Color(AppConstants.systemOrange),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Login as Owner',
                                    style: TextStyle(
                                      color: Color(AppConstants.systemOrange),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          CupertinoButton(
                            onPressed: _loadData,
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
                                placeholder: 'Search services...',
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
                          
                          // Category Filter
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
                                    title: const Text('Filter by Category'),
                                    actions: _categories.map((category) {
                                      return CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            _selectedCategory = category;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(category),
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
                                    _selectedCategory,
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
                    
                    // Services Content
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
            Icon(
              _errorMessage!.contains('Authentication') || _errorMessage!.contains('login')
                  ? CupertinoIcons.lock
                  : CupertinoIcons.exclamationmark_triangle,
              size: 64,
              color: _errorMessage!.contains('Authentication') || _errorMessage!.contains('login')
                  ? const Color(AppConstants.systemOrange)
                  : const Color(AppConstants.systemRed),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!.contains('Authentication') || _errorMessage!.contains('login')
                  ? 'Authentication Required'
                  : 'Error loading services',
              style: const TextStyle(
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
            if (_errorMessage!.contains('Authentication') || _errorMessage!.contains('login')) ...[
              CupertinoButton.filled(
                onPressed: () => context.go('/login'),
                child: const Text('Go to Login'),
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                onPressed: _loadData,
                child: const Text('Try Again'),
              ),
            ] else ...[
              CupertinoButton.filled(
                onPressed: _loadData,
                child: const Text('Try Again'),
              ),
            ],
          ],
        ),
      );
    }

    final filteredServices = _filteredServices;

    if (filteredServices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.search,
              size: 64,
              color: Color(AppConstants.systemGray),
            ),
            const SizedBox(height: 16),
            const Text(
              'No services found',
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
                  : 'No services available at the moment',
              style: const TextStyle(
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredServices.length,
      itemBuilder: (context, index) {
        final service = filteredServices[index];
        return _ServiceCard(
          service: service,
          pets: _pets,
          authProvider: authProvider,
          onBookingSuccess: _loadData,
        );
      },
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

class _ServiceCard extends StatelessWidget {
  final Service service;
  final List<Pet> pets;
  final AuthProvider authProvider;
  final VoidCallback onBookingSuccess;

  const _ServiceCard({
    required this.service,
    required this.pets,
    required this.authProvider,
    required this.onBookingSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withAlpha(25),
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
            // Service Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(AppConstants.primaryBlue).withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getServiceIcon(service.serviceName, service.category),
                    color: const Color(AppConstants.primaryBlue),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.serviceName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(AppConstants.labelColor),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(AppConstants.systemGray5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          service.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(AppConstants.secondaryLabelColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Description
            Expanded(
              child: Text(
                service.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(AppConstants.secondaryLabelColor),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            
            // Price and Book Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${service.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(AppConstants.primaryBlue),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: const Color(AppConstants.primaryBlue),
                  borderRadius: BorderRadius.circular(8),
                  onPressed: () => _showBookingDialog(context),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getServiceIcon(String serviceName, String category) {
    final name = serviceName.toLowerCase();
    final cat = category.toLowerCase();
    
    if (name.contains('exam') || name.contains('check') || cat.contains('health')) {
      return CupertinoIcons.heart_fill; // UC003: Examination
    } else if (name.contains('board') || name.contains('stay') || name.contains('care')) {
      return CupertinoIcons.house_fill; // UC005: Boarding
    } else if (name.contains('groom') || name.contains('bath') || name.contains('clean') || cat.contains('groom')) {
      return CupertinoIcons.scissors; // UC006: Grooming
    } else if (cat.contains('medical')) {
      return CupertinoIcons.plus_circle_fill;
    } else {
      return CupertinoIcons.heart_fill; // Default
    }
  }

  void _showBookingDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _ServiceBookingDialog(
        service: service,
        pets: pets,
        authProvider: authProvider,
        onBookingSuccess: onBookingSuccess,
      ),
    );
  }
}

// Service-specific booking dialog implementing UC003, UC005, UC006
class _ServiceBookingDialog extends StatefulWidget {
  final Service service;
  final List<Pet> pets;
  final AuthProvider authProvider;
  final VoidCallback onBookingSuccess;

  const _ServiceBookingDialog({
    required this.service,
    required this.pets,
    required this.authProvider,
    required this.onBookingSuccess,
  });

  @override
  State<_ServiceBookingDialog> createState() => _ServiceBookingDialogState();
}

class _ServiceBookingDialogState extends State<_ServiceBookingDialog> {
  final ApiService _apiService = ApiService();
  final _notesController = TextEditingController();
  Pet? _selectedPet;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _endDate;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _isExaminationService {
    final name = widget.service.serviceName.toLowerCase();
    return name.contains('exam') || name.contains('check') || name.contains('consultation');
  }

  bool get _isBoardingService {
    final name = widget.service.serviceName.toLowerCase();
    return name.contains('board') || name.contains('stay') || name.contains('care');
  }

  bool get _isGroomingService {
    final name = widget.service.serviceName.toLowerCase();
    return name.contains('groom') || name.contains('bath') || name.contains('clean');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(AppConstants.systemGray6),
      navigationBar: CupertinoNavigationBar(
        middle: Text('Book ${widget.service.serviceName}'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : _saveBooking,
          child: _isLoading
              ? const CupertinoActivityIndicator()
              : const Text('Book'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Service Info Card
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(AppConstants.primaryBlue).withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getServiceIcon(),
                          color: const Color(AppConstants.primaryBlue),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.service.serviceName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(AppConstants.labelColor),
                              ),
                            ),
                            Text(
                              '\$${widget.service.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(AppConstants.primaryBlue),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.service.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.service.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(AppConstants.secondaryLabelColor),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pet Selection (UC003, UC005, UC006 all require pet selection)
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Pet *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (widget.pets.isEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(AppConstants.systemGray6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.info,
                            color: Color(AppConstants.systemOrange),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'No pets found. Please add a pet first.',
                              style: TextStyle(
                                color: Color(AppConstants.secondaryLabelColor),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.go('/pets');
                            },
                            child: const Text(
                              'Add Pet',
                              style: TextStyle(
                                color: Color(AppConstants.primaryBlue),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(AppConstants.systemGray6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(AppConstants.systemGray4),
                          width: 1,
                        ),
                      ),
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(12),
                        onPressed: () => _showPetPicker(context),
                        child: Row(
                          children: [
                            if (_selectedPet != null) ...[
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(AppConstants.primaryBlue).withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  CupertinoIcons.paw,
                                  color: Color(AppConstants.primaryBlue),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedPet!.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(AppConstants.labelColor),
                                      ),
                                    ),
                                    Text(
                                      '${_selectedPet!.species} • ${_selectedPet!.gender} • ${_selectedPet!.color}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(AppConstants.secondaryLabelColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              const Icon(
                                CupertinoIcons.paw,
                                color: Color(AppConstants.systemGray),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Select a pet',
                                  style: TextStyle(
                                    color: Color(AppConstants.placeholderTextColor),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                            const Icon(
                              CupertinoIcons.chevron_down,
                              color: Color(AppConstants.systemGray),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Date and Time Selection based on service type
            if (_isExaminationService) ...[
              // UC003: Examination - Date and Time
              _buildExaminationDateTimeSection(),
            ] else if (_isBoardingService || _isGroomingService) ...[
              // UC005 & UC006: Boarding/Grooming - Date range
              _buildServiceDateRangeSection(),
            ] else ...[
              // Default: Single date
              _buildDefaultDateSection(),
            ],

            const SizedBox(height: 16),

            // Notes Section
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Additional Notes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CupertinoFormField(
                    controller: _notesController,
                    placeholder: 'Enter any special requirements or notes...',
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Book Button
            CupertinoPrimaryButton(
              onPressed: widget.pets.isEmpty ? null : _saveBooking,
              child: Text(_isLoading ? 'Booking...' : 'Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExaminationDateTimeSection() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Examination Schedule *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(AppConstants.labelColor),
            ),
          ),
          const SizedBox(height: 12),
          
          // Date Selection
          Row(
            children: [
              const Icon(
                CupertinoIcons.calendar,
                color: Color(AppConstants.systemGray),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Date:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(AppConstants.labelColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onPressed: () => _selectStartDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(AppConstants.systemGray6),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(AppConstants.systemGray4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('MMM dd, yyyy').format(_startDate),
                            style: const TextStyle(
                              color: Color(AppConstants.labelColor),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.calendar,
                          color: Color(AppConstants.systemGray),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Time Selection
          Row(
            children: [
              const Icon(
                CupertinoIcons.time,
                color: Color(AppConstants.systemGray),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Time:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(AppConstants.labelColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onPressed: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(AppConstants.systemGray6),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(AppConstants.systemGray4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedTime.format(context),
                            style: const TextStyle(
                              color: Color(AppConstants.labelColor),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.clock,
                          color: Color(AppConstants.systemGray),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDateRangeSection() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_isBoardingService ? 'Boarding' : 'Grooming'} Schedule *',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(AppConstants.labelColor),
            ),
          ),
          const SizedBox(height: 12),
          
          // Start Date
          Row(
            children: [
              const Icon(
                CupertinoIcons.calendar,
                color: Color(AppConstants.systemGray),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Start Date:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(AppConstants.labelColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onPressed: () => _selectStartDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(AppConstants.systemGray6),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(AppConstants.systemGray4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('MMM dd, yyyy').format(_startDate),
                            style: const TextStyle(
                              color: Color(AppConstants.labelColor),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.calendar,
                          color: Color(AppConstants.systemGray),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          if (_isBoardingService) ...[
            const SizedBox(height: 12),
            // End Date for boarding services
            Row(
              children: [
                const Icon(
                  CupertinoIcons.calendar,
                  color: Color(AppConstants.systemGray),
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'End Date:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(AppConstants.labelColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    onPressed: () => _selectEndDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(AppConstants.systemGray6),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(AppConstants.systemGray4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _endDate == null 
                                  ? 'Select end date (optional)'
                                  : DateFormat('MMM dd, yyyy').format(_endDate!),
                              style: TextStyle(
                                color: _endDate == null 
                                    ? const Color(AppConstants.placeholderTextColor)
                                    : const Color(AppConstants.labelColor),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.calendar,
                            color: Color(AppConstants.systemGray),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultDateSection() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Date *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(AppConstants.labelColor),
            ),
          ),
          const SizedBox(height: 12),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onPressed: () => _selectStartDate(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(AppConstants.systemGray6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(AppConstants.systemGray4),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.calendar,
                    color: Color(AppConstants.systemGray),
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      DateFormat('MMM dd, yyyy').format(_startDate),
                      style: const TextStyle(
                        color: Color(AppConstants.labelColor),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon() {
    if (_isExaminationService) {
      return CupertinoIcons.heart_fill;
    } else if (_isBoardingService) {
      return CupertinoIcons.house_fill;
    } else if (_isGroomingService) {
      return CupertinoIcons.scissors;
    } else {
      return CupertinoIcons.heart_fill;
    }
  }

  void _showPetPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Select Pet'),
        message: const Text('Choose a pet for this service'),
        actions: widget.pets.map((pet) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedPet = pet;
              });
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${pet.species} • ${pet.gender} • ${pet.color}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(AppConstants.secondaryLabelColor),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(AppConstants.systemGray4),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _startDate,
                  minimumDate: DateTime.now(),
                  maximumDate: DateTime(2100),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _startDate = newDate;
                      if (_endDate != null && _endDate!.isBefore(newDate)) {
                        _endDate = null;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectEndDate(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(AppConstants.systemGray4),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const Text(
                      'Select End Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _endDate ?? _startDate.add(const Duration(days: 1)),
                  minimumDate: _startDate,
                  maximumDate: DateTime(2100),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _endDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(AppConstants.systemGray4),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const Text(
                      'Select Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(2023, 1, 1, _selectedTime.hour, _selectedTime.minute),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: newDateTime.hour,
                        minute: newDateTime.minute,
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBooking() async {
    if (_selectedPet == null) {
      _showErrorDialog('Please select a pet for this service');
      return;
    }

    if (_isBoardingService && _endDate != null && _endDate!.isBefore(_startDate)) {
      _showErrorDialog('End date must be on or after start date');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Build start date string (include time for examination)
      final String startDateStr = _isExaminationService
          ? '${DateFormat('yyyy-MM-dd').format(_startDate)} ${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00'
          : DateFormat('yyyy-MM-dd').format(_startDate);
      
      final String? endDateStr = _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : null;

      final bookingData = {
        'start_date': startDateStr,
        if (endDateStr != null) 'end_date': endDateStr,
        'notes': _notesController.text.trim(),
        'user_id': widget.authProvider.currentUser!.id,
        'service_id': widget.service.id,
        'pet_id': _selectedPet!.id,
      };

      await _apiService.post(AppConstants.bookings, body: bookingData);
      
      if (mounted) {
        Navigator.of(context).pop();
        widget.onBookingSuccess();
        _showSuccessDialog('Booking created successfully! You can view it in My Bookings.');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Failed to create booking: $e');
      }
    }
  }

  void _showSuccessDialog(String message) {
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

  void _showErrorDialog(String message) {
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