import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../models/medical_record.dart';
import '../models/pet.dart';
import '../services/api_service.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/cupertino_form_field.dart';
import '../widgets/cupertino_button_primary.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final ApiService _apiService = ApiService();
  List<MedicalRecord> _records = [];
  List<Pet> _pets = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedType = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadRecords(),
      _loadPets(),
    ]);
  }

  Future<void> _loadRecords() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String endpoint;
      
      if (authProvider.isOwner) {
        endpoint = AppConstants.myRecords;
      } else {
        endpoint = AppConstants.medicalRecords;
      }

      final response = await _apiService.get(endpoint);
      
      if (response is List) {
        _records = response.map((json) => MedicalRecord.fromJson(json as Map<String, dynamic>)).toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          final data = response['data'] as List;
          _records = data.map((json) => MedicalRecord.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          _records = [MedicalRecord.fromJson(response)];
        }
      } else {
        _records = [];
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
        }
      }
    } catch (e) {
      // Pets loading is optional for display purposes
    }
  }

  List<MedicalRecord> get _filteredRecords {
    return _records.where((record) {
      final matchesSearch = record.diagnosis.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           record.prescription.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           record.notes.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == 'All' || record.recordType == _selectedType;
      return matchesSearch && matchesType;
    }).toList();
  }

  List<String> get _recordTypes {
    final types = _records.map((record) => record.recordType).toSet().toList();
    types.sort();
    return ['All', ...types];
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
                            authProvider.isOwner ? 'My Pet Records' : 'Medical Records',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Spacer(),
                          if (authProvider.canManageMedicalRecords)
                            CupertinoButton(
                              onPressed: () => _showAddRecordDialog(context, authProvider),
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
                                    'Add Record',
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
                            onPressed: _loadRecords,
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
                                placeholder: 'Search records...',
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
                          
                          // Type Filter
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
                                    title: const Text('Filter by Type'),
                                    actions: _recordTypes.map((type) {
                                      return CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            _selectedType = type;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(type),
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
                                    _selectedType,
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
                    
                    // Records Content
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
              'Error loading records',
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
              onPressed: _loadRecords,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final filteredRecords = _filteredRecords;

    if (filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.doc_text,
              size: 64,
              color: Color(AppConstants.systemGray),
            ),
            const SizedBox(height: 16),
            const Text(
              'No medical records found',
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
                  : authProvider.canManageMedicalRecords
                      ? 'Add your first medical record to get started'
                      : 'No medical records available yet',
              style: const TextStyle(
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            if (_searchQuery.isEmpty && authProvider.canManageMedicalRecords) ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: () => _showAddRecordDialog(context, authProvider),
                child: const Text('Add Your First Record'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(32),
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final record = filteredRecords[index];
        return _MedicalRecordCard(
          record: record,
          authProvider: authProvider,
          pets: _pets,
          onEdit: authProvider.canManageMedicalRecords ? () => _showEditRecordDialog(context, authProvider, record) : null,
          onDelete: authProvider.canManageMedicalRecords ? () => _showDeleteRecordDialog(context, record) : null,
        );
      },
    );
  }

  void _showAddRecordDialog(BuildContext context, AuthProvider authProvider) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _MedicalRecordFormDialog(
        authProvider: authProvider,
        pets: _pets,
        onSave: (recordCreate) async {
          try {
            await _apiService.post(AppConstants.medicalRecords, body: recordCreate.toJson());
            await _loadRecords();
            if (context.mounted) {
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'Medical record added successfully!');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, 'Failed to add record: $e');
            }
          }
        },
      ),
    );
  }

  void _showEditRecordDialog(BuildContext context, AuthProvider authProvider, MedicalRecord record) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _MedicalRecordFormDialog(
        authProvider: authProvider,
        pets: _pets,
        record: record,
        onSave: (recordUpdate) async {
          try {
            await _apiService.put('${AppConstants.medicalRecords}/${record.id}', body: recordUpdate.toJson());
            await _loadRecords();
            if (context.mounted) {
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'Medical record updated successfully!');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, 'Failed to update record: $e');
            }
          }
        },
      ),
    );
  }

  void _showDeleteRecordDialog(BuildContext context, MedicalRecord record) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Medical Record'),
        content: const Text('Are you sure you want to delete this medical record? This action cannot be undone.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await _apiService.delete('${AppConstants.medicalRecords}/${record.id}');
                await _loadRecords();
                if (context.mounted) {
                  _showSuccessDialog(context, 'Medical record deleted successfully!');
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorDialog(context, 'Failed to delete record: $e');
                }
              }
            },
            child: const Text('Delete'),
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

