import React, { useState, useEffect } from 'react';
import {
  Box,
  Paper,
  Typography,
  Button,
  TextField,
  Alert,
  CircularProgress,
  Stack,
  Card,
  CardContent,
  Chip,
  Avatar,
  Grid,
  Divider,
} from '@mui/material';
import {
  Person,
  Edit,
  Save,
  Cancel,
  AdminPanelSettings,
  LocalHospital,
  Group,
} from '@mui/icons-material';
import useAuthStore from '../../stores/authStore';
import apiService from '../../services/api';
import type { User } from '../../types/auth';

const ProfilePage: React.FC = () => {
  const { user: currentUser, getCurrentUser } = useAuthStore();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [editing, setEditing] = useState(false);

  const [formData, setFormData] = useState({
    user_name: currentUser?.user_name || '',
    email: currentUser?.email || '',
    phone: currentUser?.phone || '',
  });

  useEffect(() => {
    if (currentUser) {
      setFormData({
        user_name: currentUser.user_name,
        email: currentUser.email,
        phone: currentUser.phone,
      });
    }
  }, [currentUser]);

  const getRoleIcon = (role: string) => {
    switch (role) {
      case 'ADMIN':
        return <AdminPanelSettings />;
      case 'DOCTOR':
        return <LocalHospital />;
      case 'STAFF':
        return <Group />;
      case 'OWNER':
        return <Person />;
      default:
        return <Person />;
    }
  };

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'ADMIN':
        return 'error';
      case 'DOCTOR':
        return 'success';
      case 'STAFF':
        return 'warning';
      case 'OWNER':
        return 'primary';
      default:
        return 'default';
    }
  };

  const getUserInitials = () => {
    if (!currentUser) return 'U';
    const name = currentUser.user_name || currentUser.email;
    return name
      .split(' ')
      .map(word => word[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  const handleFormChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleEditClick = () => {
    setEditing(true);
    setError(null);
    setSuccess(null);
  };

  const handleCancelEdit = () => {
    setEditing(false);
    setError(null);
    setSuccess(null);
    // Reset form data
    if (currentUser) {
      setFormData({
        user_name: currentUser.user_name,
        email: currentUser.email,
        phone: currentUser.phone,
      });
    }
  };

  const handleSave = async () => {
    if (!currentUser) return;

    try {
      setLoading(true);
      setError(null);
      setSuccess(null);

      await apiService.updateUser(currentUser.id, formData);
      await getCurrentUser(); // Refresh user data
      
      setEditing(false);
      setSuccess('Profile updated successfully!');
    } catch (err: any) {
      setError(err.message || 'Failed to update profile');
    } finally {
      setLoading(false);
    }
  };

  if (!currentUser) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box>
      <Typography variant="h4" component="h1" sx={{ fontWeight: 600, mb: 3 }}>
        My Profile
      </Typography>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }} onClose={() => setError(null)}>
          {error}
        </Alert>
      )}

      {success && (
        <Alert severity="success" sx={{ mb: 3 }} onClose={() => setSuccess(null)}>
          {success}
        </Alert>
      )}

      <Grid container spacing={3}>
        {/* Profile Summary Card */}
        <Grid item xs={12} md={4}>
          <Card>
            <CardContent sx={{ textAlign: 'center', py: 4 }}>
              <Avatar
                sx={{ 
                  width: 80, 
                  height: 80, 
                  bgcolor: 'primary.main', 
                  mx: 'auto', 
                  mb: 2,
                  fontSize: '2rem',
                }}
              >
                {getUserInitials()}
              </Avatar>
              
              <Typography variant="h6" sx={{ fontWeight: 600, mb: 1 }}>
                {currentUser.user_name}
              </Typography>
              
              <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                {currentUser.email}
              </Typography>
              
              <Chip
                icon={getRoleIcon(currentUser.roles)}
                label={currentUser.roles}
                color={getRoleColor(currentUser.roles) as any}
                sx={{ fontWeight: 500 }}
              />
            </CardContent>
          </Card>
        </Grid>

        {/* Profile Details Card */}
        <Grid item xs={12} md={8}>
          <Card>
            <CardContent sx={{ p: 4 }}>
              <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
                <Typography variant="h6" sx={{ fontWeight: 600 }}>
                  Profile Information
                </Typography>
                {!editing && (
                  <Button
                    variant="outlined"
                    startIcon={<Edit />}
                    onClick={handleEditClick}
                  >
                    Edit Profile
                  </Button>
                )}
              </Box>

              <Divider sx={{ mb: 3 }} />

              <Stack spacing={3}>
                <TextField
                  fullWidth
                  label="Full Name"
                  name="user_name"
                  value={formData.user_name}
                  onChange={handleFormChange}
                  disabled={!editing}
                  variant={editing ? "outlined" : "filled"}
                />

                <TextField
                  fullWidth
                  label="Email Address"
                  name="email"
                  type="email"
                  value={formData.email}
                  onChange={handleFormChange}
                  disabled={!editing}
                  variant={editing ? "outlined" : "filled"}
                />

                <TextField
                  fullWidth
                  label="Phone Number"
                  name="phone"
                  value={formData.phone}
                  onChange={handleFormChange}
                  disabled={!editing}
                  variant={editing ? "outlined" : "filled"}
                />

                <TextField
                  fullWidth
                  label="Role"
                  value={currentUser.roles}
                  disabled
                  variant="filled"
                  helperText="Role cannot be changed from profile. Contact an administrator if you need role changes."
                />
              </Stack>

              {editing && (
                <Box sx={{ display: 'flex', gap: 2, mt: 4, justifyContent: 'flex-end' }}>
                  <Button
                    variant="outlined"
                    startIcon={<Cancel />}
                    onClick={handleCancelEdit}
                    disabled={loading}
                  >
                    Cancel
                  </Button>
                  <Button
                    variant="contained"
                    startIcon={<Save />}
                    onClick={handleSave}
                    disabled={loading}
                  >
                    {loading ? <CircularProgress size={20} /> : 'Save Changes'}
                  </Button>
                </Box>
              )}
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default ProfilePage; 