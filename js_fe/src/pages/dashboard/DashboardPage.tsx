import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
  Grid,
  Card,
  CardContent,
  Paper,
  CircularProgress,
  Alert,
  Avatar,
  Chip,
  Button,
} from '@mui/material';
import {
  People,
  Pets,
  EventNote,
  MedicalServices,
  Person,
  Email,
  Shield,
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import useAuthStore from '../../stores/authStore';
import apiService from '../../services/api';

interface StatCard {
  title: string;
  value: number;
  icon: React.ReactNode;
  color: string;
  loading?: boolean;
}

const DashboardPage: React.FC = () => {
  const { user, isAdmin, isDoctor, isStaff, isOwner } = useAuthStore();
  const navigate = useNavigate();
  const [stats, setStats] = useState<StatCard[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const loadDashboardData = async () => {
      try {
        setLoading(true);
        setError(null);

        const statsData: StatCard[] = [];

        if (isOwner()) {
          // Owner-specific stats
          const [myPets, myBookings] = await Promise.all([
            apiService.getMyPets(),
            apiService.getMyBookings(),
          ]);

          // Get medical records for owner's pets
          let recordsCount = 0;
          if (myPets.length > 0) {
            const petRecords = await Promise.all(
              myPets.map(pet => apiService.getMedicalRecordsByPetId(pet.id))
            );
            recordsCount = petRecords.flat().length;
          }

          statsData.push(
            {
              title: 'My Pets',
              value: myPets.length,
              icon: <Pets />,
              color: '#4CAF50',
            },
            {
              title: 'My Bookings',
              value: myBookings.length,
              icon: <EventNote />,
              color: '#2196F3',
            },
            {
              title: 'Medical Records',
              value: recordsCount,
              icon: <MedicalServices />,
              color: '#FF9800',
            }
          );
        } else {
          // Admin/Staff/Doctor stats
          const promises = [];
          
          if (isAdmin()) {
            promises.push(
              apiService.getAllUsers(),
              apiService.getAllPets(),
              apiService.getAllBookings(),
              apiService.getAllMedicalRecords()
            );
          } else {
            promises.push(
              apiService.getAllPets(),
              apiService.getAllBookings(),
              apiService.getAllMedicalRecords()
            );
          }

          const results = await Promise.all(promises);

          if (isAdmin()) {
            const [users, pets, bookings, records] = results;
            statsData.push(
              {
                title: 'Total Users',
                value: users.length,
                icon: <People />,
                color: '#9C27B0',
              },
              {
                title: 'Total Pets',
                value: pets.length,
                icon: <Pets />,
                color: '#4CAF50',
              },
              {
                title: 'All Bookings',
                value: bookings.length,
                icon: <EventNote />,
                color: '#2196F3',
              },
              {
                title: 'Medical Records',
                value: records.length,
                icon: <MedicalServices />,
                color: '#FF9800',
              }
            );
          } else {
            const [pets, bookings, records] = results;
            statsData.push(
              {
                title: 'Total Pets',
                value: pets.length,
                icon: <Pets />,
                color: '#4CAF50',
              },
              {
                title: 'All Bookings',
                value: bookings.length,
                icon: <EventNote />,
                color: '#2196F3',
              },
              {
                title: 'Medical Records',
                value: records.length,
                icon: <MedicalServices />,
                color: '#FF9800',
              }
            );
          }
        }

        setStats(statsData);
      } catch (err) {
        console.error('Failed to load dashboard data:', err);
        setError('Failed to load dashboard data. Please try again.');
      } finally {
        setLoading(false);
      }
    };

    loadDashboardData();
  }, [isAdmin, isDoctor, isStaff, isOwner]);

  const getWelcomeMessage = () => {
    if (!user) return 'Welcome to Pet Clinic System';
    
    const name = user.user_name || user.email;
    const role = user.roles.toLowerCase();
    
    return `Welcome back, ${name}!`;
  };

  const getRoleColor = () => {
    switch (user?.roles) {
      case 'ADMIN': return '#f44336';
      case 'DOCTOR': return '#4caf50';
      case 'STAFF': return '#ff9800';
      case 'OWNER': return '#2196f3';
      default: return '#9e9e9e';
    }
  };

  const getProfileGradient = () => {
    switch (user?.roles) {
      case 'ADMIN': return 'linear-gradient(135deg, #6366f1 0%, #4f46e5 100%)';
      case 'DOCTOR': return 'linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%)';
      case 'STAFF': return 'linear-gradient(135deg, #64748b 0%, #475569 100%)';
      case 'OWNER': return 'linear-gradient(135deg, #74b9ff 0%, #0984e3 100%)';
      default: return 'linear-gradient(135deg, #ddd6fe 0%, #8b5cf6 100%)';
    }
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
      <Box mb={4}>
        <Typography variant="h4" component="h1" gutterBottom sx={{ fontWeight: 600 }}>
          Dashboard
        </Typography>
        <Typography variant="h6" color="text.secondary" gutterBottom>
          {getWelcomeMessage()}
        </Typography>
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }}>
          {error}
        </Alert>
      )}

      <Grid container spacing={3}>
        {/* Statistics Cards */}
        {stats.map((stat, index) => (
          <Grid item xs={12} sm={6} md={3} key={index}>
            <Card sx={{ height: '100%' }}>
              <CardContent>
                <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <Box>
                    <Typography variant="h4" component="div" sx={{ fontWeight: 600, color: stat.color }}>
                      {stat.value}
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                      {stat.title}
                    </Typography>
                  </Box>
                  <Box sx={{ color: stat.color, opacity: 0.7 }}>
                    {stat.icon}
                  </Box>
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}

        {/* Colorful Profile Section */}
        <Grid item xs={12} md={6}>
          <Card 
            sx={{ 
              height: '100%',
              background: getProfileGradient(),
              color: 'white',
              position: 'relative',
              overflow: 'hidden',
              '&::before': {
                content: '""',
                position: 'absolute',
                top: 0,
                right: 0,
                width: '100px',
                height: '100px',
                background: 'rgba(255, 255, 255, 0.1)',
                borderRadius: '50%',
                transform: 'translate(30px, -30px)',
              }
            }}
          >
            <CardContent sx={{ position: 'relative', zIndex: 1 }}>
              <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 600, mb: 3 }}>
                <Person sx={{ mr: 1, verticalAlign: 'middle' }} />
                Profile
              </Typography>
              
              <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
                <Avatar 
                  sx={{ 
                    width: 60, 
                    height: 60, 
                    mr: 2, 
                    bgcolor: 'rgba(255, 255, 255, 0.2)',
                    fontSize: '24px',
                    fontWeight: 600
                  }}
                >
                  {user?.user_name?.charAt(0)?.toUpperCase() || 'U'}
                </Avatar>
                <Box>
                  <Typography variant="h6" sx={{ fontWeight: 600 }}>
                    {user?.user_name || 'User'}
                  </Typography>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mt: 1 }}>
                    <Email sx={{ fontSize: 16 }} />
                    <Typography variant="body2" sx={{ opacity: 0.9 }}>
                      {user?.email}
                    </Typography>
                  </Box>
                </Box>
              </Box>

              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 3 }}>
                <Shield sx={{ fontSize: 20 }} />
                <Chip 
                  label={user?.roles} 
                  sx={{ 
                    bgcolor: 'rgba(255, 255, 255, 0.2)', 
                    color: 'white',
                    fontWeight: 600,
                  }} 
                />
              </Box>

              <Button 
                variant="contained"
                onClick={() => navigate('/profile')}
                sx={{ 
                  bgcolor: 'rgba(255, 255, 255, 0.2)', 
                  color: 'white',
                  '&:hover': {
                    bgcolor: 'rgba(255, 255, 255, 0.3)',
                  }
                }}
              >
                Edit Profile
              </Button>
            </CardContent>
          </Card>
        </Grid>

        {/* Recent Activity */}
        <Grid item xs={12} md={6}>
          <Card sx={{ height: '100%' }}>
            <CardContent>
              <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 600 }}>
                Recent Activity
              </Typography>
              <Box sx={{ mt: 2 }}>
                <Typography variant="body2" color="text.secondary" align="center" sx={{ py: 4 }}>
                  Activity tracking coming soon...
                </Typography>
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default DashboardPage; 