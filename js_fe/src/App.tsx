import React, { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { Box, CircularProgress } from '@mui/material';
import useAuthStore from './stores/authStore';

// Layout Components
import MainLayout from './components/Layout/MainLayout';
import ProtectedRoute from './components/ProtectedRoute';

// Auth Pages
import LoginPage from './pages/auth/LoginPage';
import RegisterPage from './pages/auth/RegisterPage';

// Dashboard Pages
import DashboardPage from './pages/dashboard/DashboardPage';

// Owner Pages
import MyPetsPage from './pages/owner/MyPetsPage';
import MyBookingsPage from './pages/owner/MyBookingsPage';

// Admin Pages
import UsersPage from './pages/admin/UsersPage';
import AllPetsPage from './pages/admin/AllPetsPage';
import AllBookingsPage from './pages/admin/AllBookingsPage';
import ServicesPage from './pages/admin/ServicesPage';
import CagesPage from './pages/admin/CagesPage';
import AnalyticsPage from './pages/admin/AnalyticsPage';

// Common Pages
import MedicalRecordsPage from './pages/common/MedicalRecordsPage';
import ProfilePage from './pages/common/ProfilePage';
import AccessDeniedPage from './pages/common/AccessDeniedPage';

// Root component that handles initial routing logic
const AppRouter: React.FC = () => {
  const { isAuthenticated, isLoading, getCurrentUser } = useAuthStore();

  // Try to restore user session on app start
  useEffect(() => {
    const restoreSession = async () => {
      try {
        await getCurrentUser();
      } catch (error) {
        console.log('No active session found');
      }
    };

    // Only try to restore session if we're not already authenticated
    if (!isAuthenticated) {
      restoreSession();
    }
  }, [getCurrentUser, isAuthenticated]);

  // Show loading spinner during initial authentication check
  if (isLoading) {
    return (
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        minHeight="100vh"
        sx={{ 
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          color: 'white'
        }}
      >
        <Box textAlign="center">
          <CircularProgress size={40} sx={{ color: 'white', mb: 2 }} />
          <Box>Loading Pet Clinic System...</Box>
        </Box>
      </Box>
    );
  }

  return (
    <Routes>
      {/* Root route - redirect based on authentication */}
      <Route path="/" element={
        isAuthenticated ? <Navigate to="/dashboard" replace /> : <Navigate to="/login" replace />
      } />

      {/* Public Routes */}
      <Route path="/login" element={
        isAuthenticated ? <Navigate to="/dashboard" replace /> : <LoginPage />
      } />
      <Route path="/register" element={
        isAuthenticated ? <Navigate to="/dashboard" replace /> : <RegisterPage />
      } />
      <Route path="/access-denied" element={<AccessDeniedPage />} />

      {/* Protected Routes with Layout */}
      <Route path="/" element={
        <ProtectedRoute>
          <MainLayout />
        </ProtectedRoute>
      }>
        {/* Common Protected Routes */}
        <Route path="dashboard" element={<DashboardPage />} />
        <Route path="profile" element={<ProfilePage />} />
        <Route path="medical-records" element={<MedicalRecordsPage />} />
        
        {/* Owner-specific Routes */}
        <Route path="my-pets" element={
          <ProtectedRoute requiredRole="OWNER">
            <MyPetsPage />
          </ProtectedRoute>
        } />
        <Route path="my-bookings" element={
          <ProtectedRoute requiredRole="OWNER">
            <MyBookingsPage />
          </ProtectedRoute>
        } />
        
        {/* Admin-specific Routes */}
        <Route path="users" element={
          <ProtectedRoute requiredRole="ADMIN">
            <UsersPage />
          </ProtectedRoute>
        } />
        <Route path="services" element={
          <ProtectedRoute requiredRole="ADMIN">
            <ServicesPage />
          </ProtectedRoute>
        } />
        
        {/* Staff/Admin/Doctor Routes */}
        <Route path="pets" element={
          <ProtectedRoute>
            <AllPetsPage />
          </ProtectedRoute>
        } />
        <Route path="bookings" element={
          <ProtectedRoute>
            <AllBookingsPage />
          </ProtectedRoute>
        } />
        <Route path="cages" element={
          <ProtectedRoute>
            <CagesPage />
          </ProtectedRoute>
        } />
        <Route path="analytics" element={
          <ProtectedRoute requiredRole="ADMIN">
            <AnalyticsPage />
          </ProtectedRoute>
        } />
      </Route>

      {/* Catch all route - redirect to appropriate page */}
      <Route path="*" element={
        isAuthenticated ? <Navigate to="/dashboard" replace /> : <Navigate to="/login" replace />
      } />
    </Routes>
  );
};

function App() {
  return <AppRouter />;
}

export default App;
