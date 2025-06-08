import React, { useState, useEffect } from 'react';
import {
  Box,
  Paper,
  TextField,
  Button,
  Typography,
  Container,
  Alert,
  CircularProgress,
  Link,
  Grid,
  Divider,
  Stack,
} from '@mui/material';
import { useNavigate, Link as RouterLink, useLocation } from 'react-router-dom';
import { Login, Pets } from '@mui/icons-material';
import useAuthStore from '../../stores/authStore';
import type { LoginRequest } from '../../types/auth';

const LoginPage: React.FC = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { login, isAuthenticated, isLoading, error, clearError } = useAuthStore();

  const [formData, setFormData] = useState<LoginRequest>({
    username: '',
    password: '',
  });

  // Get the intended destination from location state or default to dashboard
  const from = location.state?.from?.pathname || '/dashboard';

  // Redirect if already authenticated
  useEffect(() => {
    if (isAuthenticated) {
      navigate(from, { replace: true });
    }
  }, [isAuthenticated, navigate, from]);

  // Clear error when component mounts
  useEffect(() => {
    clearError();
  }, [clearError]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }));
    
    // Clear error when user starts typing
    if (error) {
      clearError();
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!formData.username || !formData.password) {
      return;
    }

    try {
      await login(formData);
      // Redirect will happen automatically due to useEffect above
    } catch (err) {
      // Error is handled by the store
      console.error('Login failed:', err);
    }
  };

  // Test account login handlers
  const handleTestLogin = async (email: string, password: string, role: string) => {
    try {
      await login({ username: email, password });
    } catch (err) {
      console.error(`${role} login failed:`, err);
    }
  };

  const testAccounts = [
    { role: 'Admin', email: 'admin@example.com', password: 'admin123', color: 'error' as const },
    { role: 'Doctor', email: 'doctor@example.com', password: 'doctor123', color: 'success' as const },
    { role: 'Staff', email: 'staff@example.com', password: 'staff123', color: 'warning' as const },
    { role: 'Owner', email: 'owner@example.com', password: 'owner123', color: 'primary' as const },
  ];

  return (
    <Box
      sx={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        py: 3,
      }}
    >
      <Container maxWidth="lg">
        <Grid container spacing={4} alignItems="center" justifyContent="center">
          {/* Left side - Welcome message */}
          <Grid item xs={12} md={6}>
            <Box sx={{ textAlign: { xs: 'center', md: 'left' }, color: 'white', mb: { xs: 3, md: 0 } }}>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: { xs: 'center', md: 'flex-start' }, mb: 2 }}>
                <Pets sx={{ fontSize: 48, mr: 2 }} />
                <Typography variant="h3" component="h1" sx={{ fontWeight: 700 }}>
                  Pet Clinic
                </Typography>
              </Box>
              <Typography variant="h5" sx={{ mb: 2, opacity: 0.9 }}>
                Welcome Back!
              </Typography>
              <Typography variant="body1" sx={{ opacity: 0.8, mb: 3 }}>
                Sign in to manage your pet's health records, book appointments, and access all our veterinary services.
              </Typography>
              
              {/* Test Accounts for Development */}
              <Box sx={{ mt: 4 }}>
                <Typography variant="h6" sx={{ mb: 2, opacity: 0.9 }}>
                  Quick Test Login:
                </Typography>
                <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap sx={{ gap: 1 }}>
                  {testAccounts.map((account) => (
                    <Button
                      key={account.role}
                      size="small"
                      variant="outlined"
                      color={account.color}
                      disabled={isLoading}
                      onClick={() => handleTestLogin(account.email, account.password, account.role)}
                      sx={{
                        color: 'white',
                        borderColor: 'rgba(255, 255, 255, 0.5)',
                        '&:hover': {
                          borderColor: 'white',
                          backgroundColor: 'rgba(255, 255, 255, 0.1)',
                        },
                      }}
                    >
                      {account.role}
                    </Button>
                  ))}
                </Stack>
              </Box>
            </Box>
          </Grid>

          {/* Right side - Login form */}
          <Grid item xs={12} md={6}>
            <Paper
              elevation={24}
              sx={{
                p: 4,
                borderRadius: 3,
                backdropFilter: 'blur(10px)',
                backgroundColor: 'rgba(255, 255, 255, 0.95)',
              }}
            >
              <Box sx={{ textAlign: 'center', mb: 3 }}>
                <Login sx={{ fontSize: 48, color: 'primary.main', mb: 1 }} />
                <Typography variant="h4" component="h2" sx={{ fontWeight: 600, mb: 1 }}>
                  Sign In
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  Enter your credentials to access your account
                </Typography>
              </Box>

              {error && (
                <Alert severity="error" sx={{ mb: 3 }}>
                  {error}
                </Alert>
              )}

              <Box component="form" onSubmit={handleSubmit} sx={{ mt: 2 }}>
                <TextField
                  fullWidth
                  id="username"
                  name="username"
                  label="Email Address"
                  type="email"
                  value={formData.username}
                  onChange={handleChange}
                  required
                  autoComplete="email"
                  autoFocus
                  sx={{ mb: 2 }}
                />

                <TextField
                  fullWidth
                  id="password"
                  name="password"
                  label="Password"
                  type="password"
                  value={formData.password}
                  onChange={handleChange}
                  required
                  autoComplete="current-password"
                  sx={{ mb: 3 }}
                />

                <Button
                  type="submit"
                  fullWidth
                  variant="contained"
                  size="large"
                  disabled={isLoading}
                  sx={{ mb: 2 }}
                >
                  {isLoading ? (
                    <CircularProgress size={24} color="inherit" />
                  ) : (
                    'Sign In'
                  )}
                </Button>

                <Divider sx={{ my: 2 }}>
                  <Typography variant="body2" color="text.secondary">
                    or
                  </Typography>
                </Divider>

                <Box sx={{ textAlign: 'center' }}>
                  <Typography variant="body2" color="text.secondary">
                    Don't have an account?{' '}
                    <Link component={RouterLink} to="/register" underline="hover">
                      Sign up
                    </Link>
                  </Typography>
                </Box>
              </Box>
            </Paper>
          </Grid>
        </Grid>
      </Container>
    </Box>
  );
};

export default LoginPage; 