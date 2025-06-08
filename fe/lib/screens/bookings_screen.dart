import 'package:flutter/cupertino.dart';
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

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final ApiService _apiService = ApiService();
  List<Booking> _bookings = [];
  List<Service> _services = [];
  List<Pet> _pets = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadBookings(),
      _loadServices(),
      _loadPets(),
    ]);
  }

  Future<void> _loadBookings() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String endpoint;
      
      if (authProvider.isOwner) {
        endpoint = AppConstants.myBookings;
      } else {
        endpoint = AppConstants.bookings;
      }

      print('Loading bookings from endpoint: $endpoint'); // Debug log
      final response = await _apiService.get(endpoint);
      print('Bookings response: $response'); // Debug log
      
      List<Booking> bookings = [];
      
      if (response is List) {
        bookings = response.map((json) {
          try {
            return Booking.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing booking: $e, JSON: $json');
            return null;
          }
        }).where((booking) => booking != null).cast<Booking>().toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          final data = response['data'] as List;
          bookings = data.map((json) {
            try {
              return Booking.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing booking: $e, JSON: $json');
              return null;
            }
          }).where((booking) => booking != null).cast<Booking>().toList();
        } else if (response.containsKey('id')) {
          // Single booking response
          try {
            bookings = [Booking.fromJson(response)];
          } catch (e) {
            print('Error parsing single booking: $e, JSON: $response');
          }
        }
      }

      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
      
      print('Loaded ${_bookings.length} bookings'); // Debug log
    } catch (e) {
      print('Error loading bookings: $e'); // Debug log
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load bookings: ${e.toString()}';
      });
    }
  }

  Future<void> _loadServices() async {
    try {
      final response = await _apiService.get(AppConstants.services);
      
      if (response is List) {
        _services = response.map((json) => Service.fromJson(json as Map<String, dynamic>)).toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          final data = response['data'] as List;
          _services = data.map((json) => Service.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          _services = [Service.fromJson(response)];
        }
      } else {
        _services = [];
      }
    } catch (e) {
      // Services loading is optional for display purposes
    }
  }

  Future<void> _loadPets() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String endpoint;
      
      if (authProvider.isOwner) {
        endpoint = AppConstants.myPets;
      } else {
        endpoint = AppConstants.pets;
      }

      final response = await _apiService.get(endpoint);
      
      if (response is List) {
        _pets = response.map((json) => Pet.fromJson(json as Map<String, dynamic>)).toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          final data = response['data'] as List;
          _pets = data.map((json) => Pet.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          _pets = [Pet.fromJson(response)];
        }
      } else {
        _pets = [];
      }
    } catch (e) {
      // Pets loading is optional for display purposes
    }
  }

  List<Booking> get _filteredBookings {
    return _bookings.where((booking) {
      final matchesSearch = booking.notes.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'All' || booking.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  List<String> get _statuses {
    final statuses = _bookings.map((booking) => booking.status).toSet().toList();
    statuses.sort();
    return ['All', ...statuses];
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
                          Text(
                            authProvider.isOwner ? 'My Bookings' : 'All Bookings',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Spacer(),
                          if (authProvider.isOwner)
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
                            onPressed: _loadBookings,
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
                                placeholder: 'Search bookings...',
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
                                    title: const Text('Filter by Status'),
                                    actions: _statuses.map((status) {
                                      return CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            _selectedStatus = status;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(status),
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
                                    _selectedStatus,
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
                    
                    // Bookings Content
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
              onPressed: _loadBookings,
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
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : authProvider.isOwner
                      ? 'Create your first booking to get started'
                      : 'No bookings in the system yet',
              style: const TextStyle(
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            if (_searchQuery.isEmpty && authProvider.isOwner) ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: () => _showCreateBookingDialog(context, authProvider),
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
          authProvider: authProvider,
          services: _services,
          pets: _pets,
          onStatusUpdate: authProvider.canManageBookings ? () => _showStatusUpdateDialog(context, booking) : null,
          onCancel: () => _cancelBooking(context, booking),
        );
      },
    );
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
            await _loadBookings();
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

  void _showStatusUpdateDialog(BuildContext context, Booking booking) {
    final statuses = ['PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED'];
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Update Booking Status'),
        actions: statuses.map((status) {
          return CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _apiService.patchWithQuery(
                  '${AppConstants.bookings}/${booking.id}/status',
                  {'status': status},
                );
                await _loadBookings();
                if (context.mounted) {
                  _showSuccessDialog(context, 'Booking status updated successfully!');
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorDialog(context, 'Failed to update status: $e');
                }
              }
            },
            child: Text(status),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _cancelBooking(BuildContext context, Booking booking) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await _apiService.put('${AppConstants.bookings}/${booking.id}/cancel');
                await _loadBookings();
                if (context.mounted) {
                  _showSuccessDialog(context, 'Booking cancelled successfully!');
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorDialog(context, 'Failed to cancel booking: $e');
                }
              }
            },
            child: const Text('Yes, Cancel'),
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

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final AuthProvider authProvider;
  final List<Service> services;
  final List<Pet> pets;
  final VoidCallback? onStatusUpdate;
  final VoidCallback onCancel;

  const _BookingCard({
    required this.booking,
    required this.authProvider,
    required this.services,
    required this.pets,
    this.onStatusUpdate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final service = services.firstWhere(
      (s) => s.id == booking.serviceId,
      orElse: () => Service(
        id: 0,
        serviceName: 'Unknown Service',
        category: '',
        description: '',
        price: 0.0,
      ),
    );

    final pet = pets.firstWhere(
      (p) => p.id == booking.petId,
      orElse: () => Pet(
        id: 0,
        name: 'Unknown Pet',
        birthDate: '',
        gender: '',
        species: '',
        color: '',
        healthInfo: '',
        userId: 0,
      ),
    );

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
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pet: ${pet.name}',
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
            
            // Booking Details
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Start Date',
                    _formatDate(booking.startDate),
                    CupertinoIcons.calendar,
                  ),
                ),
                if (booking.endDate != null && booking.endDate!.isNotEmpty)
                  Expanded(
                    child: _buildDetailItem(
                      'End Date',
                      _formatDate(booking.endDate!),
                      CupertinoIcons.calendar,
                    ),
                  ),
              ],
            ),
            
            if (booking.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Notes: ${booking.notes}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(AppConstants.secondaryLabelColor),
                ),
              ),
            ],
            
            // Actions
            if (onStatusUpdate != null || booking.status != 'CANCELLED') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (onStatusUpdate != null)
                    CupertinoSecondaryButton(
                      onPressed: onStatusUpdate,
                      child: const Text('Update Status'),
                    ),
                  if (onStatusUpdate != null && booking.status != 'CANCELLED')
                    const SizedBox(width: 12),
                  if (booking.status != 'CANCELLED' && booking.status != 'COMPLETED')
                    CupertinoDestructiveButton(
                      onPressed: onCancel,
                      child: const Text('Cancel'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'PENDING':
        color = const Color(0xFFFF9500); // Orange
        break;
      case 'CONFIRMED':
        color = const Color(AppConstants.primaryBlue);
        break;
      case 'COMPLETED':
        color = const Color(0xFF34C759); // Green
        break;
      case 'CANCELLED':
        color = const Color(AppConstants.systemRed);
        break;
      default:
        color = const Color(AppConstants.systemGray);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(AppConstants.systemGray),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(AppConstants.systemGray),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(AppConstants.labelColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}

class _BookingFormDialog extends StatefulWidget {
  final AuthProvider authProvider;
  final List<Service> services;
  final List<Pet> pets;
  final Function(dynamic) onSave;

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
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _endDate;
  int? _selectedServiceId;
  int? _selectedPetId;
  bool _isLoading = false;

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
          onPressed: _isLoading ? null : _saveBooking,
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
              // Service Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service',
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
                            title: const Text('Select Service'),
                            actions: widget.services.map((service) {
                              return CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() {
                                    _selectedServiceId = service.id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('${service.serviceName} - \$${service.price.toStringAsFixed(2)}'),
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
                            _selectedServiceId != null
                                ? widget.services.firstWhere((s) => s.id == _selectedServiceId).serviceName
                                : 'Select a service',
                            style: TextStyle(
                              color: _selectedServiceId != null
                                  ? const Color(AppConstants.labelColor)
                                  : const Color(AppConstants.systemGray),
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
              const SizedBox(height: 16),
              
              // Pet Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pet',
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
                            title: const Text('Select Pet'),
                            actions: widget.pets.map((pet) {
                              return CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() {
                                    _selectedPetId = pet.id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('${pet.name} (${pet.species})'),
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
                            _selectedPetId != null
                                ? widget.pets.firstWhere((p) => p.id == _selectedPetId).name
                                : 'Select a pet',
                            style: TextStyle(
                              color: _selectedPetId != null
                                  ? const Color(AppConstants.labelColor)
                                  : const Color(AppConstants.systemGray),
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
              const SizedBox(height: 16),
              
              // Start Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start Date',
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
                          builder: (context) => Container(
                            height: 300,
                            color: CupertinoColors.white,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CupertinoButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      CupertinoButton(
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
                                    onDateTimeChanged: (date) {
                                      setState(() {
                                        _startDate = date;
                                        if (_endDate != null && _endDate!.isBefore(date)) {
                                          _endDate = null;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy').format(_startDate),
                            style: const TextStyle(
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.calendar,
                            color: Color(AppConstants.systemGray),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // End Date (Optional)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'End Date (Optional)',
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
                          builder: (context) => Container(
                            height: 300,
                            color: CupertinoColors.white,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CupertinoButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      CupertinoButton(
                                        onPressed: () {
                                          setState(() {
                                            _endDate = null;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Clear'),
                                      ),
                                      CupertinoButton(
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
                                    onDateTimeChanged: (date) {
                                      setState(() {
                                        _endDate = date;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _endDate != null
                                ? DateFormat('MMM dd, yyyy').format(_endDate!)
                                : 'Select end date (optional)',
                            style: TextStyle(
                              color: _endDate != null
                                  ? const Color(AppConstants.labelColor)
                                  : const Color(AppConstants.systemGray),
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.calendar,
                            color: Color(AppConstants.systemGray),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Notes
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoFormField(
                    controller: _notesController,
                    placeholder: 'Any special requests or notes...',
                    maxLines: 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBooking() async {
    if (_selectedServiceId == null) {
      _showErrorDialog('Please select a service');
      return;
    }
    
    if (_selectedPetId == null) {
      _showErrorDialog('Please select a pet');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final startDateString = DateFormat('yyyy-MM-dd').format(_startDate);
      final endDateString = _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '';
      
      final bookingCreate = BookingCreate(
        startDate: startDateString,
        endDate: endDateString,
        notes: _notesController.text.trim(),
        userId: widget.authProvider.currentUser?.id ?? 0,
        serviceId: _selectedServiceId!,
        petId: _selectedPetId,
      );
      
      await widget.onSave(bookingCreate);
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