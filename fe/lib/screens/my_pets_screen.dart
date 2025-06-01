import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../models/pet.dart';
import '../models/medical_record.dart';
import '../services/api_service.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/cupertino_form_field.dart';
import '../widgets/cupertino_button_primary.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  final ApiService _apiService = ApiService();
  List<Pet> _pets = [];
  Pet? _selectedPet;
  final Map<int, List<MedicalRecord>> _petMedicalRecords = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> _loadPets() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _apiService.get(AppConstants.myPets);
      
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

      // Auto-select first pet if available
      if (_pets.isNotEmpty && _selectedPet == null) {
        _selectedPet = _pets.first;
        _loadMedicalRecords(_selectedPet!.id);
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

  Future<void> _loadMedicalRecords(int petId) async {
    try {
      final response = await _apiService.get('${AppConstants.recordsByPet}/$petId');
      
      List<MedicalRecord> records = [];
      if (response is List) {
        records = response.map((json) => MedicalRecord.fromJson(json as Map<String, dynamic>)).toList();
      } else if (response is Map<String, dynamic> && response.containsKey('data')) {
          final data = response['data'] as List;
          records = data.map((json) => MedicalRecord.fromJson(json as Map<String, dynamic>)).toList();
      }

      setState(() {
        _petMedicalRecords[petId] = records;
      });
    } catch (e) {
      debugPrint('Error loading medical records for pet $petId: $e');
      setState(() {
        _petMedicalRecords[petId] = [];
      });
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
                                  'My Pets',
                                  style: TextStyle(
                              fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: Color(AppConstants.labelColor),
                                  ),
                                ),
                                const Spacer(),
                                CupertinoButton(
                                  onPressed: () => _showAddPetDialog(context, authProvider),
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
                                  'Add Pet',
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
                            onPressed: _loadPets,
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
              'Error loading pets',
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
              onPressed: _loadPets,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_pets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.paw,
              size: 64,
              color: Color(AppConstants.systemGray),
            ),
            const SizedBox(height: 16),
            const Text(
              'No pets found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.labelColor),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first pet to get started',
              style: TextStyle(
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: () => _showAddPetDialog(context, Provider.of<AuthProvider>(context, listen: false)),
                child: const Text('Add Your First Pet'),
              ),
          ],
        ),
      );
    }

    return Row(
      children: [
        // Pets List (Left Panel)
        Container(
          width: 300,
          decoration: const BoxDecoration(
            color: Color(AppConstants.systemGray6),
            border: Border(
              right: BorderSide(
                color: Color(AppConstants.systemGray4),
                width: 1,
              ),
            ),
          ),
          child: _buildPetsList(),
        ),
        
        // Pet Details (Right Panel)
        Expanded(
          child: _buildPetDetails(),
        ),
      ],
    );
  }

  Widget _buildPetsList() {
    return Column(
      children: [
        // Pets List Header
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: CupertinoColors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(AppConstants.systemGray4),
                width: 1,
              ),
            ),
          ),
          child: const Row(
            children: [
              Text(
                'Your Pets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(AppConstants.labelColor),
                ),
              ),
            ],
          ),
        ),
        
        // Pets List Content
        Expanded(
          child: ListView.builder(
      padding: const EdgeInsets.all(16),
            itemCount: _pets.length,
      itemBuilder: (context, index) {
              final pet = _pets[index];
        final isSelected = _selectedPet?.id == pet.id;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                _selectedPet = pet;
              });
              _loadMedicalRecords(pet.id);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected 
                          ? const Color(AppConstants.primaryBlue).withValues(alpha: 0.1)
                    : CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected 
                      ? const Color(AppConstants.primaryBlue)
                      : const Color(AppConstants.systemGray5),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? const Color(AppConstants.primaryBlue)
                                : const Color(AppConstants.labelColor),
                          ),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.paw,
                        size: 16,
                        color: isSelected 
                            ? const Color(AppConstants.primaryBlue)
                            : const Color(AppConstants.systemGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pet.species} • ${pet.gender}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(AppConstants.secondaryLabelColor),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                          'Born: ${DateFormat('MMM dd, yyyy').format(_parseDate(pet.birthDate))}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(AppConstants.secondaryLabelColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
          ),
        ),
      ],
    );
  }

  Widget _buildPetDetails() {
    if (_selectedPet == null) {
      return Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.white,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.paw,
                size: 64,
                color: Color(AppConstants.systemGray),
              ),
              SizedBox(height: 16),
              Text(
                'Select a pet to view details',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(AppConstants.secondaryLabelColor),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final pet = _selectedPet!;
    final medicalRecords = _petMedicalRecords[pet.id] ?? [];

    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
      ),
      child: Column(
        children: [
          // Pet Details Header
          Container(
            height: AppConstants.headerHeight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
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
                  pet.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(AppConstants.labelColor),
                  ),
                ),
                const Spacer(),
                CupertinoButton(
                  onPressed: () => _showEditPetDialog(context, Provider.of<AuthProvider>(context, listen: false), pet),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.pencil,
                        size: 16,
                        color: Color(AppConstants.primaryBlue),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Color(AppConstants.primaryBlue),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CupertinoButton(
                  onPressed: () => _showDeletePetDialog(context, pet),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.delete,
                        size: 16,
                        color: Color(AppConstants.systemRed),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Color(AppConstants.systemRed),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Pet Details & Medical Records Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet Information Section
                  _buildPetInfoSection(pet),
                  
                  const SizedBox(height: 32),
                  
                  // Medical Records Section
                  _buildMedicalRecordsSection(pet, medicalRecords),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetInfoSection(Pet pet) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(AppConstants.systemGray6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pet Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(AppConstants.labelColor),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Species', pet.species),
          _buildInfoRow('Gender', pet.gender),
          _buildInfoRow('Color', pet.color),
          _buildInfoRow('Birth Date', DateFormat('MMMM dd, yyyy').format(_parseDate(pet.birthDate))),
          _buildInfoRow('Age', _calculateAge(_parseDate(pet.birthDate))),
          if (pet.healthInfo.isNotEmpty)
            _buildInfoRow('Health Info', pet.healthInfo),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(AppConstants.labelColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalRecordsSection(Pet pet, List<MedicalRecord> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Medical Records',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.labelColor),
              ),
            ),
            const Spacer(),
            CupertinoButton(
              onPressed: () => _loadMedicalRecords(pet.id),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.refresh,
                    size: 16,
                    color: Color(AppConstants.primaryBlue),
                  ),
                  SizedBox(width: 4),
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
        const SizedBox(height: 16),
        
        if (records.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(AppConstants.systemGray6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    size: 48,
                    color: Color(AppConstants.systemGray),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No medical records found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(AppConstants.secondaryLabelColor),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Medical records will appear here when added by veterinarians',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(AppConstants.secondaryLabelColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...records.map((record) => _buildMedicalRecordCard(record)),
      ],
    );
  }

  Widget _buildMedicalRecordCard(MedicalRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(AppConstants.systemGray5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.doc_text,
                size: 16,
                color: Color(AppConstants.primaryBlue),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMM dd, yyyy').format(_parseDate(record.recordDate)),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(AppConstants.labelColor),
                ),
              ),
              const Spacer(),
              if (record.nextMeetingDate.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(AppConstants.primaryBlue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Next: ${DateFormat('MMM dd').format(_parseDate(record.nextMeetingDate))}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(AppConstants.primaryBlue),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (record.diagnosis.isNotEmpty) ...[
            const Text(
              'Diagnosis',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              record.diagnosis,
              style: const TextStyle(
                fontSize: 14,
                color: Color(AppConstants.labelColor),
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          if (record.prescription.isNotEmpty) ...[
            const Text(
              'Prescription',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              record.prescription,
              style: const TextStyle(
                fontSize: 14,
                color: Color(AppConstants.labelColor),
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          if (record.notes.isNotEmpty) ...[
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              record.notes,
              style: const TextStyle(
                fontSize: 14,
                color: Color(AppConstants.labelColor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.difference(birthDate);
    final years = age.inDays ~/ 365;
    final months = (age.inDays % 365) ~/ 30;
    
    if (years > 0) {
      return months > 0 ? '$years years, $months months' : '$years years';
    } else if (months > 0) {
      return '$months months';
    } else {
      final days = age.inDays;
      return '$days days';
    }
  }

  void _showAddPetDialog(BuildContext context, AuthProvider authProvider) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _PetFormDialog(
        authProvider: authProvider,
        onSave: (petCreate) async {
          try {
            await _apiService.post(AppConstants.pets, body: petCreate.toJson());
            await _loadPets();
            if (context.mounted) {
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'Pet added successfully!');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, 'Failed to add pet: $e');
            }
          }
        },
      ),
    );
  }

  void _showEditPetDialog(BuildContext context, AuthProvider authProvider, Pet pet) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _PetFormDialog(
        authProvider: authProvider,
        pet: pet,
        onSave: (petUpdate) async {
          try {
            await _apiService.put('${AppConstants.pets}/${pet.id}', body: petUpdate.toJson());
            await _loadPets();
            // Refresh selected pet details
            if (_selectedPet?.id == pet.id) {
              final updatedPets = _pets.where((p) => p.id == pet.id);
              if (updatedPets.isNotEmpty) {
                setState(() {
                  _selectedPet = updatedPets.first;
                });
              }
            }
            if (context.mounted) {
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'Pet updated successfully!');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, 'Failed to update pet: $e');
            }
          }
        },
      ),
    );
  }

  void _showDeletePetDialog(BuildContext context, Pet pet) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Delete ${pet.name}'),
        content: const Text('Are you sure you want to delete this pet? This action cannot be undone.'),
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
                await _apiService.delete('${AppConstants.pets}/${pet.id}');
                await _loadPets();
                // Clear selection if deleted pet was selected
                if (_selectedPet?.id == pet.id) {
                  setState(() {
                    _selectedPet = null;
                  });
                }
                if (context.mounted) {
                  _showSuccessDialog(context, 'Pet deleted successfully!');
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorDialog(context, 'Failed to delete pet: $e');
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

// Pet Form Dialog for Add/Edit
class _PetFormDialog extends StatefulWidget {
  final AuthProvider authProvider;
  final Pet? pet;
  final Function(dynamic) onSave;

  const _PetFormDialog({
    required this.authProvider,
    this.pet,
    required this.onSave,
  });

  @override
  State<_PetFormDialog> createState() => _PetFormDialogState();
}

class _PetFormDialogState extends State<_PetFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _colorController = TextEditingController();
  final _healthInfoController = TextEditingController();
  
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 365));
  String _gender = 'MALE';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _speciesController.text = widget.pet!.species;
      _colorController.text = widget.pet!.color;
      _healthInfoController.text = widget.pet!.healthInfo;
      _gender = widget.pet!.gender;
      try {
        _birthDate = DateTime.parse(widget.pet!.birthDate);
      } catch (e) {
        _birthDate = DateTime.now().subtract(const Duration(days: 365));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _colorController.dispose();
    _healthInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(AppConstants.systemGray6),
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.pet == null ? 'Add Pet' : 'Edit Pet'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : _savePet,
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
              // Pet Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pet Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                CupertinoFormField(
                  controller: _nameController,
                  placeholder: 'Enter pet name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pet name is required';
                      }
                      return null;
                    },
                  ),
                ],
                ),
                const SizedBox(height: 16),
                
              // Species
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Species',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                CupertinoFormField(
                  controller: _speciesController,
                  placeholder: 'e.g., Dog, Cat, Bird',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Species is required';
                      }
                      return null;
                    },
                  ),
                ],
                ),
                const SizedBox(height: 16),
                
              // Color
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                CupertinoFormField(
                  controller: _colorController,
                    placeholder: 'e.g., Brown, Black, White',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Color is required';
                      }
                      return null;
                    },
                  ),
                ],
                ),
                const SizedBox(height: 16),
                
                // Gender Selection
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(AppConstants.labelColor),
                        ),
                      ),
                  const SizedBox(height: 8),
                      CupertinoSegmentedControl<String>(
                        children: const {
                          'MALE': Text('Male'),
                          'FEMALE': Text('Female'),
                        },
                        groupValue: _gender,
                        onValueChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ],
                ),
                const SizedBox(height: 16),
                
                // Birth Date
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Birth Date',
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
                          initialDateTime: _birthDate,
                          maximumDate: DateTime.now(),
                          onDateTimeChanged: (date) {
                            setState(() {
                              _birthDate = date;
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
                            DateFormat('MMM dd, yyyy').format(_birthDate),
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
                
              // Health Information
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.labelColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                CupertinoFormField(
                  controller: _healthInfoController,
                    placeholder: 'Any health conditions or notes (optional)',
                  maxLines: 3,
                ),
                ],
              ),
              
                const SizedBox(height: 32),
                
                CupertinoPrimaryButton(
                  onPressed: _savePet,
                child: Text(widget.pet == null ? 'Add Pet' : 'Update Pet'),
                ),
              ],
          ),
        ),
      ),
    );
  }

  void _savePet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final birthDateString = DateFormat('yyyy-MM-dd').format(_birthDate);
      
      if (widget.pet == null) {
        // Create new pet
    final petCreate = PetCreate(
      name: _nameController.text.trim(),
          birthDate: birthDateString,
      gender: _gender,
      species: _speciesController.text.trim(),
      color: _colorController.text.trim(),
      healthInfo: _healthInfoController.text.trim(),
          userId: widget.authProvider.currentUser?.id ?? 0,
    );
        await widget.onSave(petCreate);
      } else {
        // Update existing pet
        final petUpdate = PetUpdate(
          name: _nameController.text.trim(),
          birthDate: birthDateString,
          gender: _gender,
          species: _speciesController.text.trim(),
          color: _colorController.text.trim(),
          healthInfo: _healthInfoController.text.trim(),
          userId: widget.pet!.userId,
        );
        await widget.onSave(petUpdate);
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
}

// Pet Create Model
class PetCreate {
  final String name;
  final String birthDate;
  final String gender;
  final String species;
  final String color;
  final String healthInfo;
  final int userId;

  PetCreate({
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.species,
    required this.color,
    required this.healthInfo,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birth_date': birthDate,
      'gender': gender,
      'species': species,
      'color': color,
      'health_info': healthInfo,
      'user_id': userId,
    };
  }
}

// Pet Update Model
class PetUpdate {
  final String name;
  final String birthDate;
  final String gender;
  final String species;
  final String color;
  final String healthInfo;
  final int userId;

  PetUpdate({
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.species,
    required this.color,
    required this.healthInfo,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birth_date': birthDate,
      'gender': gender,
      'species': species,
      'color': color,
      'health_info': healthInfo,
      'user_id': userId,
    };
  }
} 