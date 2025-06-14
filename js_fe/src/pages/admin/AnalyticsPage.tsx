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
  LinearProgress,
  Divider,
  List,
  ListItem,
  ListItemText,
  ListItemAvatar,
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
  TaskAlt,
  LocalHospital,
  PieChart,
  BarChart,
  Timeline,
  PersonAdd,
  PetsOutlined,
  HealthAndSafety,
  BusinessCenter,
} from '@mui/icons-material';
import dayjs from 'dayjs';
import apiService from '../../services/api';
import useAuthStore from '../../stores/authStore';
import type { ServiceBooking, Service, Pet, User, MedicalRecord } from '../../types/api';

interface AnalyticsData {
  // Financial Metrics
  totalRevenue: number;
  avgServicePrice: number;
  monthlyRevenue: number;
  projectedAnnualRevenue: number;
  
  // Booking Metrics
  totalBookings: number;
  completedBookings: number;
  pendingBookings: number;
  cancelledBookings: number;
  confirmedBookings: number;
  bookingCompletionRate: number;
  
  // Customer & Pet Metrics
  totalCustomers: number;
  totalPets: number;
  avgPetsPerCustomer: number;
  newCustomersThisMonth: number;
  newPetsThisMonth: number;
  
  // Medical & Health Metrics
  totalMedicalRecords: number;
  medicalRecordsThisMonth: number;
  mostCommonDiagnoses: Array<{ diagnosis: string; count: number }>;
  
  // Service Performance
  popularServices: Array<{ 
    id: number;
    name: string; 
    count: number; 
    revenue: number;
    avgPrice: number;
    category: string;
  }>;
  servicesByCategory: Array<{ category: string; count: number; revenue: number }>;
  
  // Demographics & Species
  petSpeciesDistribution: Array<{ species: string; count: number; percentage: number }>;
  petGenderDistribution: Array<{ gender: string; count: number; percentage: number }>;
  userRoleDistribution: Array<{ role: string; count: number; percentage: number }>;
  
  // Temporal Trends
  monthlyBookings: Array<{ month: string; count: number; revenue: number }>;
  dailyActivityThisWeek: Array<{ day: string; bookings: number; records: number }>;
  
  // Recent Activity
  recentActivity: Array<{ 
    type: 'booking' | 'medical' | 'user' | 'pet';
    title: string;
    description: string; 
    date: string;
    icon: string;
  }>;
}

