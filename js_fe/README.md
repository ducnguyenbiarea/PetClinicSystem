# Pet Clinic System - React Frontend

A modern React + TypeScript frontend for the Pet Clinic Management System, built with Material-UI and optimized for web browsers.

## 🚀 Features

### Architecture
- **React 18** with TypeScript for type safety
- **Material-UI (MUI)** for Apple-like design system
- **Zustand** for state management
- **React Router** for client-side routing
- **Axios** for HTTP client with JSESSIONID cookie support
- **Vite** for fast development and building

### Authentication & Authorization
- **Role-based access control** (OWNER, STAFF, DOCTOR, ADMIN)
- **Session-based authentication** using JSESSIONID cookies
- **Protected routes** based on user roles
- **Automatic session restoration** on app startup

### User Interface
- **Apple-inspired Material Design** with rounded corners and subtle animations
- **Responsive design** optimized for web browsers (not mobile-first)
- **Horizontal layout** maximizing screen real estate
- **Beautiful login/register pages** with test account quick access
- **Role-based sidebar navigation** with dynamic menu items
- **Professional color scheme** with role-specific badges

### Backend Integration
- **Full API integration** with Spring Boot backend
- **Automatic cookie handling** for session management
- **Error handling** with user-friendly messages
- **Real-time data loading** with loading states
- **CORS and proxy configuration** for development

## 🎨 Design System

### Colors
- **Primary Blue**: #007AFF (iOS Blue)
- **Secondary Orange**: #FF9500 (iOS Orange)
- **Success Green**: #34C759 (iOS Green)
- **Error Red**: #FF3B30 (iOS Red)
- **Warning Orange**: #FF9500
- **Info Light Blue**: #5AC8FA

### Role Colors
- **Admin**: Red badge
- **Doctor**: Green badge
- **Staff**: Orange badge
- **Owner**: Blue badge

## 📂 Project Structure

```
js_fe/
├── src/
│   ├── components/           # Reusable UI components
│   │   ├── Layout/          # Layout components (Sidebar, MainLayout)
│   │   └── ProtectedRoute.tsx
│   ├── pages/               # Page components
│   │   ├── auth/           # Login/Register pages
│   │   ├── dashboard/      # Dashboard page
│   │   ├── admin/          # Admin-only pages
│   │   ├── owner/          # Owner-only pages
│   │   └── common/         # Shared pages
│   ├── services/           # API service layer
│   ├── stores/             # Zustand stores
│   ├── types/              # TypeScript type definitions
│   ├── theme/              # Material-UI theme configuration
│   ├── App.tsx             # Main app component with routing
│   └── main.tsx            # App entry point
├── package.json
├── vite.config.ts          # Vite configuration with proxy
└── README.md
```

## 🛠️ Installation & Setup

### Prerequisites
- **Node.js** 18+ and npm
- **Java Spring Boot backend** running on port 8080

### Installation
```bash
# Navigate to frontend directory
cd js_fe

# Install dependencies
npm install

# Start development server
npm run dev
```

The app will be available at `http://localhost:3000`

### Backend Connection
The frontend is configured to connect to the Spring Boot backend at `http://localhost:8080` through Vite's proxy configuration.

## 🔐 Test Accounts

The login page includes quick-access buttons for testing:

| Role | Email | Password | Access Level |
|------|-------|----------|--------------|
| **Admin** | admin@example.com | admin123 | Full system access |
| **Doctor** | doctor@example.com | doctor123 | Medical records, pets, bookings |
| **Staff** | staff@example.com | staff123 | Bookings, cages, services |
| **Owner** | owner@example.com | owner123 | Personal pets and bookings |

## 📱 Role-Based Features

### Pet Owner (OWNER)
- ✅ Dashboard with personal statistics
- ✅ My Pets management
- ✅ My Bookings management
- ✅ Medical Records viewing
- ✅ Profile management

### Staff (STAFF)
- ✅ Dashboard with system statistics
- ✅ All Pets management
- ✅ All Bookings management
- ✅ Medical Records management
- ✅ Services management
- ✅ Cages management

### Doctor (DOCTOR)
- ✅ Dashboard with medical statistics
- ✅ All Pets viewing
- ✅ All Bookings viewing
- ✅ Medical Records management
- ✅ Treatment planning

