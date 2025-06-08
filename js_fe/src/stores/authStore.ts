import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { User, LoginRequest, RegisterRequest, UserRole, AuthState, ApiError } from '../types/auth';
import apiService from '../services/api';

interface AuthStore extends AuthState {
  // Actions
  login: (credentials: LoginRequest) => Promise<void>;
  register: (userData: RegisterRequest) => Promise<void>;
  logout: () => Promise<void>;
  getCurrentUser: () => Promise<void>;
  clearError: () => void;
  setLoading: (loading: boolean) => void;
  
  // Utility methods
  hasRole: (role: UserRole) => boolean;
  isOwner: () => boolean;
  isStaff: () => boolean;
  isDoctor: () => boolean;
  isAdmin: () => boolean;
}

const useAuthStore = create<AuthStore>()(
  persist(
    (set, get) => ({
      // Initial state
      user: null,
      isAuthenticated: false,
      isLoading: true, // Start with loading true for initial auth check
      error: null,

      // Actions
      login: async (credentials: LoginRequest) => {
        set({ isLoading: true, error: null });
        try {
          const loginResponse = await apiService.login(credentials);
          console.log('Login response:', loginResponse);
          
          // After successful login, get user info
          const user = await apiService.getCurrentUser();
          
          set({
            user,
            isAuthenticated: true,
            isLoading: false,
            error: null,
          });
        } catch (error) {
          const apiError = error as ApiError;
          set({
            user: null,
            isAuthenticated: false,
            isLoading: false,
            error: apiError.message,
          });
          throw error;
        }
      },

      register: async (userData: RegisterRequest) => {
        set({ isLoading: true, error: null });
        try {
          const user = await apiService.register(userData);
          set({
            user,
            isAuthenticated: true,
            isLoading: false,
            error: null,
          });
        } catch (error) {
          const apiError = error as ApiError;
          set({
            user: null,
            isAuthenticated: false,
            isLoading: false,
            error: apiError.message,
          });
          throw error;
        }
      },

      logout: async () => {
        set({ isLoading: true });
        try {
          await apiService.logout();
        } catch (error) {
          console.error('Logout error:', error);
          // Continue with logout even if API call fails
        } finally {
          set({
            user: null,
            isAuthenticated: false,
            isLoading: false,
            error: null,
          });
        }
      },

      getCurrentUser: async () => {
        set({ isLoading: true, error: null });
        try {
          const user = await apiService.getCurrentUser();
          set({
            user,
            isAuthenticated: true,
            isLoading: false,
            error: null,
          });
        } catch (error) {
          const apiError = error as ApiError;
          // Don't set error message for failed session restoration
          set({
            user: null,
            isAuthenticated: false,
            isLoading: false,
            error: null, // Clear any previous errors
          });
          throw error;
        }
      },

      clearError: () => {
        set({ error: null });
      },

      setLoading: (loading: boolean) => {
        set({ isLoading: loading });
      },

      // Utility methods
      hasRole: (role: UserRole): boolean => {
        const { user } = get();
        if (!user) return false;
        return user.roles === role;
      },

      isOwner: (): boolean => {
        return get().hasRole('OWNER');
      },

      isStaff: (): boolean => {
        return get().hasRole('STAFF');
      },

      isDoctor: (): boolean => {
        return get().hasRole('DOCTOR');
      },

      isAdmin: (): boolean => {
        return get().hasRole('ADMIN');
      },
    }),
    {
      name: 'auth-store',
      partialize: (state) => ({
        user: state.user,
        isAuthenticated: state.isAuthenticated,
      }),
      // Don't persist loading state
      onRehydrateStorage: () => (state) => {
        // Reset loading state after rehydration
        if (state) {
          state.isLoading = false;
        }
      },
    }
  )
);

export default useAuthStore; 