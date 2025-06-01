import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../models/pet.dart';
import '../services/api_service.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/cupertino_form_field.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final ApiService _apiService = ApiService();
  List<Pet> _pets = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

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
          // If response is a single pet object, wrap it in a list
          _pets = [Pet.fromJson(response)];
        }
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

  List<Pet> get _filteredPets {
    return _pets.where((pet) {
      final matchesSearch = pet.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           pet.species.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           pet.color.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
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
                            authProvider.isOwner ? 'My Pets' : 'All Pets',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Spacer(),
                          if (authProvider.isOwner || authProvider.canManageUsers)
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
                    
                    // Search Bar
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(AppConstants.systemGray6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CupertinoTextField(
                          placeholder: 'Search pets by name, species, or color...',
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
                    
                    // Content
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

    final filteredPets = _filteredPets;

    if (filteredPets.isEmpty) {
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
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : authProvider.isOwner
                      ? 'Add your first pet to get started'
                      : 'No pets in the system yet',
              style: const TextStyle(
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            if (_searchQuery.isEmpty && authProvider.isOwner) ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: () => _showAddPetDialog(context, authProvider),
                child: const Text('Add Your First Pet'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(32),
      itemCount: filteredPets.length,
      itemBuilder: (context, index) {
        final pet = filteredPets[index];
        return _PetCard(
          pet: pet,
          authProvider: authProvider,
          onEdit: () => _showEditPetDialog(context, authProvider, pet),
          onDelete: () => _showDeletePetDialog(context, pet),
        );
      },
    );
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

class _PetCard extends StatelessWidget {
  final Pet pet;
  final AuthProvider authProvider;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PetCard({
    required this.pet,
    required this.authProvider,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(pet.birthDate);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withAlpha(25), // 0.1 opacity
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            // Pet Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(AppConstants.primaryBlue).withAlpha(25), // 0.1 opacity
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                CupertinoIcons.paw,
                color: Color(AppConstants.primaryBlue),
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            
            // Pet Info
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
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(AppConstants.labelColor),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: pet.gender == 'MALE'
                              ? const Color(AppConstants.primaryBlue).withAlpha(25) // 0.1 opacity
                              : const Color(0xFFFF69B4).withAlpha(25), // 0.1 opacity
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          pet.gender,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: pet.gender == 'MALE'
                                ? const Color(AppConstants.primaryBlue)
                                : const Color(0xFFFF69B4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(pet.species, CupertinoIcons.paw),
                      const SizedBox(width: 12),
                      _buildInfoChip(pet.color, CupertinoIcons.circle_fill),
                      const SizedBox(width: 12),
                      _buildInfoChip(age, CupertinoIcons.calendar),
                    ],
                  ),
                  if (pet.healthInfo.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Health Info: ${pet.healthInfo}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(AppConstants.secondaryLabelColor),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Actions
            if (authProvider.isOwner || authProvider.canManageUsers) ...[
              const SizedBox(width: 16),
              Column(
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: onEdit,
                    child: const Icon(
                      CupertinoIcons.pencil,
                      color: Color(AppConstants.primaryBlue),
                      size: 20,
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: onDelete,
                    child: const Icon(
                      CupertinoIcons.trash,
                      color: Color(AppConstants.systemRed),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(AppConstants.systemGray5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: const Color(AppConstants.systemGray),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(AppConstants.secondaryLabelColor),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAge(String birthDate) {
    try {
      final birth = DateTime.parse(birthDate);
      final now = DateTime.now();
      final age = now.difference(birth).inDays ~/ 365;
      return age == 0 ? '<1 year' : '$age year${age == 1 ? '' : 's'}';
    } catch (e) {
      return 'Unknown';
    }
  }
}

class _PetFormDialog extends StatefulWidget {
  final AuthProvider authProvider;
  final Pet? pet;
  final Function(dynamic) onSave; // Can be PetCreate or PetUpdate

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
  
  DateTime? _birthDate; // Nullable for initial state
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
        _birthDate = null; // Handle parsing error, default to null
      }
    } else {
      _birthDate = DateTime.now().subtract(const Duration(days: 365)); // Default for new pet
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

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(AppConstants.primaryBlue), // header background color
              onPrimary: CupertinoColors.white, // header text color
              onSurface: Color(AppConstants.labelColor), // body text color
            ),
            dialogBackgroundColor: CupertinoColors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
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
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                      onPressed: () => _selectBirthDate(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _birthDate == null 
                                ? 'Select birth date' 
                                : DateFormat('MMM dd, yyyy').format(_birthDate!),
                            style: TextStyle(
                              color: _birthDate == null 
                                  ? const Color(AppConstants.placeholderTextColor)
                                  : const Color(AppConstants.labelColor),
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
            ],
          ),
        ),
      ),
    );
  }

  void _savePet() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      // Show an error or prompt to select birth date
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Missing Information'),
          content: const Text('Please select a birth date for the pet.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }


    setState(() {
      _isLoading = true;
    });

    try {
      final birthDateString = DateFormat('yyyy-MM-dd').format(_birthDate!);
      
      if (widget.pet == null) {
        // Create new pet
        final petCreate = PetCreate(
          name: _nameController.text.trim(),
          birthDate: birthDateString,
          gender: _gender,
          species: _speciesController.text.trim(),
          color: _colorController.text.trim(),
          healthInfo: _healthInfoController.text.trim(),
          userId: widget.authProvider.currentUser?.id ?? 0, // Ensure current user ID is available
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
          userId: widget.pet!.userId, // userId should not change on update from client
        );
        await widget.onSave(petUpdate);
      }
    } catch (e) {
      // Error handling is done in the parent, so no need to setState for error message here
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 