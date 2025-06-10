import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  CircularProgress,
  Alert,
  Chip,
  Button,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  MenuItem,
  FormControl,
  InputLabel,
  Select,
  Grid,
  Avatar,
} from '@mui/material';
import {
  Edit,
  Delete,
  Add,
  Visibility,
  CheckCircle,
  Schedule,
  Cancel,
  TaskAlt,
  Pets,
  MedicalServices,
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import dayjs from 'dayjs';
import apiService from '../../services/api';
import useAuthStore from '../../stores/authStore';
import type { ServiceBooking, BookingStatus, Pet, Service, User } from '../../types/api';

const AllBookingsPage: React.FC = () => {
  const { user, isOwner } = useAuthStore();
  const [bookings, setBookings] = useState<ServiceBooking[]>([]);
  const [pets, setPets] = useState<Pet[]>([]);
  const [services, setServices] = useState<Service[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedBooking, setSelectedBooking] = useState<ServiceBooking | null>(null);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editMode, setEditMode] = useState(false);

  const [formData, setFormData] = useState({
    start_date: dayjs().format('YYYY-MM-DD'),
    end_date: '',
    notes: '',
    user_id: user?.id || 0,
    service_id: 0,
    pet_id: 0,
  });

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Load bookings based on user role
      let bookingsData: ServiceBooking[];
      if (isOwner()) {
        bookingsData = await apiService.getMyBookings();
      } else {
        bookingsData = await apiService.getAllBookings();
      }
      
      // Load related data - always load all pets for admin/staff to see pet names in bookings
      const [petsData, servicesData, usersData] = await Promise.all([
        apiService.getAllPets(), // Always load all pets for name lookup
        apiService.getAllServices(),
        isOwner() ? Promise.resolve([]) : apiService.getAllUsers(),
      ]);
      
      console.log('Loaded data:', {
        bookings: bookingsData.length,
        pets: petsData.length,
        services: servicesData.length,
        users: usersData.length
      });
      
      // Debug: Log sample booking data
      if (bookingsData.length > 0) {
        console.log('Sample booking:', bookingsData[0]);
      }
      
      // Debug: Log pets data
      console.log('Pets data:', petsData.map(p => ({ id: p.id, name: p.name, user_id: p.user_id })));
      
      setBookings(bookingsData);
      setPets(petsData);
      setServices(servicesData);
      setUsers(usersData);
    } catch (err: any) {
      console.error('Failed to load bookings:', err);
      setError('Failed to load bookings. Please ensure the backend is running and try again.');
    } finally {
      setLoading(false);
    }
  };

  const getPetName = (petId?: number) => {
    if (!petId) return 'No Pet Assigned';
    const pet = pets.find(p => p.id === petId);
    if (!pet) {
      console.warn(`Pet with ID ${petId} not found in pets list. Available pets:`, pets.map(p => ({ id: p.id, name: p.name })));
      return `Pet ID: ${petId}`;
    }
    return `${pet.name} (${pet.species})`;
  };

  const getServiceName = (serviceId: number) => {
    const service = services.find(s => s.id === serviceId);
    return service ? service.service_name : `Service #${serviceId}`;
  };

  const getUserName = (userId: number) => {
    const user = users.find(u => u.id === userId);
    return user ? user.user_name : `User #${userId}`;
  };

  const getStatusIcon = (status: BookingStatus) => {
    switch (status) {
      case 'CONFIRMED':
        return <CheckCircle sx={{ color: 'success.main' }} />;
      case 'PENDING':
        return <Schedule sx={{ color: 'warning.main' }} />;
      case 'CANCELLED':
        return <Cancel sx={{ color: 'error.main' }} />;
      case 'COMPLETED':
        return <TaskAlt sx={{ color: 'info.main' }} />;
      default:
        return <Schedule sx={{ color: 'grey.500' }} />;
    }
  };

  const getStatusColor = (status: BookingStatus) => {
    switch (status) {
      case 'CONFIRMED': return 'success';
      case 'PENDING': return 'warning';
      case 'CANCELLED': return 'error';
      case 'COMPLETED': return 'info';
      default: return 'default';
    }
  };

  const formatDate = (dateString: string) => {
    try {
      return dayjs(dateString).format('MMM DD, YYYY');
    } catch {
      return dateString;
    }
  };

  const handleView = (booking: ServiceBooking) => {
    setSelectedBooking(booking);
    setEditMode(false);
    setDialogOpen(true);
  };

  const handleEdit = (booking: ServiceBooking) => {
    setSelectedBooking(booking);
    setFormData({
      start_date: booking.start_date,
      end_date: booking.end_date || '',
      notes: booking.notes,
      user_id: booking.user_id,
      service_id: booking.service_id,
      pet_id: booking.pet_id || 0,
    });
    setEditMode(true);
    setDialogOpen(true);
  };

  const handleAdd = () => {
    setSelectedBooking(null);
    setFormData({
      start_date: dayjs().format('YYYY-MM-DD'),
      end_date: '',
      notes: '',
      user_id: user?.id || 0,
      service_id: 0,
      pet_id: 0,
    });
    setEditMode(true);
    setDialogOpen(true);
  };

  const handleDelete = async (bookingId: number) => {
    if (!window.confirm('Are you sure you want to delete this booking?')) {
      return;
    }

    try {
      await apiService.deleteBooking(bookingId);
      await loadData();
    } catch (err) {
      console.error('Failed to delete booking:', err);
      setError('Failed to delete booking. Please try again.');
    }
  };

  const handleStatusChange = async (bookingId: number, newStatus: BookingStatus) => {
    try {
      await apiService.updateBookingStatus(bookingId, newStatus);
      await loadData();
      setDialogOpen(false);
    } catch (err) {
      console.error('Failed to update booking status:', err);
      setError('Failed to update booking status. Please try again.');
    }
  };

  const handleSubmit = async () => {
    try {
      setError(null);
      
      if (selectedBooking) {
        await apiService.updateBooking(selectedBooking.id, formData);
      } else {
        await apiService.createBooking(formData);
      }
      
      await loadData();
      handleCloseDialog();
    } catch (err: any) {
      setError(err.message || 'Failed to save booking');
    }
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setSelectedBooking(null);
    setEditMode(false);
  };

  const handleFormChange = (field: string, value: any) => {
    setFormData(prev => ({
      ...prev,
      [field]: value,
    }));
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress size={40} />
      </Box>
    );
  }

  return (
    <Box>
      {/* Header */}
      <Box mb={4} display="flex" justifyContent="space-between" alignItems="center">
        <Box>
          <Typography variant="h4" component="h1" gutterBottom sx={{ fontWeight: 600 }}>
            {isOwner() ? 'My Bookings' : 'All Bookings'}
          </Typography>
          <Typography variant="body1" color="text.secondary">
            {isOwner() ? 'Manage your service bookings' : 'Manage all bookings in the system'}
          </Typography>
        </Box>
        <Button
          variant="contained"
          startIcon={<Add />}
          onClick={handleAdd}
        >
          New Booking
        </Button>
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }} onClose={() => setError(null)}>
          {error}
        </Alert>
      )}

      {/* Bookings Table */}
      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Pet</TableCell>
              <TableCell>Service</TableCell>
              <TableCell>Start Date</TableCell>
              <TableCell>End Date</TableCell>
              <TableCell>Status</TableCell>
              {!isOwner() && <TableCell>Customer</TableCell>}
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {bookings.length === 0 ? (
              <TableRow>
                <TableCell colSpan={isOwner() ? 7 : 8} align="center" sx={{ py: 4 }}>
                  <Typography variant="body1" color="text.secondary">
                    No bookings found.
                  </Typography>
                </TableCell>
              </TableRow>
            ) : (
              bookings.map((booking) => (
                <TableRow key={booking.id} hover>
                  <TableCell>{booking.id}</TableCell>
                  <TableCell>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                      <Avatar sx={{ width: 24, height: 24, bgcolor: 'primary.main' }}>
                        <Pets sx={{ fontSize: 14 }} />
                      </Avatar>
                      {getPetName(booking.pet_id)}
                    </Box>
                  </TableCell>
                  <TableCell>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                      <Avatar sx={{ width: 24, height: 24, bgcolor: 'secondary.main' }}>
                        <MedicalServices sx={{ fontSize: 14 }} />
                      </Avatar>
                      {getServiceName(booking.service_id)}
                    </Box>
                  </TableCell>
                  <TableCell>{formatDate(booking.start_date)}</TableCell>
                  <TableCell>{booking.end_date ? formatDate(booking.end_date) : 'N/A'}</TableCell>
                  <TableCell>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                      {getStatusIcon(booking.status)}
                      <Chip
                        label={booking.status}
                        color={getStatusColor(booking.status) as any}
                        size="small"
                      />
                    </Box>
                  </TableCell>
                  {!isOwner() && (
                    <TableCell>{getUserName(booking.user_id)}</TableCell>
                  )}
                  <TableCell>
                    <IconButton size="small" onClick={() => handleView(booking)}>
                      <Visibility />
                    </IconButton>
                    <IconButton size="small" onClick={() => handleEdit(booking)}>
                      <Edit />
                    </IconButton>
                    <IconButton size="small" onClick={() => handleDelete(booking.id)} color="error">
                      <Delete />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </TableContainer>

      {/* Booking Details/Edit Dialog */}
      <Dialog open={dialogOpen} onClose={handleCloseDialog} maxWidth="md" fullWidth>
        <DialogTitle>
          {editMode ? (selectedBooking ? 'Edit Booking' : 'New Booking') : 'Booking Details'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={3} sx={{ mt: 1 }}>
            {selectedBooking && !editMode && (
              <Grid item xs={12}>
                <Typography variant="h6" gutterBottom>
                  Booking Information
                </Typography>
              </Grid>
            )}
            
            <Grid item xs={12} md={6}>
              <FormControl fullWidth>
                <InputLabel>Pet</InputLabel>
                <Select
                  value={editMode ? formData.pet_id : selectedBooking?.pet_id || ''}
                  label="Pet"
                  disabled={!editMode}
                  onChange={(e) => handleFormChange('pet_id', e.target.value)}
                >
                  {pets.map((pet) => (
                    <MenuItem key={pet.id} value={pet.id}>
                      {pet.name} ({pet.species})
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} md={6}>
              <FormControl fullWidth>
                <InputLabel>Service</InputLabel>
                <Select
                  value={editMode ? formData.service_id : selectedBooking?.service_id || ''}
                  label="Service"
                  disabled={!editMode}
                  onChange={(e) => handleFormChange('service_id', e.target.value)}
                >
                  {services.map((service) => (
                    <MenuItem key={service.id} value={service.id}>
                      {service.service_name} - ${service.price}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} md={6}>
              <DatePicker
                label="Start Date"
                value={dayjs(editMode ? formData.start_date : selectedBooking?.start_date)}
                onChange={(date) => {
                  if (date && editMode) {
                    handleFormChange('start_date', date.format('YYYY-MM-DD'));
                  }
                }}
                disabled={!editMode}
                slotProps={{
                  textField: { fullWidth: true },
                }}
              />
            </Grid>
            
            <Grid item xs={12} md={6}>
              <DatePicker
                label="End Date (Optional)"
                value={editMode ? (formData.end_date ? dayjs(formData.end_date) : null) : (selectedBooking?.end_date ? dayjs(selectedBooking.end_date) : null)}
                onChange={(date) => {
                  if (editMode) {
                    handleFormChange('end_date', date ? date.format('YYYY-MM-DD') : '');
                  }
                }}
                disabled={!editMode}
                slotProps={{
                  textField: { fullWidth: true },
                }}
              />
            </Grid>
            
            {!isOwner() && (
              <Grid item xs={12} md={6}>
                <FormControl fullWidth>
                  <InputLabel>Customer</InputLabel>
                  <Select
                    value={editMode ? formData.user_id : selectedBooking?.user_id || ''}
                    label="Customer"
                    disabled={!editMode}
                    onChange={(e) => handleFormChange('user_id', e.target.value)}
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
            
            {!editMode && selectedBooking && (
              <Grid item xs={12} md={6}>
                <FormControl fullWidth>
                  <InputLabel>Status</InputLabel>
                  <Select
                    value={selectedBooking.status}
                    label="Status"
                    onChange={(e) => {
                      if (selectedBooking) {
                        handleStatusChange(selectedBooking.id, e.target.value as BookingStatus);
                      }
                    }}
                  >
                    <MenuItem value="PENDING">Pending</MenuItem>
                    <MenuItem value="CONFIRMED">Confirmed</MenuItem>
                    <MenuItem value="COMPLETED">Completed</MenuItem>
                    <MenuItem value="CANCELLED">Cancelled</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
            )}
            
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Notes"
                value={editMode ? formData.notes : selectedBooking?.notes || ''}
                onChange={(e) => editMode && handleFormChange('notes', e.target.value)}
                disabled={!editMode}
                multiline
                rows={3}
                placeholder="Any additional notes or special instructions..."
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>
            {editMode ? 'Cancel' : 'Close'}
          </Button>
          {editMode && (
            <Button variant="contained" onClick={handleSubmit}>
              {selectedBooking ? 'Update' : 'Create'}
            </Button>
          )}
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default AllBookingsPage; 