import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../models/cage.dart';
import '../models/pet.dart';
import '../services/api_service.dart';
import '../widgets/sidebar_navigation.dart';

class CagesScreen extends StatefulWidget {
  const CagesScreen({super.key});

  @override
  State<CagesScreen> createState() => _CagesScreenState();
}

class _CagesScreenState extends State<CagesScreen> {
  final ApiService _apiService = ApiService();
  List<Cage> _cages = [];
  List<Pet> _pets = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedType = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadCages(),
      _loadPets(),
    ]);
  }

  Future<void> _loadCages() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _apiService.get(AppConstants.cages);
      
      if (response is List) {
        _cages = response.map((json) => Cage.fromJson(json as Map<String, dynamic>)).toList();
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          final data = response['data'] as List;
          _cages = data.map((json) => Cage.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          _cages = [Cage.fromJson(response)];
        }
      } else {
        _cages = [];
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
      final response = await _apiService.get(AppConstants.pets);
      
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

  List<Cage> get _filteredCages {
    return _cages.where((cage) {
      final matchesSearch = cage.type.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           cage.size.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'All' || cage.status == _selectedStatus;
      final matchesType = _selectedType == 'All' || cage.type == _selectedType;
      return matchesSearch && matchesStatus && matchesType;
    }).toList();
  }

  List<String> get _statuses {
    final statuses = _cages.map((cage) => cage.status).toSet().toList();
    statuses.sort();
    return ['All', ...statuses];
  }

  List<String> get _types {
    final types = _cages.map((cage) => cage.type).toSet().toList();
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
                          const Text(
                            'Cage Management',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.labelColor),
                            ),
                          ),
                          const Spacer(),
                          CupertinoButton(
                            onPressed: () => _showAddCageDialog(context, authProvider),
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
                                  'Add Cage',
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
                            onPressed: _loadCages,
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
                                placeholder: 'Search cages...',
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
                              onPressed: () => _showFilterDialog('Status', _statuses, _selectedStatus, (value) {
                                setState(() {
                                  _selectedStatus = value;
                                });
                              }),
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
                              onPressed: () => _showFilterDialog('Type', _types, _selectedType, (value) {
                                setState(() {
                                  _selectedType = value;
                                });
                              }),
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
                    
                    // Cages Content
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
              'Error loading cages',
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
              onPressed: _loadCages,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final filteredCages = _filteredCages;

    if (filteredCages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.building_2_fill,
              size: 64,
              color: Color(AppConstants.systemGray),
            ),
            const SizedBox(height: 16),
            const Text(
              'No cages found',
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
                  : 'Add your first cage to get started',
              style: const TextStyle(
                color: Color(AppConstants.secondaryLabelColor),
              ),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: () => _showAddCageDialog(context, authProvider),
                child: const Text('Add Your First Cage'),
              ),
            ],
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredCages.length,
      itemBuilder: (context, index) {
        final cage = filteredCages[index];
        return _CageCard(
          cage: cage,
          pets: _pets,
          onEdit: () => _showEditCageDialog(context, authProvider, cage),
          onDelete: () => _showDeleteCageDialog(context, cage),
          onAssignPet: () => _showAssignPetDialog(context, cage),
        );
      },
    );
  }

  void _showFilterDialog(String title, List<String> options, String selected, Function(String) onSelect) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Filter by $title'),
        actions: options.map((option) {
          return CupertinoActionSheetAction(
            onPressed: () {
              onSelect(option);
              Navigator.pop(context);
            },
            child: Text(option),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showAddCageDialog(BuildContext context, AuthProvider authProvider) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _CageFormDialog(
        pets: _pets,
        onSave: (cageCreate) async {
          try {
            await _apiService.post(AppConstants.cages, body: cageCreate.toJson());
            await _loadCages();
            if (context.mounted) {
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'Cage added successfully!');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, 'Failed to add cage: $e');
            }
          }
        },
      ),
    );
  }

  void _showEditCageDialog(BuildContext context, AuthProvider authProvider, Cage cage) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _CageFormDialog(
        cage: cage,
        pets: _pets,
        onSave: (cageUpdate) async {
          try {
            await _apiService.put('${AppConstants.cages}/${cage.id}', body: cageUpdate.toJson());
            await _loadCages();
            if (context.mounted) {
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'Cage updated successfully!');
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, 'Failed to update cage: $e');
            }
          }
        },
      ),
    );
  }

  void _showDeleteCageDialog(BuildContext context, Cage cage) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Cage'),
        content: const Text('Are you sure you want to delete this cage? This action cannot be undone.'),
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
                await _apiService.delete('${AppConstants.cages}/${cage.id}');
                await _loadCages();
                if (context.mounted) {
                  _showSuccessDialog(context, 'Cage deleted successfully!');
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorDialog(context, 'Failed to delete cage: $e');
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAssignPetDialog(BuildContext context, Cage cage) {
    final availablePets = _pets.where((pet) => 
      !_cages.any((c) => c.petId == pet.id && c.status == 'OCCUPIED')
    ).toList();

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Assign Pet to Cage'),
        actions: [
          if (cage.petId != null)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final updatedCage = CageUpdate(
                    type: cage.type,
                    size: cage.size,
                    status: 'AVAILABLE',
                    startDate: '',
                    endDate: '',
                    petId: null,
                  );
                  await _apiService.put('${AppConstants.cages}/${cage.id}', body: updatedCage.toJson());
                  await _loadCages();
                  if (context.mounted) {
                    _showSuccessDialog(context, 'Pet removed from cage successfully!');
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showErrorDialog(context, 'Failed to remove pet: $e');
                  }
                }
              },
              child: const Text('Remove Current Pet'),
            ),
          ...availablePets.map((pet) {
            return CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final updatedCage = CageUpdate(
                    type: cage.type,
                    size: cage.size,
                    status: 'OCCUPIED',
                    startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    endDate: '',
                    petId: pet.id,
                  );
                  await _apiService.put('${AppConstants.cages}/${cage.id}', body: updatedCage.toJson());
                  await _loadCages();
                  if (context.mounted) {
                    _showSuccessDialog(context, 'Pet assigned to cage successfully!');
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showErrorDialog(context, 'Failed to assign pet: $e');
                  }
                }
              },
              child: Text('${pet.name} (${pet.species})'),
            );
          }),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
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