### Administrator (ADMIN)
- ✅ Dashboard with full statistics
- ✅ User Management (role assignment)
- ✅ All Pets management
- ✅ All Bookings management
- ✅ Medical Records management
- ✅ Services management
- ✅ System configuration

## 🔧 Configuration

### Vite Configuration (`vite.config.ts`)
```typescript
export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false,
      }
    }
  }
});
```

### API Service Configuration
The API service automatically handles:
- **JSESSIONID cookies** for authentication
- **CORS headers** for cross-origin requests
- **Error handling** with detailed error messages
- **Request/response logging** for debugging

## 🚧 Current Implementation Status

### ✅ Completed
- [x] Authentication system (login/register)
- [x] Role-based routing and access control
- [x] Material-UI theme and design system
- [x] Sidebar navigation with role-specific menus
- [x] Dashboard with role-based statistics
- [x] All Bookings page with API integration
- [x] Access denied page
- [x] Session management and persistence

### 🔄 In Progress
- [ ] User Management (Admin)
- [ ] Pet Management (All roles)
- [ ] Medical Records (CRUD operations)
- [ ] Services Management (Admin/Staff)
- [ ] Cages Management (Admin/Staff)

### 📋 Planned Features
- [ ] Real-time notifications
- [ ] Advanced filtering and search
- [ ] Data export capabilities
- [ ] Print medical records
- [ ] Appointment scheduling
- [ ] File upload for pet photos

## 🐛 Known Issues & Solutions

### Backend Connection Issues
If you see "Failed to load data" errors:
1. Ensure the Spring Boot backend is running on port 8080
2. Check the browser's Network tab for CORS errors
3. Verify the API endpoints match the backend implementation

### Authentication Issues
If login fails:
1. Check the backend logs for authentication errors
2. Verify the test account credentials are set up in the backend
3. Clear browser cookies if session is corrupted

## 🤝 Contributing

### Development Guidelines
1. **Type Safety**: All components must use TypeScript interfaces
2. **Material-UI**: Use MUI components with custom theme
3. **Error Handling**: Implement proper error boundaries and user feedback
4. **Mobile-Friendly**: Design for web but ensure basic mobile compatibility
5. **Role-Based**: Always implement proper role checks for features

### Adding New Pages
1. Create the page component in appropriate directory (`pages/admin/`, `pages/owner/`, etc.)
2. Add route to `App.tsx` with proper role protection
3. Add menu item to `Sidebar.tsx` with role restrictions
4. Implement API calls in the service layer
5. Add TypeScript interfaces in `types/`

## 📚 API Documentation

The frontend integrates with these main API endpoints:

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/logout` - User logout
- `GET /api/auth/me` - Get current user

### Bookings
- `GET /api/bookings` - Get all bookings (Staff/Admin/Doctor)
- `GET /api/bookings/my` - Get user's bookings (Owner)
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/{id}` - Update booking
- `DELETE /api/bookings/{id}` - Delete booking

### Pets
- `GET /api/pets` - Get all pets (Staff/Admin/Doctor)
- `GET /api/pets/my` - Get user's pets (Owner)
- `POST /api/pets` - Create pet
- `PUT /api/pets/{id}` - Update pet
- `DELETE /api/pets/{id}` - Delete pet

### Medical Records
- `GET /api/medical-records` - Get all records (Staff/Admin/Doctor)
- `GET /api/medical-records/my` - Get user's records (Owner)
- `POST /api/medical-records` - Create record (Doctor/Admin)
- `PUT /api/medical-records/{id}` - Update record (Doctor/Admin)

### Users (Admin only)
- `GET /api/users` - Get all users
- `POST /api/users` - Create user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

## 🎯 Performance Optimization

### Code Splitting
- Routes are lazy-loaded for better performance
- Components are optimized with React.memo where needed

### State Management
- Zustand provides lightweight state management
- API calls are cached to reduce server load

### Bundle Optimization
- Vite provides automatic code splitting
- Tree shaking eliminates unused code
- Production builds are optimized for size

---

**Built with ❤️ using React, TypeScript, and Material-UI**
