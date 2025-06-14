export interface User {
  id: number;
  user_name: string;
  email: string;
  phone: string;
  roles: string;
}

export interface LoginRequest {
  username: string;
  password: string;
}

export interface LoginResponse {
  message: string;
  username: string;
  roles: string[];
}

export interface RegisterRequest {
  user_name: string;
  email: string;
  phone: string;
  password: string;
}

export type UserRole = 'OWNER' | 'STAFF' | 'DOCTOR' | 'ADMIN';

export interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
}

export interface ApiError {
  message: string;
  status?: number;
  errors?: string[];
} 