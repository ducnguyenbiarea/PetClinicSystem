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
} from '@mui/material';
import {
  Add,
  Edit,
  Delete,
  HomeWork,
  Pets,
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import dayjs from 'dayjs';
import apiService from '../../services/api';
import type { Cage, CageCreateRequest, Pet } from '../../types/api';

const CagesPage: React.FC = () => {
  const [cages, setCages] = useState<Cage[]>([]);
  const [pets, setPets] = useState<Pet[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingCage, setEditingCage] = useState<Cage | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [cageToDelete, setCageToDelete] = useState<Cage | null>(null);

  const [formData, setFormData] = useState<CageCreateRequest>({
    type: '',
    size: '',
    status: 'AVAILABLE',
    start_date: dayjs().format('YYYY-MM-DD'),
    end_date: '',
    pet_id: undefined,
  });

  const cageTypes = ['DOG', 'CAT', 'SMALL_ANIMAL', 'BIRD', 'REPTILE'];
  const cageSizes = ['Small', 'Medium', 'Large', 'Extra Large'];
  const cageStatuses = [
    { value: 'AVAILABLE', label: 'Available', color: 'success' },
    { value: 'OCCUPIED', label: 'Occupied', color: 'error' },
    { value: 'CLEANING', label: 'Cleaning', color: 'warning' },
    { value: 'MAINTENANCE', label: 'Maintenance', color: 'info' },
  ];

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      setLoading(true);
      setError(null);
      const [cagesData, petsData] = await Promise.all([
        apiService.getAllCages(),
        apiService.getAllPets(),
      ]);
      setCages(cagesData);
      setPets(petsData);
    } catch (err: any) {
      setError(err.message || 'Failed to load cages');
    } finally {
      setLoading(false);
    }
  };

  const getPetName = (petId?: number) => {
    if (!petId) return '-';
    const pet = pets.find(p => p.id === petId);
    return pet?.name || 'Unknown Pet';
  };

  const getStatusColor = (status: string) => {
    const statusConfig = cageStatuses.find(s => s.value === status);
    return statusConfig?.color as any || 'default';
  };

  const formatDate = (dateString?: string) => {
    if (!dateString) return '-';
    try {
      return dayjs(dateString).format('MMM DD, YYYY');
    } catch {
      return dateString;
    }
  };

  const handleOpenDialog = (cage?: Cage) => {
    if (cage) {
      setEditingCage(cage);
      setFormData({
        type: cage.type,
        size: cage.size,
        status: cage.status,
        start_date: cage.start_date || dayjs().format('YYYY-MM-DD'),
        end_date: cage.end_date || '',
        pet_id: cage.pet_id,
      });
    } else {
      setEditingCage(null);
      setFormData({
        type: '',
        size: '',
        status: 'AVAILABLE',
        start_date: dayjs().format('YYYY-MM-DD'),
        end_date: '',
        pet_id: undefined,
      });
    }
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setEditingCage(null);
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
      
      const submitData = {
        ...formData,
        pet_id: formData.pet_id || undefined,
        end_date: formData.end_date || undefined,
      };
      
      if (editingCage) {
        await apiService.updateCage(editingCage.id, submitData);
      } else {
        await apiService.createCage(submitData);
      }
      
      await loadData();
      handleCloseDialog();
    } catch (err: any) {
      setError(err.message || 'Failed to save cage');
    }
  };

  const handleDeleteClick = (cage: Cage) => {
    setCageToDelete(cage);
    setDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    if (!cageToDelete) return;
    
    try {
      setError(null);
      await apiService.deleteCage(cageToDelete.id);
      await loadData();
      setDeleteDialogOpen(false);
      setCageToDelete(null);
    } catch (err: any) {
      setError(err.message || 'Failed to delete cage');
    }
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
          Cages Management
        </Typography>
        <Button
          variant="contained"
          startIcon={<Add />}
          onClick={() => handleOpenDialog()}
        >
          Add Cage
        </Button>
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }} onClose={() => setError(null)}>
          {error}
        </Alert>
      )}

      {cages.length === 0 ? (
        <Card>
          <CardContent sx={{ textAlign: 'center', py: 6 }}>
            <HomeWork sx={{ fontSize: 64, color: 'text.secondary', mb: 2 }} />
            <Typography variant="h6" color="text.secondary" gutterBottom>
              No Cages Found
            </Typography>
            <Typography variant="body2" color="text.secondary">
              No cages have been created yet. Click "Add Cage" to get started.
            </Typography>
          </CardContent>
        </Card>
      ) : (
        <Paper sx={{ overflow: 'hidden' }}>
          <TableContainer>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Cage ID</TableCell>
                  <TableCell>Type</TableCell>
                  <TableCell>Size</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell>Occupied Pet</TableCell>
                  <TableCell>Start Date</TableCell>
                  <TableCell>End Date</TableCell>
                  <TableCell align="right">Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {cages.map((cage) => (
                  <TableRow key={cage.id}>
                    <TableCell>
                      <Typography variant="body1" sx={{ fontWeight: 500 }}>
                        #{cage.id}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Chip
                        label={cage.type}
                        variant="outlined"
                        size="small"
                      />
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {cage.size}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Chip
                        label={cage.status}
                        color={getStatusColor(cage.status)}
                        size="small"
                        sx={{ fontWeight: 500 }}
                      />
                    </TableCell>
                    <TableCell>
                      {cage.pet_id ? (
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                          <Pets sx={{ fontSize: 16, color: 'text.secondary' }} />
                          <Typography variant="body2">
                            {getPetName(cage.pet_id)}
                          </Typography>
                        </Box>
                      ) : (
                        <Typography variant="body2" color="text.secondary">
                          -
                        </Typography>
                      )}
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {formatDate(cage.start_date)}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {formatDate(cage.end_date)}
                      </Typography>
                    </TableCell>
                    <TableCell align="right">
                      <Stack direction="row" spacing={1} justifyContent="flex-end">
                        <Tooltip title="Edit">
                          <IconButton
                            size="small"
                            onClick={() => handleOpenDialog(cage)}
                          >
                            <Edit />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Delete">
                          <IconButton
                            size="small"
                            color="error"
                            onClick={() => handleDeleteClick(cage)}
                          >
                            <Delete />
                          </IconButton>
                        </Tooltip>
                      </Stack>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </Paper>
      )}

      {/* Add/Edit Cage Dialog */}
      <Dialog open={dialogOpen} onClose={handleCloseDialog} maxWidth="md" fullWidth>
        <DialogTitle>
          {editingCage ? 'Edit Cage' : 'Add New Cage'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={3} sx={{ mt: 1 }}>
            <Grid item xs={12} md={6}>
              <FormControl fullWidth>
                <InputLabel>Type</InputLabel>
                <Select
                  value={formData.type}
                  label="Type"
                  onChange={(e) => handleSelectChange('type', e.target.value)}
                >
                  {cageTypes.map((type) => (
                    <MenuItem key={type} value={type}>
                      {type.replace('_', ' ')}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} md={6}>
              <FormControl fullWidth>
                <InputLabel>Size</InputLabel>
                <Select
                  value={formData.size}
                  label="Size"
                  onChange={(e) => handleSelectChange('size', e.target.value)}
                >
                  {cageSizes.map((size) => (
                    <MenuItem key={size} value={size}>
                      {size}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} md={6}>
              <FormControl fullWidth>
                <InputLabel>Status</InputLabel>
                <Select
                  value={formData.status}
                  label="Status"
                  onChange={(e) => handleSelectChange('status', e.target.value)}
                >
                  {cageStatuses.map((status) => (
                    <MenuItem key={status.value} value={status.value}>
                      {status.label}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} md={6}>
              <FormControl fullWidth>
                <InputLabel>Assigned Pet</InputLabel>
                <Select
                  value={formData.pet_id || ''}
                  label="Assigned Pet"
                  onChange={(e) => handleSelectChange('pet_id', e.target.value || undefined)}
                >
                  <MenuItem value="">None</MenuItem>
                  {pets.map((pet) => (
                    <MenuItem key={pet.id} value={pet.id}>
                      {pet.name} - {pet.species}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} md={6}>
              <DatePicker
                label="Start Date"
                value={dayjs(formData.start_date)}
                onChange={(date) => {
                  if (date) {
                    handleSelectChange('start_date', date.format('YYYY-MM-DD'));
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
              <DatePicker
                label="End Date (Optional)"
                value={formData.end_date ? dayjs(formData.end_date) : null}
                onChange={(date) => {
                  handleSelectChange('end_date', date ? date.format('YYYY-MM-DD') : '');
                }}
                slotProps={{
                  textField: {
                    fullWidth: true,
                  },
                }}
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained">
            {editingCage ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)}>
        <DialogTitle>Confirm Delete</DialogTitle>
        <DialogContent>
          <Typography>
            Are you sure you want to delete cage #{cageToDelete?.id}? This action cannot be undone.
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

export default CagesPage; 