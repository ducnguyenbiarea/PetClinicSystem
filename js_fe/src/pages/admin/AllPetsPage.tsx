import React, { useState, useEffect } from 'react';
import {
  Box,
  Paper,
  Typography,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Alert,
  CircularProgress,
  Stack,
  Tooltip,
  Chip,
  Card,
  CardContent,
  Grid,
  Avatar,
} from '@mui/material';
import {
  Add,
  Edit,
  Delete,
  Pets,
  Person,
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import dayjs from 'dayjs';
import apiService from '../../services/api';
import useAuthStore from '../../stores/authStore';
import type { Pet, PetCreateRequest } from '../../types/api';
import type { User } from '../../types/auth';

const AllPetsPage: React.FC = () => {
  const { user: currentUser, isAdmin, isStaff, isOwner } = useAuthStore();
  const [pets, setPets] = useState<Pet[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingPet, setEditingPet] = useState<Pet | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [petToDelete, setPetToDelete] = useState<Pet | null>(null);

  const [formData, setFormData] = useState<PetCreateRequest>({
    name: '',
    birth_date: dayjs().format('YYYY-MM-DD'),
    gender: 'MALE',
    species: '',
    color: '',
    health_info: '',
    user_id: currentUser?.id || 0,
  });

  const genderOptions = [
    { value: 'MALE', label: 'Male' },
    { value: 'FEMALE', label: 'Female' },
  ];

  const speciesOptions = [
    'Dog', 'Cat', 'Rabbit', 'Bird', 'Hamster', 'Guinea Pig', 'Fish', 'Reptile', 'Other'
  ];

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Load pets based on user role
      let petsData: Pet[];
      if (isOwner()) {
        petsData = await apiService.getMyPets();
      } else {
        petsData = await apiService.getAllPets();
      }
      
      // Load users for pet ownership info
      let usersData: User[] = [];
      if (!isOwner()) {
        usersData = await apiService.getAllUsers();
      }
      
      setPets(petsData);
      setUsers(usersData);
    } catch (err: any) {
      setError(err.message || 'Failed to load pets');
    } finally {
      setLoading(false);
    }
  };

  const getOwnerName = (userId: number) => {
    const user = users.find(u => u.id === userId);
    return user?.user_name || 'Unknown Owner';
  };

  const formatDate = (dateString: string) => {
    try {
      return dayjs(dateString).format('MMM DD, YYYY');
    } catch {
      return dateString;
    }
  };

  const calculateAge = (birthDate: string) => {
    try {
      const birth = dayjs(birthDate);
      const today = dayjs();
      const ageInMonths = (today.year() - birth.year()) * 12 + (today.month() - birth.month());
      
      if (ageInMonths < 12) {
        return `${ageInMonths} month${ageInMonths !== 1 ? 's' : ''}`;
      } else {
        const years = Math.floor(ageInMonths / 12);
        return `${years} year${years !== 1 ? 's' : ''}`;
      }
    } catch {
      return 'Unknown';
    }
  };

  const canCreatePet = () => {
    return isAdmin() || isStaff() || isOwner();
  };

  const canEditPet = (pet: Pet) => {
    if (isAdmin() || isStaff()) return true;
    if (isOwner()) return pet.user_id === currentUser?.id;
    return false;
  };

  const canDeletePet = (pet: Pet) => {
    if (isAdmin()) return true;
    if (isOwner()) return pet.user_id === currentUser?.id;
    return false;
  };

  const handleOpenDialog = (pet?: Pet) => {
    if (pet) {
      setEditingPet(pet);
      setFormData({
        name: pet.name,
        birth_date: pet.birth_date,
        gender: pet.gender,
        species: pet.species,
        color: pet.color,
        health_info: pet.health_info,
        user_id: pet.user_id,
      });
    } else {
      setEditingPet(null);
      setFormData({
        name: '',
        birth_date: dayjs().format('YYYY-MM-DD'),
        gender: 'MALE',
        species: '',
        color: '',
        health_info: '',
        user_id: currentUser?.id || 0,
      });
    }
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setEditingPet(null);
  };

  const handleFormChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSelectChange = (name: string, value: any) => {
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSubmit = async () => {
    try {
      setError(null);
      
      if (editingPet) {
        await apiService.updatePet(editingPet.id, formData);
      } else {
        await apiService.createPet(formData);
      }
      
      await loadData();
      handleCloseDialog();
    } catch (err: any) {
      setError(err.message || 'Failed to save pet');
    }
  };

  const handleDeleteClick = (pet: Pet) => {
    setPetToDelete(pet);
    setDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    if (!petToDelete) return;
    
    try {
      setError(null);
      await apiService.deletePet(petToDelete.id);
      await loadData();
      setDeleteDialogOpen(false);
      setPetToDelete(null);
    } catch (err: any) {
      setError(err.message || 'Failed to delete pet');
    }
  };

  const getPetInitials = (name: string) => {
    return name.split(' ').map(word => word[0]).join('').toUpperCase().slice(0, 2);
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h4" component="h1" sx={{ fontWeight: 600 }}>
          {isOwner() ? 'My Pets' : 'All Pets'}
        </Typography>
        {canCreatePet() && (
          <Button
            variant="contained"
            startIcon={<Add />}
            onClick={() => handleOpenDialog()}
          >
            Add Pet
          </Button>
        )}
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }} onClose={() => setError(null)}>
          {error}
        </Alert>
      )}

      {pets.length === 0 ? (
        <Card>
          <CardContent sx={{ textAlign: 'center', py: 6 }}>
            <Pets sx={{ fontSize: 64, color: 'text.secondary', mb: 2 }} />
            <Typography variant="h6" color="text.secondary" gutterBottom>
              No Pets Found
            </Typography>
            <Typography variant="body2" color="text.secondary">
              {isOwner() 
                ? "You haven't registered any pets yet."
                : "No pets have been registered in the system yet."
              }
            </Typography>
          </CardContent>
        </Card>
      ) : (
        <Paper sx={{ overflow: 'hidden' }}>
          <TableContainer>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Pet</TableCell>
                  <TableCell>Species</TableCell>
                  <TableCell>Gender</TableCell>
                  <TableCell>Age</TableCell>
                  <TableCell>Color</TableCell>
                  {!isOwner() && <TableCell>Owner</TableCell>}
                  <TableCell align="right">Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {pets.map((pet) => (
                  <TableRow key={pet.id}>
                    <TableCell>
                      <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                        <Avatar sx={{ bgcolor: 'primary.main' }}>
                          {getPetInitials(pet.name)}
                        </Avatar>
                        <Box>
                          <Typography variant="body1" sx={{ fontWeight: 500 }}>
                            {pet.name}
                          </Typography>
                          <Typography variant="caption" color="text.secondary">
                            Born: {formatDate(pet.birth_date)}
                          </Typography>
                        </Box>
                      </Box>
                    </TableCell>
                    <TableCell>
                      <Chip
                        label={pet.species}
                        size="small"
                        variant="outlined"
                      />
                    </TableCell>
                    <TableCell>
                      <Chip
                        label={pet.gender}
                        size="small"
                        color={pet.gender === 'MALE' ? 'primary' : 'secondary'}
                      />
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {calculateAge(pet.birth_date)}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {pet.color}
                      </Typography>
                    </TableCell>
                    {!isOwner() && (
                      <TableCell>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                          <Person sx={{ fontSize: 16, color: 'text.secondary' }} />
                          <Typography variant="body2">
                            {getOwnerName(pet.user_id)}
                          </Typography>
                        </Box>
                      </TableCell>
                    )}
                    <TableCell align="right">
                      <Stack direction="row" spacing={1} justifyContent="flex-end">
                        {canEditPet(pet) && (
                          <Tooltip title="Edit">
                            <IconButton
                              size="small"
                              onClick={() => handleOpenDialog(pet)}
                            >
                              <Edit />
                            </IconButton>
                          </Tooltip>
                        )}
                        {canDeletePet(pet) && (
                          <Tooltip title="Delete">
                            <IconButton
                              size="small"
                              color="error"
                              onClick={() => handleDeleteClick(pet)}
                            >
                              <Delete />
                            </IconButton>
                          </Tooltip>
                        )}
                      </Stack>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </Paper>
      )}

      {/* Add/Edit Pet Dialog */}
      <Dialog open={dialogOpen} onClose={handleCloseDialog} maxWidth="md" fullWidth>
        <DialogTitle>
          {editingPet ? 'Edit Pet' : 'Add New Pet'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={3} sx={{ mt: 1 }}>
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Pet Name"
                name="name"
                value={formData.name}
                onChange={handleFormChange}
                required
              />
            </Grid>
            
            <Grid item xs={12} md={6}>
              <DatePicker
                label="Birth Date"
                value={dayjs(formData.birth_date)}
                onChange={(date) => {
                  if (date) {
                    handleSelectChange('birth_date', date.format('YYYY-MM-DD'));
                  }
                }}
                slotProps={{
                  textField: {
                    fullWidth: true,
                  },
                }}
              />
            </Grid>
            
            <Grid item xs={12} md={6}>
              <FormControl fullWidth>
                <InputLabel>Species</InputLabel>
                <Select
                  value={formData.species}
                  label="Species"
                  onChange={(e) => handleSelectChange('species', e.target.value)}
                >
                  {speciesOptions.map((species) => (
                    <MenuItem key={species} value={species}>
                      {species}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} md={6}>
              <FormControl fullWidth>
                <InputLabel>Gender</InputLabel>
                <Select
                  value={formData.gender}
                  label="Gender"
                  onChange={(e) => handleSelectChange('gender', e.target.value)}
                >
                  {genderOptions.map((option) => (
                    <MenuItem key={option.value} value={option.value}>
                      {option.label}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Color"
                name="color"
                value={formData.color}
                onChange={handleFormChange}
                required
              />
            </Grid>
            
            {(isAdmin() || isStaff()) && (
              <Grid item xs={12} md={6}>
                <FormControl fullWidth>
                  <InputLabel>Owner</InputLabel>
                  <Select
                    value={formData.user_id}
                    label="Owner"
                    onChange={(e) => handleSelectChange('user_id', e.target.value)}
                  >
                    {users.filter(u => u.roles === 'OWNER').map((user) => (
                      <MenuItem key={user.id} value={user.id}>
                        {user.user_name} ({user.email})
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
            )}
            
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Health Information"
                name="health_info"
                value={formData.health_info}
                onChange={handleFormChange}
                multiline
                rows={4}
                placeholder="Any relevant health information, allergies, or medical conditions..."
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained">
            {editingPet ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)}>
        <DialogTitle>Confirm Delete</DialogTitle>
        <DialogContent>
          <Typography>
            Are you sure you want to delete "{petToDelete?.name}"? This action cannot be undone and will also remove all associated medical records.
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDeleteDialogOpen(false)}>Cancel</Button>
          <Button onClick={handleDeleteConfirm} color="error" variant="contained">
            Delete
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default AllPetsPage; 