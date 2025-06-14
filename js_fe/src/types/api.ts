// Pet related types
export interface Pet {
  id: number;
  name: string;
  birth_date: string;
  gender: 'MALE' | 'FEMALE';
  species: string;
  color: string;
  health_info: string;
  user_id: number;
}

export interface PetCreateRequest {
  name: string;
  birth_date: string;
  gender: 'MALE' | 'FEMALE';
  species: string;
  color: string;
  health_info: string;
  user_id: number;
}

// Service related types
export interface Service {
  id: number;
  service_name: string;
  category: string;
  description: string;
  price: number;
}

export interface ServiceCreateRequest {
  service_name: string;
  category: string;
  description: string;
  price: number;
}

// Booking status type
export type BookingStatus = 'PENDING' | 'CONFIRMED' | 'CANCELLED' | 'COMPLETED';

// Booking related types
export interface ServiceBooking {
  id: number;
  start_date: string;
  end_date?: string;
  notes: string;
  status: BookingStatus;
  user_id: number;
  service_id: number;
  pet_id?: number;
}

export interface ServiceBookingCreateRequest {
  start_date: string;
  end_date?: string;
  notes: string;
  user_id: number;
  service_id: number;
  pet_id?: number;
}

export interface BookingStatusResponse {
  id: number;
  status: BookingStatus;
}

// Medical Record related types
export interface MedicalRecord {
  id: number;
  diagnosis: string;
  prescription: string;
  notes: string;
  next_meeting_date: string;
  record_date: string;
  pet_id: number;
  user_id: number;
}

export interface MedicalRecordCreateRequest {
  diagnosis: string;
  prescription: string;
  notes: string;
  next_meeting_date: string;
  pet_id: number;
  user_id: number;
}

// Cage related types
export interface Cage {
  id: number;
  type: string;
  size: string;
  status: 'AVAILABLE' | 'OCCUPIED' | 'CLEANING' | 'MAINTENANCE';
  start_date?: string;
  end_date?: string;
  pet_id?: number;
}

export interface CageCreateRequest {
  type: string;
  size: string;
  status: 'AVAILABLE' | 'OCCUPIED' | 'CLEANING' | 'MAINTENANCE';
  start_date?: string;
  end_date?: string;
  pet_id?: number;
}

// User Role DTO
export interface UserRoleDTO {
  id: number;
  roles: string;
}

// API Response wrapper
export interface ApiResponse<T> {
  data?: T;
  message?: string;
  success?: boolean;
}

// Dashboard statistics (for admin/staff dashboards)
export interface DashboardStats {
  totalUsers: number;
  totalPets: number;
  totalBookings: number;
  totalMedicalRecords: number;
  pendingBookings: number;
  completedBookings: number;
  availableCages: number;
  occupiedCages: number;
}

// Re-export User type from auth for convenience
export type { User } from './auth'; 