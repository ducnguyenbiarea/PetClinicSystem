import React from 'react';
import {
  Box,
  Drawer,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Typography,
  Divider,
  Chip,
} from '@mui/material';
import {
  Dashboard,
  Pets,
  CalendarMonth,
  Assignment,
  HomeWork,
  AccountCircle,
  Analytics,
  Assessment,
} from '@mui/icons-material';
import { useNavigate, useLocation } from 'react-router-dom';
import useAuthStore from '../../stores/authStore';

interface SidebarProps {
  open: boolean;
  onClose: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({ open, onClose }) => {
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useAuthStore();

  const handleNavigation = (path: string) => {
    navigate(path);
    onClose();
  };

  const isActive = (path: string) => {
    return location.pathname === path;
  };

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'ADMIN': return 'error';
      case 'DOCTOR': return 'success';
      case 'STAFF': return 'warning';
      case 'OWNER': return 'primary';
      default: return 'default';
    }
  };

  const menuItems = [
    {
      title: 'Dashboard',
      icon: <Dashboard />,
      path: '/dashboard',
      roles: ['ADMIN', 'DOCTOR', 'STAFF', 'OWNER']
    },
    {
      title: 'My Pets',
      icon: <Pets />,
      path: '/my-pets',
      roles: ['OWNER']
    },
    {
      title: 'My Bookings',
      icon: <CalendarMonth />,
      path: '/my-bookings',
      roles: ['OWNER']
    },
    {
      title: 'All Pets',
      icon: <Pets />,
      path: '/pets',
      roles: ['ADMIN', 'DOCTOR', 'STAFF']
    },
    {
      title: 'All Bookings',
      icon: <CalendarMonth />,
      path: '/bookings',
      roles: ['ADMIN', 'DOCTOR', 'STAFF']
    },
    {
      title: 'Medical Records',
      icon: <Assignment />,
      path: '/medical-records',
      roles: ['ADMIN', 'DOCTOR', 'STAFF', 'OWNER']
    },
    {
      title: 'Users',
      icon: <AccountCircle />,
      path: '/users',
      roles: ['ADMIN']
    },
    {
      title: 'Services',
      icon: <Assignment />,
      path: '/services',
      roles: ['ADMIN']
    },
    {
      title: 'Analytics',
      icon: <Analytics />,
      path: '/analytics',
      roles: ['ADMIN']
    },
    {
      title: 'Cages',
      icon: <HomeWork />,
      path: '/cages',
      roles: ['ADMIN', 'STAFF']
    },
  ];

  const filteredMenuItems = menuItems.filter(item => 
    user && item.roles.includes(user.roles)
  );

  const drawerContent = (
    <Box sx={{ width: 280, height: '100%' }}>
      {/* Header */}
      <Box sx={{ p: 3, borderBottom: '1px solid', borderColor: 'divider' }}>
        <Typography variant="h6" sx={{ fontWeight: 600, mb: 1 }}>
          Pet Clinic
        </Typography>
        {user && (
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Typography variant="body2" color="text.secondary">
              {user.user_name}
            </Typography>
            <Chip 
              label={user.roles} 
              size="small" 
              color={getRoleColor(user.roles) as any}
            />
          </Box>
        )}
      </Box>

      {/* Navigation */}
      <List sx={{ pt: 2 }}>
        {filteredMenuItems.map((item) => (
          <ListItem key={item.path} disablePadding>
            <ListItemButton
              onClick={() => handleNavigation(item.path)}
              selected={isActive(item.path)}
              sx={{
                mx: 1,
                borderRadius: 1,
                '&.Mui-selected': {
                  backgroundColor: 'primary.main',
                  color: 'primary.contrastText',
                  '&:hover': {
                    backgroundColor: 'primary.dark',
                  },
                  '& .MuiListItemIcon-root': {
                    color: 'primary.contrastText',
                  },
                },
              }}
            >
              <ListItemIcon sx={{ minWidth: 40 }}>
                {item.icon}
              </ListItemIcon>
              <ListItemText 
                primary={item.title}
                primaryTypographyProps={{
                  fontSize: '0.875rem',
                  fontWeight: isActive(item.path) ? 600 : 400,
                }}
              />
            </ListItemButton>
          </ListItem>
        ))}
      </List>
    </Box>
  );

  return (
    <Drawer
      anchor="left"
      open={open}
      onClose={onClose}
      sx={{
        '& .MuiDrawer-paper': {
          boxSizing: 'border-box',
          width: 280,
        },
      }}
    >
      {drawerContent}
    </Drawer>
  );
};

export default Sidebar; 