const AnalyticsPage: React.FC = () => {
  const { user, isAdmin } = useAuthStore();
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

      // Load all necessary data in parallel
      const [bookings, services, pets, users, records] = await Promise.all([
        apiService.getAllBookings(),
        apiService.getAllServices(),
        apiService.getAllPets(),
        apiService.getAllUsers(),
        apiService.getAllMedicalRecords(),
      ]);

      console.log('Analytics data loaded:', {
        bookings: bookings.length,
        services: services.length,
        pets: pets.length,
        users: users.length,
        records: records.length
      });

      // Create analytics calculations
      const analytics = calculateAnalytics(bookings, services, pets, users, records);
      setAnalytics(analytics);
      
    } catch (err: any) {
      console.error('Failed to load analytics:', err);
      setError(err.message || 'Failed to load analytics data');
    } finally {
      setLoading(false);
    }
  };

  const calculateAnalytics = (
    bookings: ServiceBooking[],
    services: Service[],
    pets: Pet[],
    users: User[],
    records: MedicalRecord[]
  ): AnalyticsData => {
    const now = dayjs();
    const thisMonthStart = now.startOf('month');
    const servicesMap = new Map(services.map(s => [s.id, s]));

    // Financial Calculations
    const paidBookings = bookings.filter(b => b.status === 'COMPLETED' || b.status === 'CONFIRMED');
    const completedBookings = bookings.filter(b => b.status === 'COMPLETED');
    const pendingBookings = bookings.filter(b => b.status === 'PENDING');
    const cancelledBookings = bookings.filter(b => b.status === 'CANCELLED');
    const confirmedBookings = bookings.filter(b => b.status === 'CONFIRMED');

    let totalRevenue = 0;
    let monthlyRevenue = 0;
    const serviceStats = new Map<number, { count: number; revenue: number; name: string; category: string }>();

    paidBookings.forEach(booking => {
      const service = servicesMap.get(booking.service_id);
      if (service && service.price > 0) {
        totalRevenue += service.price;
        
        // Monthly revenue
        if (dayjs(booking.start_date).isAfter(thisMonthStart)) {
          monthlyRevenue += service.price;
        }
        
        // Service statistics
        const current = serviceStats.get(service.id) || { 
          count: 0, 
          revenue: 0, 
          name: service.service_name,
          category: service.category || 'Other'
        };
        serviceStats.set(service.id, {
          count: current.count + 1,
          revenue: current.revenue + service.price,
          name: service.service_name,
          category: service.category || 'Other'
        });
      }
    });

    // Booking metrics
    const bookingCompletionRate = bookings.length > 0 
      ? (completedBookings.length / bookings.length) * 100 
      : 0;

    // Customer & Pet metrics
    const customers = users.filter(u => u.roles === 'OWNER');
    const avgPetsPerCustomer = customers.length > 0 ? pets.length / customers.length : 0;
    
    const newCustomersThisMonth = customers.filter(c => 
      dayjs(c.created_at).isAfter(thisMonthStart)
    ).length;
    
    const newPetsThisMonth = pets.filter(p => 
      dayjs(p.created_at).isAfter(thisMonthStart)
    ).length;

    // Medical metrics
    const medicalRecordsThisMonth = records.filter(r => 
      dayjs(r.record_date).isAfter(thisMonthStart)
    ).length;

    // Most common diagnoses
    const diagnosisCount = new Map<string, number>();
    records.forEach(record => {
      if (record.diagnosis) {
        const diagnosis = record.diagnosis.toLowerCase().trim();
        diagnosisCount.set(diagnosis, (diagnosisCount.get(diagnosis) || 0) + 1);
      }
    });
    
    const mostCommonDiagnoses = Array.from(diagnosisCount.entries())
      .map(([diagnosis, count]) => ({ diagnosis, count }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 5);

    // Popular services
    const popularServices = Array.from(serviceStats.values())
      .map(stat => ({
        id: services.find(s => s.service_name === stat.name)?.id || 0,
        name: stat.name,
        count: stat.count,
        revenue: stat.revenue,
        avgPrice: stat.revenue / stat.count,
        category: stat.category
      }))
      .sort((a, b) => b.revenue - a.revenue)
      .slice(0, 10);

    // Services by category
    const categoryStats = new Map<string, { count: number; revenue: number }>();
    popularServices.forEach(service => {
      const current = categoryStats.get(service.category) || { count: 0, revenue: 0 };
      categoryStats.set(service.category, {
        count: current.count + service.count,
        revenue: current.revenue + service.revenue
      });
    });
    
    const servicesByCategory = Array.from(categoryStats.entries())
      .map(([category, stats]) => ({ category, ...stats }))
      .sort((a, b) => b.revenue - a.revenue);

    // Pet demographics
    const speciesCount = new Map<string, number>();
    const genderCount = new Map<string, number>();
    
    pets.forEach(pet => {
      speciesCount.set(pet.species, (speciesCount.get(pet.species) || 0) + 1);
      genderCount.set(pet.gender, (genderCount.get(pet.gender) || 0) + 1);
    });

    const petSpeciesDistribution = Array.from(speciesCount.entries())
      .map(([species, count]) => ({
        species,
        count,
        percentage: (count / pets.length) * 100
      }))
      .sort((a, b) => b.count - a.count);

    const petGenderDistribution = Array.from(genderCount.entries())
      .map(([gender, count]) => ({
        gender,
        count,
        percentage: (count / pets.length) * 100
      }))
      .sort((a, b) => b.count - a.count);

    // User role distribution
    const roleCount = new Map<string, number>();
    users.forEach(user => {
      roleCount.set(user.roles, (roleCount.get(user.roles) || 0) + 1);
    });

    const userRoleDistribution = Array.from(roleCount.entries())
      .map(([role, count]) => ({
        role,
        count,
        percentage: (count / users.length) * 100
      }))
      .sort((a, b) => b.count - a.count);

    // Monthly trends (last 6 months)
    const monthlyBookings = [];
    for (let i = 5; i >= 0; i--) {
      const month = dayjs().subtract(i, 'month');
      const monthBookings = bookings.filter(b => {
        const bookingMonth = dayjs(b.start_date);
        return bookingMonth.year() === month.year() && bookingMonth.month() === month.month();
      });
      
      let monthRevenue = 0;
      const monthPaidBookings = monthBookings.filter(b => b.status === 'COMPLETED' || b.status === 'CONFIRMED');
      monthPaidBookings.forEach(booking => {
        const service = servicesMap.get(booking.service_id);
        if (service && service.price > 0) {
          monthRevenue += service.price;
        }
      });

      monthlyBookings.push({
        month: month.format('MMM YYYY'),
        count: monthBookings.length,
        revenue: monthRevenue,
      });
    }

    // Daily activity this week
    const dailyActivityThisWeek = [];
    for (let i = 6; i >= 0; i--) {
      const day = dayjs().subtract(i, 'day');
      const dayBookings = bookings.filter(b => dayjs(b.start_date).isSame(day, 'day')).length;
      const dayRecords = records.filter(r => dayjs(r.record_date).isSame(day, 'day')).length;
      
      dailyActivityThisWeek.push({
        day: day.format('ddd'),
        bookings: dayBookings,
        records: dayRecords,
      });
    }

    // Recent activity
    const recentActivity = [
      ...bookings.slice(-5).map(b => ({
        type: 'booking' as const,
        title: 'New Booking',
        description: `Booking for ${servicesMap.get(b.service_id)?.service_name || 'Unknown Service'}`,
        date: b.start_date,
        icon: 'booking'
      })),
      ...records.slice(-5).map(r => ({
        type: 'medical' as const,
        title: 'Medical Record',
        description: `New medical record created`,
        date: r.record_date,
        icon: 'medical'
      })),
      ...pets.slice(-3).map(p => ({
        type: 'pet' as const,
        title: 'New Pet',
        description: `${p.name} (${p.species}) registered`,
        date: p.created_at || p.birth_date,
        icon: 'pet'
      })),
      ...customers.slice(-3).map(u => ({
        type: 'user' as const,
        title: 'New Customer',
        description: `${u.user_name} joined`,
        date: u.created_at || new Date().toISOString(),
        icon: 'user'
      }))
    ].sort((a, b) => dayjs(b.date).unix() - dayjs(a.date).unix()).slice(0, 15);

    return {
      // Financial
      totalRevenue,
      avgServicePrice: services.length > 0 ? services.reduce((sum, s) => sum + s.price, 0) / services.length : 0,
      monthlyRevenue,
      projectedAnnualRevenue: monthlyRevenue * 12,
      
      // Bookings
      totalBookings: bookings.length,
      completedBookings: completedBookings.length,
      pendingBookings: pendingBookings.length,
      cancelledBookings: cancelledBookings.length,
      confirmedBookings: confirmedBookings.length,
      bookingCompletionRate,
      
      // Customers & Pets
      totalCustomers: customers.length,
      totalPets: pets.length,
      avgPetsPerCustomer,
      newCustomersThisMonth,
      newPetsThisMonth,
      
      // Medical
      totalMedicalRecords: records.length,
      medicalRecordsThisMonth,
      mostCommonDiagnoses,
      
      // Services
      popularServices,
      servicesByCategory,
      
      // Demographics
      petSpeciesDistribution,
      petGenderDistribution,
      userRoleDistribution,
      
      // Trends
      monthlyBookings,
      dailyActivityThisWeek,
      recentActivity,
    };
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  const formatPercentage = (value: number) => {
    return `${value.toFixed(1)}%`;
  };

  const formatDate = (dateString: string) => {
    return dayjs(dateString).format('MMM DD, YYYY');
  };

  const getActivityIcon = (type: string) => {
    switch (type) {
      case 'booking': return <EventNote sx={{ fontSize: 16 }} />;
      case 'medical': return <MedicalServices sx={{ fontSize: 16 }} />;
      case 'pet': return <Pets sx={{ fontSize: 16 }} />;
      case 'user': return <PersonAdd sx={{ fontSize: 16 }} />;
      default: return <Assessment sx={{ fontSize: 16 }} />;
    }
  };

  const getActivityColor = (type: string) => {
    switch (type) {
      case 'booking': return '#2196F3';
      case 'medical': return '#4CAF50';
      case 'pet': return '#FF9800';
      case 'user': return '#9C27B0';
      default: return '#757575';
    }
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
          Comprehensive insights for the Pet Clinic System
        </Typography>
      </Box>

      <Grid container spacing={3}>
        {/* Top Financial Metrics Row */}
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
                    {formatCurrency(analytics.monthlyRevenue)}
                  </Typography>
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    This Month Revenue
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
                    {analytics.totalBookings}
                  </Typography>
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    Total Bookings
                  </Typography>
                </Box>
                <Avatar sx={{ bgcolor: '#FF9800' }}>
                  <EventNote />
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
                    {formatPercentage(analytics.bookingCompletionRate)}
                  </Typography>
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    Completion Rate
                  </Typography>
                </Box>
                <Avatar sx={{ bgcolor: '#9C27B0' }}>
                  <CheckCircle />
                </Avatar>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        {/* Booking Status Breakdown */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Booking Status Overview
              </Typography>
              <Grid container spacing={2} sx={{ mt: 1 }}>
                <Grid item xs={3}>
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
                <Grid item xs={3}>
                  <Box textAlign="center">
                    <Avatar sx={{ bgcolor: '#2196F3', mx: 'auto', mb: 1 }}>
                      <TaskAlt />
                    </Avatar>
                    <Typography variant="h6" sx={{ fontWeight: 600 }}>
                      {analytics.confirmedBookings}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      Confirmed
                    </Typography>
                  </Box>
                </Grid>
                <Grid item xs={3}>
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
                <Grid item xs={3}>
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

        {/* Customer & Pet Metrics */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Customer & Pet Metrics
              </Typography>
              <Grid container spacing={3} sx={{ mt: 1 }}>
                <Grid item xs={6}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
                    <Avatar sx={{ bgcolor: '#673AB7' }}>
                      <People />
                    </Avatar>
                    <Box>
                      <Typography variant="h6" sx={{ fontWeight: 600 }}>
                        {analytics.totalCustomers}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        Total Customers
                      </Typography>
                    </Box>
                  </Box>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                    <Avatar sx={{ bgcolor: '#795548' }}>
                      <Pets />
                    </Avatar>
                    <Box>
                      <Typography variant="h6" sx={{ fontWeight: 600 }}>
                        {analytics.totalPets}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        Total Pets
                      </Typography>
                    </Box>
                  </Box>
                </Grid>
                <Grid item xs={6}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
                    <Avatar sx={{ bgcolor: '#607D8B' }}>
                      <PersonAdd />
                    </Avatar>
                    <Box>
                      <Typography variant="h6" sx={{ fontWeight: 600 }}>
                        {analytics.newCustomersThisMonth}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        New This Month
                      </Typography>
                    </Box>
                  </Box>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                    <Avatar sx={{ bgcolor: '#FF5722' }}>
                      <PetsOutlined />
                    </Avatar>
                    <Box>
                      <Typography variant="h6" sx={{ fontWeight: 600 }}>
                        {analytics.avgPetsPerCustomer.toFixed(1)}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        Avg Pets/Customer
                      </Typography>
                    </Box>
                  </Box>
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        </Grid>

        {/* Popular Services */}
        <Grid item xs={12} md={8}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Top Performing Services
              </Typography>
              <TableContainer>
                <Table size="small">
                  <TableHead>
                    <TableRow>
                      <TableCell>Service</TableCell>
                      <TableCell>Category</TableCell>
                      <TableCell align="right">Bookings</TableCell>
                      <TableCell align="right">Revenue</TableCell>
                      <TableCell align="right">Avg Price</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {analytics.popularServices.slice(0, 8).map((service, index) => (
                      <TableRow key={index}>
                        <TableCell>{service.name}</TableCell>
                        <TableCell>
                          <Chip 
                            label={service.category} 
                            size="small" 
                            variant="outlined"
                          />
                        </TableCell>
                        <TableCell align="right">{service.count}</TableCell>
                        <TableCell align="right">{formatCurrency(service.revenue)}</TableCell>
                        <TableCell align="right">{formatCurrency(service.avgPrice)}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Pet Demographics */}
        <Grid item xs={12} md={4}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Pet Demographics
              </Typography>
              
              <Typography variant="subtitle2" sx={{ mt: 2, mb: 1, fontWeight: 600 }}>
                By Species
              </Typography>
              {analytics.petSpeciesDistribution.slice(0, 6).map((species, index) => (
                <Box key={index} sx={{ mb: 1 }}>
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 0.5 }}>
                    <Typography variant="body2">{species.species}</Typography>
                    <Typography variant="body2">{species.count} ({formatPercentage(species.percentage)})</Typography>
                  </Box>
                  <LinearProgress 
                    variant="determinate" 
                    value={species.percentage} 
                    sx={{ height: 6, borderRadius: 3 }}
                  />
                </Box>
              ))}
              
              <Divider sx={{ my: 2 }} />
              
              <Typography variant="subtitle2" sx={{ mb: 1, fontWeight: 600 }}>
                By Gender
              </Typography>
              {analytics.petGenderDistribution.map((gender, index) => (
                <Box key={index} sx={{ mb: 1 }}>
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 0.5 }}>
                    <Typography variant="body2">{gender.gender}</Typography>
                    <Typography variant="body2">{gender.count} ({formatPercentage(gender.percentage)})</Typography>
                  </Box>
                  <LinearProgress 
                    variant="determinate" 
                    value={gender.percentage} 
                    sx={{ height: 6, borderRadius: 3 }}
                  />
                </Box>
              ))}
            </CardContent>
          </Card>
        </Grid>

        {/* Medical Records Insights */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Medical Records Insights
              </Typography>
              
              <Grid container spacing={2} sx={{ mb: 3 }}>
                <Grid item xs={6}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                    <Avatar sx={{ bgcolor: '#4CAF50' }}>
                      <LocalHospital />
                    </Avatar>
                    <Box>
                      <Typography variant="h6" sx={{ fontWeight: 600 }}>
                        {analytics.totalMedicalRecords}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        Total Records
                      </Typography>
                    </Box>
                  </Box>
                </Grid>
                <Grid item xs={6}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                    <Avatar sx={{ bgcolor: '#2196F3' }}>
                      <HealthAndSafety />
                    </Avatar>
                    <Box>
                      <Typography variant="h6" sx={{ fontWeight: 600 }}>
                        {analytics.medicalRecordsThisMonth}
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        This Month
                      </Typography>
                    </Box>
                  </Box>
                </Grid>
              </Grid>

              <Typography variant="subtitle2" sx={{ mb: 2, fontWeight: 600 }}>
                Most Common Diagnoses
              </Typography>
              <List dense>
                {analytics.mostCommonDiagnoses.slice(0, 5).map((diagnosis, index) => (
                  <ListItem key={index} sx={{ px: 0 }}>
                    <ListItemAvatar sx={{ minWidth: 40 }}>
                      <Avatar sx={{ width: 32, height: 32, bgcolor: '#FF9800' }}>
                        <Typography variant="caption" sx={{ fontWeight: 600 }}>
                          {index + 1}
                        </Typography>
                      </Avatar>
                    </ListItemAvatar>
                    <ListItemText
                      primary={diagnosis.diagnosis}
                      secondary={`${diagnosis.count} cases`}
                      primaryTypographyProps={{ variant: 'body2', textTransform: 'capitalize' }}
                      secondaryTypographyProps={{ variant: 'caption' }}
                    />
                  </ListItem>
                ))}
              </List>
            </CardContent>
          </Card>
        </Grid>

        {/* Service Categories Performance */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Service Categories Performance
              </Typography>
              <TableContainer>
                <Table size="small">
                  <TableHead>
                    <TableRow>
                      <TableCell>Category</TableCell>
                      <TableCell align="right">Services</TableCell>
                      <TableCell align="right">Revenue</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {analytics.servicesByCategory.map((category, index) => (
                      <TableRow key={index}>
                        <TableCell>
                          <Chip 
                            label={category.category} 
                            size="small"
                            color={index % 2 === 0 ? 'primary' : 'secondary'}
                          />
                        </TableCell>
                        <TableCell align="right">{category.count}</TableCell>
                        <TableCell align="right">{formatCurrency(category.revenue)}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Monthly Performance Trends */}
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom sx={{ fontWeight: 600 }}>
                Monthly Performance Trends (Last 6 Months)
              </Typography>
              <TableContainer>
                <Table>
                  <TableHead>
                    <TableRow>
                      <TableCell>Month</TableCell>
                      <TableCell align="right">Bookings</TableCell>
                      <TableCell align="right">Revenue</TableCell>
                      <TableCell align="right">Avg Revenue/Booking</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {analytics.monthlyBookings.map((month, index) => (
                      <TableRow key={index}>
                        <TableCell sx={{ fontWeight: 500 }}>{month.month}</TableCell>
                        <TableCell align="right">{month.count}</TableCell>
                        <TableCell align="right">{formatCurrency(month.revenue)}</TableCell>
                        <TableCell align="right">
                          {month.count > 0 ? formatCurrency(month.revenue / month.count) : '$0.00'}
                        </TableCell>
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
                Recent System Activity
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
                        py: 1.5,
                        borderBottom: index < analytics.recentActivity.length - 1 ? '1px solid' : 'none',
                        borderColor: 'divider',
                      }}
                    >
                      <Avatar
                        sx={{
                          width: 32,
                          height: 32,
                          bgcolor: getActivityColor(activity.type),
                        }}
                      >
                        {getActivityIcon(activity.type)}
                      </Avatar>
                      <Box sx={{ flexGrow: 1 }}>
                        <Typography variant="body2" sx={{ fontWeight: 500 }}>
                          {activity.title}
                        </Typography>
                        <Typography variant="body2" color="text.secondary">
                          {activity.description}
                        </Typography>
                      </Box>
                      <Typography variant="caption" color="text.secondary">
                        {formatDate(activity.date)}
                      </Typography>
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