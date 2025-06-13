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
} from '@mui/material';
import {
  Add,
  Edit,
  Delete,
  Visibility,
  MedicalServices,
  Pets,
  Person,
  CalendarToday,
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import dayjs from 'dayjs';
import apiService from '../../services/api';
import useAuthStore from '../../stores/authStore';
import type { MedicalRecord, MedicalRecordCreateRequest, Pet } from '../../types/api';
import type { User } from '../../types/auth';

const MedicalRecordsPage: React.FC = () => {
  const { user: currentUser, isAdmin, isDoctor, isStaff, isOwner } = useAuthStore();
  const [records, setRecords] = useState<MedicalRecord[]>([]);
  const [pets, setPets] = useState<Pet[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingRecord, setEditingRecord] = useState<MedicalRecord | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [recordToDelete, setRecordToDelete] = useState<MedicalRecord | null>(null);

  const [formData, setFormData] = useState<MedicalRecordCreateRequest>({
    diagnosis: '',
    prescription: '',
    notes: '',
    next_meeting_date: dayjs().format('YYYY-MM-DD'),
    pet_id: 0,
    user_id: currentUser?.id || 0,
  });

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Load pets first based on user role
      let petsData: Pet[];
      if (isOwner()) {
        petsData = await apiService.getMyPets();
      } else {
        petsData = await apiService.getAllPets();
      }
      
      // Load medical records based on user role
      let recordsData: MedicalRecord[] = [];
      if (isOwner()) {
        // For owners, get medical records for all their pets
        if (petsData.length > 0) {
          const petRecords = await Promise.all(
            petsData.map(pet => apiService.getMedicalRecordsByPetId(pet.id))
          );
          recordsData = petRecords.flat();
        }
      } else {
        recordsData = await apiService.getAllMedicalRecords();
      }
      
      // Load users if not owner (for creating records)
      let usersData: User[] = [];
      if (!isOwner()) {
        usersData = await apiService.getAllUsers();
      }
      
      setRecords(recordsData);
      setPets(petsData);
      setUsers(usersData);
    } catch (err: any) {
      setError(err.message || 'Failed to load medical records');
    } finally {
      setLoading(false);
    }
  };

  const getPetName = (petId: number) => {
    const pet = pets.find(p => p.id === petId);
    return pet?.name || 'Unknown Pet';
  };

  const getUserName = (userId: number) => {
    const user = users.find(u => u.id === userId);
    return user?.user_name || 'Unknown User';
  };

  const formatDate = (dateString: string) => {
    try {
      return dayjs(dateString).format('MMM DD, YYYY');
    } catch {
      return dateString;
    }
  };

  const canCreateRecord = () => {
    return isAdmin() || isDoctor() || isStaff();
  };

  const canEditRecord = (record: MedicalRecord) => {
    if (isAdmin()) return true;
    if (isDoctor() || isStaff()) return record.user_id === currentUser?.id;
    return false;
  };

  const canDeleteRecord = (record: MedicalRecord) => {
    if (isAdmin()) return true;
    if (isDoctor()) return record.user_id === currentUser?.id;
    return false;
  };

  const handleOpenDialog = (record?: MedicalRecord) => {
    if (record) {
      setEditingRecord(record);
      setFormData({
        diagnosis: record.diagnosis,
        prescription: record.prescription,
        notes: record.notes,
        next_meeting_date: record.next_meeting_date,
        pet_id: record.pet_id,
        user_id: record.user_id,
      });
    } else {
      setEditingRecord(null);
      setFormData({
        diagnosis: '',
        prescription: '',
        notes: '',
        next_meeting_date: dayjs().format('YYYY-MM-DD'),
        pet_id: pets.length > 0 ? pets[0].id : 0,
        user_id: currentUser?.id || 0,
      });
    }
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setEditingRecord(null);
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
      
      if (editingRecord) {
        await apiService.updateMedicalRecord(editingRecord.id, formData);
      } else {
        await apiService.createMedicalRecord(formData);
      }
      
      await loadData();
      handleCloseDialog();
    } catch (err: any) {
      setError(err.message || 'Failed to save medical record');
    }
  };

  const handleDeleteClick = (record: MedicalRecord) => {
    setRecordToDelete(record);
    setDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    if (!recordToDelete) return;
    
    try {
      setError(null);
      await apiService.deleteMedicalRecord(recordToDelete.id);
      await loadData();
      setDeleteDialogOpen(false);
      setRecordToDelete(null);
    } catch (err: any) {
      setError(err.message || 'Failed to delete medical record');
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
          Medical Records
        </Typography>
        {canCreateRecord() && (
          <Button
            variant="contained"
            startIcon={<Add />}
            onClick={() => handleOpenDialog()}
          >
            Add Record
          </Button>
        )}
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }} onClose={() => setError(null)}>
          {error}
        </Alert>
      )}

      {records.length === 0 ? (
        <Card>
          <CardContent sx={{ textAlign: 'center', py: 6 }}>
            <MedicalServices sx={{ fontSize: 64, color: 'text.secondary', mb: 2 }} />
            <Typography variant="h6" color="text.secondary" gutterBottom>
              No Medical Records Found
            </Typography>
            <Typography variant="body2" color="text.secondary">
              {isOwner() 
                ? "Your pets don't have any medical records yet."
                : "No medical records have been created yet."
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
                  <TableCell>Diagnosis</TableCell>
                  <TableCell>Prescription</TableCell>
                  <TableCell>Record Date</TableCell>
                  <TableCell>Next Meeting</TableCell>
                  {!isOwner() && <TableCell>Created By</TableCell>}
                  <TableCell align="right">Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {records.map((record) => (
                  <TableRow key={record.id}>
                    <TableCell>
                      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                        <Pets sx={{ fontSize: 16, color: 'text.secondary' }} />
                        <Typography variant="body2" sx={{ fontWeight: 500 }}>
                          {getPetName(record.pet_id)}
                        </Typography>
                      </Box>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2" sx={{ maxWidth: 200 }}>
                        {record.diagnosis}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2" sx={{ maxWidth: 200 }}>
                        {record.prescription}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {formatDate(record.record_date)}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {formatDate(record.next_meeting_date)}
                      </Typography>
                    </TableCell>
                    {!isOwner() && (
                      <TableCell>
                        <Typography variant="body2">
                          {getUserName(record.user_id)}
                        </Typography>
                      </TableCell>
                    )}
                    <TableCell align="right">
                      <Stack direction="row" spacing={1} justifyContent="flex-end">
                        {canEditRecord(record) && (
                          <Tooltip title="Edit">
                            <IconButton
                              size="small"
                              onClick={() => handleOpenDialog(record)}
                            >
                              <Edit />
                            </IconButton>
                          </Tooltip>
                        )}
                        {canDeleteRecord(record) && (
                          <Tooltip title="Delete">
                            <IconButton
                              size="small"
                              color="error"
                              onClick={() => handleDeleteClick(record)}
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

      {/* Add/Edit Medical Record Dialog */}
      <Dialog open={dialogOpen} onClose={handleCloseDialog} maxWidth="md" fullWidth>
        <DialogTitle>
          {editingRecord ? 'Edit Medical Record' : 'Add New Medical Record'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={3} sx={{ mt: 1 }}>
            <Grid item xs={12} md={6}>
              <FormControl fullWidth>
                <InputLabel>Pet</InputLabel>
                <Select
                  value={formData.pet_id}
                  label="Pet"
                  onChange={(e) => handleSelectChange('pet_id', e.target.value)}
                >
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
                label="Next Meeting Date"
                value={dayjs(formData.next_meeting_date)}
                onChange={(date) => {
                  if (date) {
                    handleSelectChange('next_meeting_date', date.format('YYYY-MM-DD'));
                  }
                }}
                slotProps={{
                  textField: {
                    fullWidth: true,
                  },
                }}
              />
            </Grid>
            
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Diagnosis"
                name="diagnosis"
                value={formData.diagnosis}
                onChange={handleFormChange}
                required
                multiline
                rows={3}
              />
            </Grid>
            
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Prescription"
                name="prescription"
                value={formData.prescription}
                onChange={handleFormChange}
                required
                multiline
                rows={3}
              />
            </Grid>
            
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Notes"
                name="notes"
                value={formData.notes}
                onChange={handleFormChange}
                multiline
                rows={4}
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained">
            {editingRecord ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)}>
        <DialogTitle>Confirm Delete</DialogTitle>
        <DialogContent>
          <Typography>
            Are you sure you want to delete this medical record? This action cannot be undone.
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

export default MedicalRecordsPage; 