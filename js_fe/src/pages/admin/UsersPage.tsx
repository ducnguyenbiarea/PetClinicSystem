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
  Chip,
  Alert,
  CircularProgress,
  Stack,
  Tooltip,
} from '@mui/material';
import {
  Add,
  Edit,
  Delete,
  Visibility,
  AdminPanelSettings,
  LocalHospital,
  Group,
  Person,
} from '@mui/icons-material';
import apiService from '../../services/api';
import useAuthStore from '../../stores/authStore';
import type { User } from '../../types/auth';
import type { RegisterRequest } from '../../types/auth';

const UsersPage: React.FC = () => {
  const { user: currentUser } = useAuthStore();
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<User | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [userToDelete, setUserToDelete] = useState<User | null>(null);

  const [formData, setFormData] = useState<RegisterRequest & { roles: string }>({
    user_name: '',
    email: '',
    phone: '',
    password: '',
    roles: 'OWNER',
  });

  const roles = [
    { value: 'OWNER', label: 'Owner', color: 'primary', icon: <Person /> },
    { value: 'STAFF', label: 'Staff', color: 'warning', icon: <Group /> },
    { value: 'DOCTOR', label: 'Doctor', color: 'success', icon: <LocalHospital /> },
    { value: 'ADMIN', label: 'Admin', color: 'error', icon: <AdminPanelSettings /> },
  ];

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await apiService.getAllUsers();
      setUsers(data);
    } catch (err: any) {
      setError(err.message || 'Failed to load users');
    } finally {
      setLoading(false);
    }
  };

  const getRoleColor = (role: string) => {
    const roleConfig = roles.find(r => r.value === role);
    return roleConfig?.color || 'default';
  };

  const getRoleIcon = (role: string) => {
    const roleConfig = roles.find(r => r.value === role);
    return roleConfig?.icon || <Person />;
  };

  const handleOpenDialog = (user?: User) => {
    if (user) {
      setEditingUser(user);
      setFormData({
        user_name: user.user_name,
        email: user.email,
        phone: user.phone,
        password: '', // Don't prefill password for editing
        roles: user.roles,
      });
    } else {
      setEditingUser(null);
      setFormData({
        user_name: '',
        email: '',
        phone: '',
        password: '',
        roles: 'OWNER',
      });
    }
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setEditingUser(null);
  };

  const handleFormChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleRoleChange = (value: string) => {
    setFormData(prev => ({
      ...prev,
      roles: value,
    }));
  };

  const handleSubmit = async () => {
    try {
      setError(null);
      
      if (editingUser) {
        // Update existing user
        const updateData = {
          user_name: formData.user_name,
          email: formData.email,
          phone: formData.phone,
        };
        
        await apiService.updateUser(editingUser.id, updateData);
        
        // Update role if changed
        if (formData.roles !== editingUser.roles) {
          await apiService.updateUserRole(editingUser.id, formData.roles.toLowerCase());
        }
      } else {
        // Create new user
        const createData = {
          user_name: formData.user_name,
          email: formData.email,
          phone: formData.phone,
          password: formData.password,
        };
        
        const newUser = await apiService.createUser(createData);
        
        // Set role if not default
        if (formData.roles !== 'OWNER') {
          await apiService.updateUserRole(newUser.id, formData.roles.toLowerCase());
        }
      }
      
      await loadUsers();
      handleCloseDialog();
    } catch (err: any) {
      setError(err.message || 'Failed to save user');
    }
  };

  const handleDeleteClick = (user: User) => {
    setUserToDelete(user);
    setDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    if (!userToDelete) return;
    
    try {
      setError(null);
      await apiService.deleteUser(userToDelete.id);
      await loadUsers();
      setDeleteDialogOpen(false);
      setUserToDelete(null);
    } catch (err: any) {
      setError(err.message || 'Failed to delete user');
    }
  };

  const canEditUser = (user: User) => {
    // Admin can edit anyone except themselves (to prevent lockout)
    return user.id !== currentUser?.id;
  };

  const canDeleteUser = (user: User) => {
    // Admin can delete anyone except themselves
    return user.id !== currentUser?.id;
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
          User Management
        </Typography>
        <Button
          variant="contained"
          startIcon={<Add />}
          onClick={() => handleOpenDialog()}
        >
          Add User
        </Button>
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }} onClose={() => setError(null)}>
          {error}
        </Alert>
      )}

      <Paper sx={{ overflow: 'hidden' }}>
        <TableContainer>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Name</TableCell>
                <TableCell>Email</TableCell>
                <TableCell>Phone</TableCell>
                <TableCell>Role</TableCell>
                <TableCell align="right">Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {users.map((user) => (
                <TableRow key={user.id}>
                  <TableCell>
                    <Typography variant="body2" sx={{ fontWeight: 500 }}>
                      {user.user_name}
                    </Typography>
                  </TableCell>
                  <TableCell>{user.email}</TableCell>
                  <TableCell>{user.phone}</TableCell>
                  <TableCell>
                    <Chip
                      icon={getRoleIcon(user.roles)}
                      label={user.roles}
                      color={getRoleColor(user.roles) as any}
                      size="small"
                      sx={{ fontWeight: 500 }}
                    />
                  </TableCell>
                  <TableCell align="right">
                    <Stack direction="row" spacing={1} justifyContent="flex-end">
                      <Tooltip title="Edit">
                        <IconButton
                          size="small"
                          onClick={() => handleOpenDialog(user)}
                          disabled={!canEditUser(user)}
                        >
                          <Edit />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Delete">
                        <IconButton
                          size="small"
                          color="error"
                          onClick={() => handleDeleteClick(user)}
                          disabled={!canDeleteUser(user)}
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

      {/* Add/Edit User Dialog */}
      <Dialog open={dialogOpen} onClose={handleCloseDialog} maxWidth="sm" fullWidth>
        <DialogTitle>
          {editingUser ? 'Edit User' : 'Add New User'}
        </DialogTitle>
        <DialogContent>
          <Stack spacing={3} sx={{ mt: 1 }}>
            <TextField
              fullWidth
              label="Full Name"
              name="user_name"
              value={formData.user_name}
              onChange={handleFormChange}
              required
            />
            
            <TextField
              fullWidth
              label="Email"
              name="email"
              type="email"
              value={formData.email}
              onChange={handleFormChange}
              required
            />
            
            <TextField
              fullWidth
              label="Phone"
              name="phone"
              value={formData.phone}
              onChange={handleFormChange}
              required
            />
            
            {!editingUser && (
              <TextField
                fullWidth
                label="Password"
                name="password"
                type="password"
                value={formData.password}
                onChange={handleFormChange}
                required
                helperText="Password must be at least 10 characters"
              />
            )}
            
            <FormControl fullWidth>
              <InputLabel>Role</InputLabel>
              <Select
                value={formData.roles}
                label="Role"
                onChange={(e) => handleRoleChange(e.target.value)}
              >
                {roles.map((role) => (
                  <MenuItem key={role.value} value={role.value}>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                      {role.icon}
                      {role.label}
                    </Box>
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
          </Stack>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained">
            {editingUser ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)}>
        <DialogTitle>Confirm Delete</DialogTitle>
        <DialogContent>
          <Typography>
            Are you sure you want to delete user "{userToDelete?.user_name}"? This action cannot be undone.
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

export default UsersPage; 