class _CageCard extends StatelessWidget {
  final Cage cage;
  final List<Pet> pets;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAssignPet;

  const _CageCard({
    required this.cage,
    required this.pets,
    required this.onEdit,
    required this.onDelete,
    required this.onAssignPet,
  });

  @override
  Widget build(BuildContext context) {
    final pet = cage.petId != null 
        ? pets.firstWhere(
            (p) => p.id == cage.petId,
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
          )
        : null;

    return Container(
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
        padding: const EdgeInsets.all(20),
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
                    color: _getStatusColor(cage.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    CupertinoIcons.building_2_fill,
                    color: _getStatusColor(cage.status),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${cage.type} Cage',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(AppConstants.labelColor),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cage.size,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(AppConstants.secondaryLabelColor),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(cage.status),
              ],
            ),
            const SizedBox(height: 16),
            
            // Pet Information
            if (pet != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(AppConstants.systemGray6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Pet:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(AppConstants.systemGray),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(AppConstants.labelColor),
                      ),
                    ),
                    Text(
                      pet.species,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(AppConstants.secondaryLabelColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(AppConstants.systemGray6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'No pet assigned',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(AppConstants.systemGray),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            // Action Buttons
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: const Color(AppConstants.primaryBlue),
                    borderRadius: BorderRadius.circular(8),
                    onPressed: onAssignPet,
                    child: Text(
                      pet != null ? 'Reassign' : 'Assign Pet',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: onEdit,
                  child: const Icon(
                    CupertinoIcons.pencil,
                    color: Color(AppConstants.primaryBlue),
                    size: 16,
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: onDelete,
                  child: const Icon(
                    CupertinoIcons.trash,
                    color: Color(AppConstants.systemRed),
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'AVAILABLE':
        return const Color(0xFF34C759); // Green
      case 'OCCUPIED':
        return const Color(AppConstants.primaryBlue);
      case 'CLEANING':
        return const Color(0xFFFF9500); // Orange
      case 'MAINTENANCE':
        return const Color(AppConstants.systemRed);
      default:
        return const Color(AppConstants.systemGray);
    }
  }
}

class _CageFormDialog extends StatefulWidget {
  final Cage? cage;
  final List<Pet> pets;
  final Function(dynamic) onSave;

  const _CageFormDialog({
    this.cage,
    required this.pets,
    required this.onSave,
  });

  @override
  State<_CageFormDialog> createState() => _CageFormDialogState();
}

class _CageFormDialogState extends State<_CageFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  String _type = 'DOG';
  String _size = 'Medium';
  String _status = 'AVAILABLE';
  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedPetId;
  bool _isLoading = false;

  final List<String> _types = ['DOG', 'CAT'];
  final List<String> _sizes = ['Small', 'Medium', 'Large'];
  final List<String> _statuses = ['AVAILABLE', 'OCCUPIED', 'CLEANING', 'MAINTENANCE'];

  @override
  void initState() {
    super.initState();
    if (widget.cage != null) {
      _type = widget.cage!.type;
      _size = widget.cage!.size;
      _status = widget.cage!.status;
      _selectedPetId = widget.cage!.petId;
      try {
        if (widget.cage!.startDate.isNotEmpty) {
          _startDate = DateTime.parse(widget.cage!.startDate);
        }
        if (widget.cage!.endDate.isNotEmpty) {
          _endDate = DateTime.parse(widget.cage!.endDate);
        }
      } catch (e) {
        // Ignore date parsing errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(AppConstants.systemGray6),
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.cage == null ? 'Add Cage' : 'Edit Cage'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : _saveCage,
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
              // Type Selection
              _buildSelectionField(
                'Type',
                _type,
                _types,
                (value) => setState(() => _type = value),
              ),
              const SizedBox(height: 16),
              
              // Size Selection
              _buildSelectionField(
                'Size',
                _size,
                _sizes,
                (value) => setState(() => _size = value),
              ),
              const SizedBox(height: 16),
              
              // Status Selection
              _buildSelectionField(
                'Status',
                _status,
                _statuses,
                (value) => setState(() => _status = value),
              ),
              const SizedBox(height: 16),
              
              // Pet Selection (if status is OCCUPIED)
              if (_status == 'OCCUPIED') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assigned Pet',
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
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionField(String label, String value, List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
                  title: Text('Select $label'),
                  actions: options.map((option) {
                    return CupertinoActionSheetAction(
                      onPressed: () {
                        onChanged(option);
                        Navigator.pop(context);
                      },
                      child: Text(option),
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
                  value,
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
    );
  }

  void _saveCage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final startDateString = _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : '';
      final endDateString = _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '';
      
      if (widget.cage == null) {
        // Create new cage
        final cageCreate = CageCreate(
          type: _type,
          size: _size,
          status: _status,
          startDate: startDateString,
          endDate: endDateString,
          petId: _selectedPetId,
        );
        await widget.onSave(cageCreate);
      } else {
        // Update existing cage
        final cageUpdate = CageUpdate(
          type: _type,
          size: _size,
          status: _status,
          startDate: startDateString,
          endDate: endDateString,
          petId: _selectedPetId,
        );
        await widget.onSave(cageUpdate);
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