class _MedicalRecordCard extends StatelessWidget {
  final MedicalRecord record;
  final AuthProvider authProvider;
  final List<Pet> pets;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _MedicalRecordCard({
    required this.record,
    required this.authProvider,
    required this.pets,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final pet = pets.firstWhere(
      (p) => p.id == record.petId,
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
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTypeColor(record.recordType).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(record.recordType),
                    color: _getTypeColor(record.recordType),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pet.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(AppConstants.labelColor),
                              ),
                            ),
                          ),
                          _buildTypeBadge(record.recordType),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(record.recordDate),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(AppConstants.secondaryLabelColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Record Details
            _buildDetailSection('Diagnosis', record.diagnosis),
            const SizedBox(height: 12),
            _buildDetailSection('Prescription', record.prescription),
            
            if (record.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailSection('Notes', record.notes),
            ],
            
            if (record.nextMeetingDate.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.calendar,
                    size: 16,
                    color: Color(AppConstants.systemGray),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Next Meeting: ${_formatDate(record.nextMeetingDate)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(AppConstants.primaryBlue),
                    ),
                  ),
                ],
              ),
            ],
            
            // Actions
            if (onEdit != null || onDelete != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (onEdit != null)
                    CupertinoSecondaryButton(
                      onPressed: onEdit,
                      child: const Text('Edit'),
                    ),
                  if (onEdit != null && onDelete != null)
                    const SizedBox(width: 12),
                  if (onDelete != null)
                    CupertinoDestructiveButton(
                      onPressed: onDelete,
                      child: const Text('Delete'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.systemGray),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Color(AppConstants.labelColor),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge(String type) {
    final color = _getTypeColor(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'CHECKUP':
        return const Color(AppConstants.primaryBlue);
      case 'VACCINATION':
        return const Color(0xFF34C759); // Green
      case 'SURGERY':
        return const Color(AppConstants.systemRed);
      case 'TREATMENT':
        return const Color(0xFFFF9500); // Orange
      case 'EMERGENCY':
        return const Color(0xFFFF3B30); // Red
      default:
        return const Color(AppConstants.systemGray);
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'CHECKUP':
        return CupertinoIcons.checkmark_shield;
      case 'VACCINATION':
        return CupertinoIcons.heart_fill;
      case 'SURGERY':
        return CupertinoIcons.scissors;
      case 'TREATMENT':
        return CupertinoIcons.bandage;
      case 'EMERGENCY':
        return CupertinoIcons.exclamationmark_triangle_fill;
      default:
        return CupertinoIcons.doc_text;
    }
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

class _MedicalRecordFormDialog extends StatefulWidget {
  final AuthProvider authProvider;
  final List<Pet> pets;
  final MedicalRecord? record;
  final Function(dynamic) onSave;

  const _MedicalRecordFormDialog({
    required this.authProvider,
    required this.pets,
    this.record,
    required this.onSave,
  });

  @override
  State<_MedicalRecordFormDialog> createState() => _MedicalRecordFormDialogState();
}

class _MedicalRecordFormDialogState extends State<_MedicalRecordFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _recordType = 'CHECKUP';
  DateTime? _nextMeetingDate;
  int? _selectedPetId;
  bool _isLoading = false;

  final List<String> _recordTypes = ['CHECKUP', 'VACCINATION', 'SURGERY', 'TREATMENT', 'EMERGENCY'];

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _diagnosisController.text = widget.record!.diagnosis;
      _prescriptionController.text = widget.record!.prescription;
      _notesController.text = widget.record!.notes;
      _recordType = widget.record!.recordType;
      _selectedPetId = widget.record!.petId;
      try {
        if (widget.record!.nextMeetingDate.isNotEmpty) {
          _nextMeetingDate = DateTime.parse(widget.record!.nextMeetingDate);
        }
      } catch (e) {
        // Ignore date parsing errors
      }
    }
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _prescriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(AppConstants.systemGray6),
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.record == null ? 'Add Medical Record' : 'Edit Medical Record'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : _saveRecord,
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
              
              // Record Type Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Record Type',
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
                            title: const Text('Select Record Type'),
                            actions: _recordTypes.map((type) {
                              return CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() {
                                    _recordType = type;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(type),
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
                            _recordType,
                            style: const TextStyle(
                              color: Color(AppConstants.labelColor),
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
              
              // Diagnosis
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Diagnosis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoFormField(
                    controller: _diagnosisController,
                    placeholder: 'Enter diagnosis',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Diagnosis is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Prescription
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prescription',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoFormField(
                    controller: _prescriptionController,
                    placeholder: 'Enter prescription',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Prescription is required';
                      }
                      return null;
                    },
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
                    placeholder: 'Additional notes...',
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Next Meeting Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Next Meeting Date (Optional)',
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
                                            _nextMeetingDate = null;
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
                                    initialDateTime: _nextMeetingDate ?? DateTime.now().add(const Duration(days: 7)),
                                    minimumDate: DateTime.now(),
                                    onDateTimeChanged: (date) {
                                      setState(() {
                                        _nextMeetingDate = date;
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
                            _nextMeetingDate != null
                                ? DateFormat('MMM dd, yyyy').format(_nextMeetingDate!)
                                : 'Select next meeting date (optional)',
                            style: TextStyle(
                              color: _nextMeetingDate != null
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
            ],
          ),
        ),
      ),
    );
  }

  void _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedPetId == null) {
      _showErrorDialog('Please select a pet');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final nextMeetingDateString = _nextMeetingDate != null 
          ? DateFormat('yyyy-MM-dd').format(_nextMeetingDate!) 
          : '';
      
      if (widget.record == null) {
        // Create new record
        final recordCreate = MedicalRecordCreate(
          diagnosis: _diagnosisController.text.trim(),
          prescription: _prescriptionController.text.trim(),
          notes: _notesController.text.trim(),
          nextMeetingDate: nextMeetingDateString,
          recordType: _recordType,
          petId: _selectedPetId!,
          userId: widget.authProvider.currentUser?.id ?? 0,
        );
        await widget.onSave(recordCreate);
      } else {
        // Update existing record
        final recordUpdate = MedicalRecordUpdate(
          diagnosis: _diagnosisController.text.trim(),
          prescription: _prescriptionController.text.trim(),
          notes: _notesController.text.trim(),
          nextMeetingDate: nextMeetingDateString,
          recordType: _recordType,
        );
        await widget.onSave(recordUpdate);
      }
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