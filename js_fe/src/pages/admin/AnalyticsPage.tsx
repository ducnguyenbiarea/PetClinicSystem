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
  Chip,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Avatar,
} from '@mui/material';
import {
  TrendingUp,
  AttachMoney,
  EventNote,
  Pets,
  MedicalServices,
  People,
  Assessment,
  CheckCircle,
  Schedule,
  Cancel,
} from '@mui/icons-material';
import dayjs from 'dayjs';
import apiService from '../../services/api';
import useAuthStore from '../../stores/authStore';
import type { ServiceBooking, Service, Pet, User, MedicalRecord } from '../../types/api';

interface AnalyticsData {
  totalRevenue: number;
  avgServicePrice: number;
  totalBookings: number;
  completedBookings: number;
  pendingBookings: number;
  cancelledBookings: number;
  totalPets: number;
  totalCustomers: number;
  totalMedicalRecords: number;
  popularServices: Array<{ name: string; count: number; revenue: number }>;
  monthlyBookings: Array<{ month: string; count: number; revenue: number }>;
  recentActivity: Array<{ type: string; description: string; date: string }>;
}

const AnalyticsPage: React.FC = () => {
  const { user, isAdmin, isDoctor, isStaff } = useAuthStore();
  const [analytics, setAnalytics] = useState<AnalyticsData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!isAdmin()) {
      setError('Access denied. Analytics are only available for Admin users.');
      setLoading(false);
      return;
    }
    
    loadAnalytics();
  }, [isAdmin]);

  const loadAnalytics = async () => {
    try {
      setLoading(true);
      setError(null);

      // Load all necessary data
      const [bookings, services, pets, users, records] = await Promise.all([
        apiService.getAllBookings(),
        apiService.getAllServices(),
        apiService.getAllPets(),
        apiService.getAllUsers(),
        apiService.getAllMedicalRecords(),
      ]);

      // Calculate analytics
      const servicesMap = new Map(services.map(s => [s.id, s]));
      
      // Revenue calculations - sum all completed booking service prices
      let totalRevenue = 0;
      const serviceStats = new Map<number, { count: number; revenue: number; name: string }>();
      
      // Calculate revenue based on completed bookings
      const completedBookings = bookings.filter(b => b.status === 'COMPLETED');
      
      completedBookings.forEach(booking => {
        const service = servicesMap.get(booking.service_id);
        if (service) {
          totalRevenue += service.price;
          
          const current = serviceStats.get(service.id) || { count: 0, revenue: 0, name: service.service_name };
          serviceStats.set(service.id, {
            count: current.count + 1,
            revenue: current.revenue + service.price,
            name: service.service_name,
          });
        }
      });

      // Booking status counts
      const pendingBookings = bookings.filter(b => b.status === 'PENDING').length;
      const cancelledBookings = bookings.filter(b => b.status === 'CANCELLED').length;

      // Popular services
      const popularServices = Array.from(serviceStats.values())
        .sort((a, b) => b.revenue - a.revenue)
        .slice(0, 5);

      // Monthly data (last 6 months) - based on booking start dates
      const monthlyBookings = [];
      for (let i = 5; i >= 0; i--) {
        const month = dayjs().subtract(i, 'month');
        const monthBookings = bookings.filter(b => {
          const bookingMonth = dayjs(b.start_date);
          return bookingMonth.year() === month.year() && bookingMonth.month() === month.month();
        });
        
        // Calculate revenue for completed bookings in this month
        let monthRevenue = 0;
        const monthCompletedBookings = monthBookings.filter(b => b.status === 'COMPLETED');
        monthCompletedBookings.forEach(booking => {
          const service = servicesMap.get(booking.service_id);
          if (service) {
            monthRevenue += service.price;
          }
        });

        monthlyBookings.push({
          month: month.format('MMM YYYY'),
          count: monthBookings.length,
          revenue: monthRevenue,
        });
      }

      // Recent activity
      const recentActivity = [
        ...bookings.slice(-5).map(b => ({
          type: 'booking',
          description: `New booking for ${servicesMap.get(b.service_id)?.service_name || 'service'}`,
          date: b.start_date,
        })),
        ...records.slice(-3).map(r => ({
          type: 'medical',
          description: `Medical record created`,
          date: r.record_date,
        })),
      ].sort((a, b) => dayjs(b.date).unix() - dayjs(a.date).unix()).slice(0, 10);

      const analyticsData: AnalyticsData = {
        totalRevenue,
        avgServicePrice: services.length > 0 ? services.reduce((sum, s) => sum + s.price, 0) / services.length : 0,
        totalBookings: bookings.length,
        completedBookings: completedBookings.length,
        pendingBookings,
        cancelledBookings,
        totalPets: pets.length,
        totalCustomers: users.filter(u => u.roles === 'OWNER').length,
        totalMedicalRecords: records.length,
        popularServices,
        monthlyBookings,
        recentActivity,
      };

      setAnalytics(analyticsData);
    } catch (err: any) {
      setError(err.message || 'Failed to load analytics data');
    } finally {
      setLoading(false);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  const formatDate = (dateString: string) => {
    return dayjs(dateString).format('MMM DD, YYYY');
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress size={40} />
      </Box>
    );
  }

  if (error) {
    return (
      <Box>
        <Alert severity="error">{error}</Alert>
      </Box>
    );
  }

  if (!analytics) {
    return (
      <Box>
        <Alert severity="info">No analytics data available</Alert>
      </Box>
    );
  }

  return (
    <Box>
      {/* Header */}
      <Box mb={4}>
        <Typography variant="h4" component="h1" gutterBottom sx={{ fontWeight: 600 }}>
          Analytics Dashboard
        </Typography>
        <Typography variant="body1" color="text.secondary">
          Financial and operational insights for the Pet Clinic System
        </Typography>
      </Box>

      <Grid container spacing={3}>
        {/* Financial Metrics */}
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <Box>
                  <Typography variant="h4" component="div" sx={{ fontWeight: 600, color: '#4CAF50' }}>
                    {formatCurrency(analytics.totalRevenue)}
                  </Typography>
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    Total Revenue
                  </Typography>
                </Box>
                <Avatar sx={{ bgcolor: '#4CAF50' }}>
                  <AttachMoney />
                </Avatar>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <Box>
                  <Typography variant="h4" component="div" sx={{ fontWeight: 600, color: '#2196F3' }}>
                    {formatCurrency(analytics.avgServicePrice)}
                  </Typography>
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    Avg Service Price
                  </Typography>
                </Box>
                <Avatar sx={{ bgcolor: '#2196F3' }}>
                  <TrendingUp />
                </Avatar>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <Box>
                  <Typography variant="h4" component="div" sx={{ fontWeight: 600, color: '#FF9800' }}>
                    {analytics.completedBookings}
                  </Typography>
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    Completed Bookings
                  </Typography>
                </Box>
                <Avatar sx={{ bgcolor: '#FF9800' }}>
                  <CheckCircle />
                </Avatar>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <Box>
                  <Typography variant="h4" component="div" sx={{ fontWeight: 600, color: '#9C27B0' }}>
                    {analytics.totalCustomers}
                  </Typography>
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    Total Customers
                  </Typography>
                </Box>
                <Avatar sx={{ bgcolor: '#9C27B0' }}>
                  <People />
                </Avatar>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        {/* Booking Status Overview */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Booking Status Overview
              </Typography>
              <Grid container spacing={2} sx={{ mt: 1 }}>
                <Grid item xs={4}>
                  <Box textAlign="center">
                    <Avatar sx={{ bgcolor: '#4CAF50', mx: 'auto', mb: 1 }}>
                      <CheckCircle />
                    </Avatar>
                    <Typography variant="h6" sx={{ fontWeight: 600 }}>
                      {analytics.completedBookings}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      Completed
                    </Typography>
                  </Box>
                </Grid>
                <Grid item xs={4}>
                  <Box textAlign="center">
                    <Avatar sx={{ bgcolor: '#FF9800', mx: 'auto', mb: 1 }}>
                      <Schedule />
                    </Avatar>
                    <Typography variant="h6" sx={{ fontWeight: 600 }}>
                      {analytics.pendingBookings}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      Pending
                    </Typography>
                  </Box>
                </Grid>
                <Grid item xs={4}>
                  <Box textAlign="center">
                    <Avatar sx={{ bgcolor: '#F44336', mx: 'auto', mb: 1 }}>
                      <Cancel />
                    </Avatar>
                    <Typography variant="h6" sx={{ fontWeight: 600 }}>
                      {analytics.cancelledBookings}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      Cancelled
                    </Typography>
                  </Box>
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        </Grid>

        {/* Popular Services */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Popular Services
              </Typography>
              <TableContainer>
                <Table size="small">
                  <TableHead>
                    <TableRow>
                      <TableCell>Service</TableCell>
                      <TableCell align="right">Bookings</TableCell>
                      <TableCell align="right">Revenue</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {analytics.popularServices.map((service, index) => (
                      <TableRow key={index}>
                        <TableCell>{service.name}</TableCell>
                        <TableCell align="right">{service.count}</TableCell>
                        <TableCell align="right">{formatCurrency(service.revenue)}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Monthly Trends */}
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Monthly Performance (Last 6 Months)
              </Typography>
              <TableContainer>
                <Table>
                  <TableHead>
                    <TableRow>
                      <TableCell>Month</TableCell>
                      <TableCell align="right">Bookings</TableCell>
                      <TableCell align="right">Revenue</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {analytics.monthlyBookings.map((month, index) => (
                      <TableRow key={index}>
                        <TableCell>{month.month}</TableCell>
                        <TableCell align="right">{month.count}</TableCell>
                        <TableCell align="right">{formatCurrency(month.revenue)}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Recent Activity */}
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Recent Activity
              </Typography>
              <Box sx={{ mt: 2 }}>
                {analytics.recentActivity.length === 0 ? (
                  <Typography variant="body2" color="text.secondary" align="center" sx={{ py: 2 }}>
                    No recent activity
                  </Typography>
                ) : (
                  analytics.recentActivity.map((activity, index) => (
                    <Box
                      key={index}
                      sx={{
                        display: 'flex',
                        alignItems: 'center',
                        gap: 2,
                        py: 1,
                        borderBottom: index < analytics.recentActivity.length - 1 ? '1px solid' : 'none',
                        borderColor: 'divider',
                      }}
                    >
                      <Avatar
                        sx={{
                          width: 32,
                          height: 32,
                          bgcolor: activity.type === 'booking' ? '#2196F3' : '#FF9800',
                        }}
                      >
                        {activity.type === 'booking' ? <EventNote sx={{ fontSize: 16 }} /> : <MedicalServices sx={{ fontSize: 16 }} />}
                      </Avatar>
                      <Box sx={{ flexGrow: 1 }}>
                        <Typography variant="body2">{activity.description}</Typography>
                        <Typography variant="caption" color="text.secondary">
                          {formatDate(activity.date)}
                        </Typography>
                      </Box>
                    </Box>
                  ))
                )}
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default AnalyticsPage; 