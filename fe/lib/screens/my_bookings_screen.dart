import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../models/booking.dart';
import '../models/service.dart';
import '../models/pet.dart';
import '../services/api_service.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/cupertino_form_field.dart';
import '../widgets/cupertino_button_primary.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final ApiService _apiService = ApiService();
  List<Booking> _bookings = [];
  List<Service> _services = [];
  List<Pet> _pets = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedStatus = 'All';

  final List<String> _statuses = ['All', 'PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED'];

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

      // Load bookings, services, and pets in parallel
      final results = await Future.wait([
        _apiService.get(AppConstants.myBookings),
        _apiService.get(AppConstants.services),
        _apiService.get(AppConstants.myPets),
      ]);

      final bookingsData = results[0];
      final servicesData = results[1];
      final petsData = results[2];

      // Parse bookings
      if (bookingsData is List) {
        _bookings = bookingsData.map((json) => Booking.fromJson(json as Map<String, dynamic>)).toList();
      } else if (bookingsData is Map<String, dynamic> && bookingsData.containsKey('data')) {
        final data = bookingsData['data'] as List;
        _bookings = data.map((json) => Booking.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        _bookings = [];
      }

      // Parse services
      if (servicesData is List) {
        _services = servicesData.map((json) => Service.fromJson(json as Map<String, dynamic>)).toList();
      } else if (servicesData is Map<String, dynamic> && servicesData.containsKey('data')) {
        final data = servicesData['data'] as List;
        _services = data.map((json) => Service.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        _services = [];
      }

      // Parse pets
      if (petsData is List) {
        _pets = petsData.map((json) => Pet.fromJson(json as Map<String, dynamic>)).toList();
      } else if (petsData is Map<String, dynamic> && petsData.containsKey('data')) {
        final data = petsData['data'] as List;
        _pets = data.map((json) => Pet.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        _pets = [];
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

  List<Booking> get _filteredBookings {
    return _bookings.where((booking) {
      final matchesSearch = _getServiceName(booking.serviceId).toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           booking.notes.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'All' || booking.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  String _getServiceName(int serviceId) {
    final service = _services.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => Service(
        id: serviceId,
        serviceName: 'Unknown Service',
        category: '',
        description: '',
        price: 0.0,
      ),
    );
    return service.serviceName;
  }

  String _getPetName(int? petId) {
    if (petId == null) return 'No pet specified';
    final pet = _pets.firstWhere(
      (p) => p.id == petId,
      orElse: () => Pet(
        id: petId,
        name: 'Unknown Pet',
        birthDate: '',
        gender: '',
        species: '',
        color: '',
        healthInfo: '',
        userId: 0,
      ),
    );
    return pet.name;
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
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
                            'My Bookings',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Spacer(),
                          CupertinoButton(
                            onPressed: () => _showCreateBookingDialog(context, authProvider),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.add,
                                  size: 16,
                                  color: Color(AppConstants.primaryBlue),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'New Booking',
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
                          // Search Bar
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(AppConstants.systemGray6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CupertinoTextField(
                                placeholder: 'Search bookings by service or notes...',
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
                          
                          // Status Filter
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(AppConstants.systemGray6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.slider_horizontal_3,
                                    color: Color(AppConstants.systemGray),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () => _showStatusFilterDialog(context),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Status: $_selectedStatus',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(AppConstants.labelColor),
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            CupertinoIcons.chevron_down,
                                            color: Color(AppConstants.systemGray),
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Content
                    Expanded(
                      child: _buildContent(),
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

  Widget _buildContent() {
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
              'Error loading bookings',
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
              onPressed: _loadData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final filteredBookings = _filteredBookings;

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.calendar,
              size: 64,
              color: Color(AppConstants.systemGray),
            ),
            const SizedBox(height: 16),
            const Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.labelColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty || _selectedStatus != 'All'
                  ? 'Try adjusting your search or filter'
                  : 'Create your first booking to get started',
              style: const TextStyle(
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            if (_searchQuery.isEmpty && _selectedStatus == 'All') ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: () => _showCreateBookingDialog(context, Provider.of<AuthProvider>(context, listen: false)),
                child: const Text('Create Your First Booking'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(32),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return _BookingCard(
          booking: booking,
          serviceName: _getServiceName(booking.serviceId),
          petName: _getPetName(booking.petId),
          onCancel: booking.status == 'PENDING' || booking.status == 'CONFIRMED'
              ? () => _cancelBooking(booking)
              : null,
          onViewDetails: () => _showBookingDetails(context, booking),
        );
      },
    );
  }

  Future<void> _cancelBooking(Booking booking) async {
    try {
      await _apiService.put('${AppConstants.bookings}/${booking.id}/cancel');
      await _loadData();
      if (mounted) {
        _showSuccessDialog(context, 'Booking cancelled successfully!');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, 'Failed to cancel booking: $e');
      }
    }
  }

  void _showCreateBookingDialog(BuildContext context, AuthProvider authProvider) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _BookingFormDialog(
        authProvider: authProvider,
        services: _services,
        pets: _pets,
        onSave: (bookingCreate) async {
          try {
            await _apiService.post(AppConstants.bookings, body: bookingCreate.toJson());
            await _loadData();
            if (context.mounted) {
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'Booking created successfully!');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, 'Failed to create booking: $e');
            }
          }
        },
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(_getServiceName(booking.serviceId)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Pet', _getPetName(booking.petId)),
            _buildDetailRow('Start Date', DateFormat('MMM dd, yyyy').format(_parseDate(booking.startDate))),
            if (booking.endDate != null && booking.endDate!.isNotEmpty)
              _buildDetailRow('End Date', DateFormat('MMM dd, yyyy').format(_parseDate(booking.endDate!))),
            _buildDetailRow('Status', booking.status),
            if (booking.notes.isNotEmpty)
              _buildDetailRow('Notes', booking.notes),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusFilterDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Filter by Status'),
        actions: _statuses.map((status) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedStatus = status;
              });
              Navigator.of(context).pop();
            },
            child: Text(status),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
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

// Booking Card Widget
class _BookingCard extends StatelessWidget {
  final Booking booking;
  final String serviceName;
  final String petName;
  final VoidCallback? onCancel;
  final VoidCallback onViewDetails;

  const _BookingCard({
    required this.booking,
    required this.serviceName,
    required this.petName,
    this.onCancel,
    required this.onViewDetails,
  });

  DateTime _parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(AppConstants.systemGray5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(AppConstants.labelColor),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pet: $petName',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(AppConstants.secondaryLabelColor),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(booking.status),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Date Information
          Row(
            children: [
              const Icon(
                CupertinoIcons.calendar,
                size: 16,
                color: Color(AppConstants.systemGray),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMM dd, yyyy').format(_parseDate(booking.startDate)),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(AppConstants.labelColor),
                ),
              ),
              if (booking.endDate != null && booking.endDate!.isNotEmpty) ...[
                const Text(
                  ' - ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(AppConstants.systemGray),
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(_parseDate(booking.endDate!)),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(AppConstants.labelColor),
                  ),
                ),
              ],
            ],
          ),
          
          // Notes
          if (booking.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              booking.notes,
              style: const TextStyle(
                fontSize: 14,
                color: Color(AppConstants.secondaryLabelColor),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  onPressed: onViewDetails,
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: Color(AppConstants.primaryBlue),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (onCancel != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onPressed: onCancel,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(AppConstants.systemRed),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'PENDING':
        backgroundColor = const Color(AppConstants.systemOrange).withValues(alpha: 0.1);
        textColor = const Color(AppConstants.systemOrange);
        break;
      case 'CONFIRMED':
        backgroundColor = const Color(AppConstants.primaryBlue).withValues(alpha: 0.1);
        textColor = const Color(AppConstants.primaryBlue);
        break;
      case 'COMPLETED':
        backgroundColor = const Color(AppConstants.systemGreen).withValues(alpha: 0.1);
        textColor = const Color(AppConstants.systemGreen);
        break;
      case 'CANCELLED':
        backgroundColor = const Color(AppConstants.systemRed).withValues(alpha: 0.1);
        textColor = const Color(AppConstants.systemRed);
        break;
      default:
        backgroundColor = const Color(AppConstants.systemGray).withValues(alpha: 0.1);
        textColor = const Color(AppConstants.systemGray);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// Booking Form Dialog
class _BookingFormDialog extends StatefulWidget {
  final AuthProvider authProvider;
  final List<Service> services;
  final List<Pet> pets;
  final Function(BookingCreate) onSave;

  const _BookingFormDialog({
    required this.authProvider,
    required this.services,
    required this.pets,
    required this.onSave,
  });

  @override
  State<_BookingFormDialog> createState() => _BookingFormDialogState();
}

class _BookingFormDialogState extends State<_BookingFormDialog> {
  final _notesController = TextEditingController();
  Service? _selectedService;
  Pet? _selectedPet;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _endDate;
  bool _hasEndDate = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(AppConstants.systemGray6),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Create Booking'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _saveBooking,
          child: const Text('Save'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Service Selection
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
                    'Service *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _showServicePicker(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(AppConstants.systemGray6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedService?.serviceName ?? 'Select a service',
                              style: TextStyle(
                                color: _selectedService != null 
                                    ? const Color(AppConstants.labelColor)
                                    : const Color(AppConstants.placeholderTextColor),
                              ),
                            ),
                          ),
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
              ),
            ),
            const SizedBox(height: 16),
            
            // Pet Selection
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
                    'Pet (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _showPetPicker(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(AppConstants.systemGray6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedPet?.name ?? 'Select a pet (optional)',
                              style: TextStyle(
                                color: _selectedPet != null 
                                    ? const Color(AppConstants.labelColor)
                                    : const Color(AppConstants.placeholderTextColor),
                              ),
                            ),
                          ),
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
              ),
            ),
            const SizedBox(height: 16),
            
            // Booking Details: date and time or date range
            if (_selectedService != null && _selectedService!.serviceName.toLowerCase().contains('exam')) ...[
              // Examination: single date and time
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
                      'Examination Date *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(AppConstants.labelColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _selectStartDate(context),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(_startDate),
                              style: const TextStyle(color: Color(AppConstants.labelColor)),
                            ),
                          ),
                          const Icon(CupertinoIcons.calendar, color: Color(AppConstants.systemGray)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Time *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(AppConstants.labelColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _selectTime(context),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedTime.format(context),
                              style: const TextStyle(color: Color(AppConstants.labelColor)),
                            ),
                          ),
                          const Icon(CupertinoIcons.time, color: Color(AppConstants.systemGray)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Boarding & Grooming: date range UI
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
                      'Start Date *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(AppConstants.labelColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _selectStartDate(context),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(_startDate),
                              style: const TextStyle(color: Color(AppConstants.labelColor)),
                            ),
                          ),
                          const Icon(CupertinoIcons.calendar, color: Color(AppConstants.systemGray)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Has End Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(AppConstants.labelColor))),
                        const Spacer(),
                        CupertinoSwitch(
                          value: _hasEndDate,
                          onChanged: (val) => setState(() { _hasEndDate = val; if (!val) _endDate = null; else _endDate = _startDate.add(const Duration(days:1)); }),
                        ),
                      ],
                    ),
                    if (_hasEndDate) ...[
                      const SizedBox(height: 12),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => _selectEndDate(context),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(_endDate == null ? 'Select end date' : DateFormat('MMM dd, yyyy').format(_endDate!), style: TextStyle(color: _endDate==null ? const Color(AppConstants.placeholderTextColor) : const Color(AppConstants.labelColor))),
                            ),
                            const Icon(CupertinoIcons.calendar, color: Color(AppConstants.systemGray)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Notes
            CupertinoFormField(
              controller: _notesController,
              placeholder: 'Enter any additional notes or requirements',
              maxLines: 3,
            ),
            
            const SizedBox(height: 32),
            
            CupertinoPrimaryButton(
              onPressed: _saveBooking,
              child: const Text('Create Booking'),
            ),
          ],
        ),
      ),
    );
  }

  void _showServicePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged: (index) {
            setState(() {
              _selectedService = widget.services[index];
            });
          },
          children: widget.services.map((service) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    service.serviceName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${service.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(AppConstants.secondaryLabelColor),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPetPicker(BuildContext context) {
    final petsWithNone = [null, ...widget.pets];
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: CupertinoPicker(
          itemExtent: 50,
          onSelectedItemChanged: (index) {
            setState(() {
              _selectedPet = petsWithNone[index];
            });
          },
          children: petsWithNone.map((pet) {
            if (pet == null) {
              return const Center(
                child: Text(
                  'No pet specified',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(AppConstants.secondaryLabelColor),
                  ),
                ),
              );
            }
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${pet.species} • ${pet.gender}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(AppConstants.secondaryLabelColor),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
          _hasEndDate = false;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 1)),
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveBooking() {
    if (_selectedService == null) {
      _showErrorDialog('Please select a service');
      return;
    }
    if (_hasEndDate && _endDate == null) {
      _showErrorDialog('Please select an end date or disable end date');
      return;
    }
    if (_hasEndDate && _endDate!.isBefore(_startDate)) {
      _showErrorDialog('End date must be on or after start date');
      return;
    }

    // Build start date string (include time for examination)
    final bool isExam = _selectedService?.serviceName.toLowerCase().contains('exam') ?? false;
    final String startDateStr = isExam
      ? '${DateFormat('yyyy-MM-dd').format(_startDate)} ${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00'
      : DateFormat('yyyy-MM-dd').format(_startDate);
    final String? endDateStr = !isExam && _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : null;
    final bookingCreate = BookingCreate(
      startDate: startDateStr,
      endDate: endDateStr,
      notes: _notesController.text.trim(),
      userId: widget.authProvider.currentUser!.id,
      serviceId: _selectedService!.id,
      petId: _selectedPet?.id,
    );

    widget.onSave(bookingCreate);
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

// Booking Create Model
class BookingCreate {
  final String startDate;
  final String? endDate;
  final String notes;
  final int userId;
  final int serviceId;
  final int? petId;

  BookingCreate({
    required this.startDate,
    this.endDate,
    required this.notes,
    required this.userId,
    required this.serviceId,
    this.petId,
  });

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      'notes': notes,
      'user_id': userId,
      'service_id': serviceId,
      if (petId != null) 'pet_id': petId,
    };
  }
} 