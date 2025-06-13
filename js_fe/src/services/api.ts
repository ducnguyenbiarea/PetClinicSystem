import axios, { AxiosInstance, AxiosResponse, AxiosError } from 'axios';
import type { 
  User, 
  LoginRequest, 
  LoginResponse, 
  RegisterRequest,
  ApiError
} from '../types/auth';
import type {
  Pet,
  PetCreateRequest,
  Service,
  ServiceCreateRequest,
  ServiceBooking,
  ServiceBookingCreateRequest,
  BookingStatus,
  BookingStatusResponse,
  MedicalRecord,
  MedicalRecordCreateRequest,
  Cage,
  CageCreateRequest,
  UserRoleDTO
} from '../types/api';

class ApiService {
  private api: AxiosInstance;
  private static instance: ApiService;

  private constructor() {
    this.api = axios.create({
      baseURL: '/api', // Using Vite proxy
      withCredentials: true, // This is crucial for JSESSIONID cookies
      headers: {
        'Content-Type': 'application/json',
      },
    });

    // Response interceptor to handle errors globally
    this.api.interceptors.response.use(
      (response: AxiosResponse) => {
        return response;
      },
      (error: AxiosError) => {
        const apiError: ApiError = {
          message: 'Unknown error occurred',
          status: error.response?.status,
        };

        if (error.response?.data) {
          const errorData = error.response.data as any;
          apiError.message = errorData.message || errorData.error || 'Unknown error occurred';
          apiError.errors = errorData.errors;
        } else if (error.message) {
          apiError.message = error.message;
        }

        console.error('API Error:', apiError);
        throw apiError;
      }
    );
  }

  public static getInstance(): ApiService {
    if (!ApiService.instance) {
      ApiService.instance = new ApiService();
    }
    return ApiService.instance;
  }

  // Helper method to clear cookies on logout
  private clearCookies(): void {
    document.cookie = 'JSESSIONID=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
    document.cookie = 'SESSION=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
  }

  // Authentication endpoints
  async login(credentials: LoginRequest): Promise<LoginResponse> {
    // For login, we need to use form data instead of JSON
    const formData = new URLSearchParams();
    formData.append('username', credentials.username);
    formData.append('password', credentials.password);

    const response = await this.api.post<LoginResponse>('/auth/login', formData, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });
    return response.data;
  }

  async register(userData: RegisterRequest): Promise<User> {
    const response = await this.api.post<User>('/auth/register', userData);
    return response.data;
  }

  async logout(): Promise<void> {
    try {
      await this.api.post('/auth/logout');
    } finally {
      this.clearCookies();
    }
  }

  // User endpoints
  async getCurrentUser(): Promise<User> {
    const response = await this.api.get<User>('/users/my-info');
    return response.data;
  }

  async getAllUsers(): Promise<User[]> {
    const response = await this.api.get<User[]>('/users');
    return response.data;
  }

  async getUserById(id: number): Promise<User> {
    const response = await this.api.get<User>(`/users/${id}`);
    return response.data;
  }

  async createUser(userData: RegisterRequest): Promise<User> {
    const response = await this.api.post<User>('/users', userData);
    return response.data;
  }

  async updateUser(id: number, userData: Partial<User>): Promise<User> {
    const response = await this.api.put<User>(`/users/${id}`, userData);
    return response.data;
  }

  async deleteUser(id: number): Promise<User> {
    const response = await this.api.delete<User>(`/users/${id}`);
    return response.data;
  }

  async getUserRole(id: number): Promise<UserRoleDTO> {
    const response = await this.api.get<UserRoleDTO>(`/users/${id}/role`);
    return response.data;
  }

  async updateUserRole(id: number, newRole: string): Promise<User> {
    const response = await this.api.patch<User>(`/users/${id}/role?newRole=${newRole}`);
    return response.data;
  }

  // Pet endpoints
  async getAllPets(): Promise<Pet[]> {
    const response = await this.api.get<Pet[]>('/pets');
    return response.data;
  }

  async getMyPets(): Promise<Pet[]> {
    const response = await this.api.get<Pet[]>('/pets/my-pets');
    return response.data;
  }

  async getPetById(id: number): Promise<Pet> {
    const response = await this.api.get<Pet>(`/pets/${id}`);
    return response.data;
  }

  async getPetsByUserId(userId: number): Promise<Pet[]> {
    const response = await this.api.get<Pet[]>(`/pets/user/${userId}`);
    return response.data;
  }

  async createPet(petData: PetCreateRequest): Promise<Pet> {
    const response = await this.api.post<Pet>('/pets', petData);
    return response.data;
  }

  async updatePet(id: number, petData: Partial<Pet>): Promise<Pet> {
    const response = await this.api.put<Pet>(`/pets/${id}`, petData);
    return response.data;
  }

  async deletePet(id: number): Promise<Pet> {
    const response = await this.api.delete<Pet>(`/pets/${id}`);
    return response.data;
  }

  // Service endpoints
  async getAllServices(): Promise<Service[]> {
    const response = await this.api.get<Service[]>('/services');
    return response.data;
  }

  async getServiceById(id: number): Promise<Service> {
    const response = await this.api.get<Service>(`/services/${id}`);
    return response.data;
  }

  async createService(serviceData: ServiceCreateRequest): Promise<Service> {
    const response = await this.api.post<Service>('/services', serviceData);
    return response.data;
  }

  async updateService(id: number, serviceData: Partial<Service>): Promise<Service> {
    const response = await this.api.put<Service>(`/services/${id}`, serviceData);
    return response.data;
  }

  async deleteService(id: number): Promise<Service> {
    const response = await this.api.delete<Service>(`/services/${id}`);
    return response.data;
  }

  // Booking endpoints
  async getAllBookings(): Promise<ServiceBooking[]> {
    const response = await this.api.get<ServiceBooking[]>('/bookings');
    return response.data;
  }

  async getMyBookings(): Promise<ServiceBooking[]> {
    const response = await this.api.get<ServiceBooking[]>('/bookings/my-bookings');
    return response.data;
  }

  async getBookingById(id: number): Promise<ServiceBooking> {
    const response = await this.api.get<ServiceBooking>(`/bookings/${id}`);
    return response.data;
  }

  async getBookingsByUserId(userId: number): Promise<ServiceBooking[]> {
    const response = await this.api.get<ServiceBooking[]>(`/bookings/user/${userId}`);
    return response.data;
  }

  async getBookingsByServiceId(serviceId: number): Promise<ServiceBooking[]> {
    const response = await this.api.get<ServiceBooking[]>(`/bookings/service/${serviceId}`);
    return response.data;
  }

  async createBooking(bookingData: ServiceBookingCreateRequest): Promise<ServiceBooking> {
    const response = await this.api.post<ServiceBooking>('/bookings', bookingData);
    return response.data;
  }

  async updateBooking(id: number, bookingData: Partial<ServiceBooking>): Promise<ServiceBooking> {
    const response = await this.api.put<ServiceBooking>(`/bookings/${id}`, bookingData);
    return response.data;
  }

  async cancelBooking(id: number): Promise<ServiceBooking> {
    const response = await this.api.put<ServiceBooking>(`/bookings/${id}/cancel`);
    return response.data;
  }

  async deleteBooking(id: number): Promise<ServiceBooking> {
    const response = await this.api.delete<ServiceBooking>(`/bookings/${id}`);
    return response.data;
  }

  async getBookingStatus(id: number): Promise<BookingStatusResponse> {
    const response = await this.api.get<BookingStatusResponse>(`/bookings/${id}/status`);
    return response.data;
  }

  async updateBookingStatus(id: number, status: BookingStatus): Promise<ServiceBooking> {
    const response = await this.api.patch<ServiceBooking>(`/bookings/${id}/status?status=${status}`);
    return response.data;
  }

  // Medical Record endpoints
  async getAllMedicalRecords(): Promise<MedicalRecord[]> {
    const response = await this.api.get<MedicalRecord[]>('/records');
    return response.data;
  }

  async getMyMedicalRecords(): Promise<MedicalRecord[]> {
    const response = await this.api.get<MedicalRecord[]>('/records/my-records');
    return response.data;
  }

  async getMedicalRecordById(id: number): Promise<MedicalRecord> {
    const response = await this.api.get<MedicalRecord>(`/records/${id}`);
    return response.data;
  }

  async getMedicalRecordsByPetId(petId: number): Promise<MedicalRecord[]> {
    const response = await this.api.get<MedicalRecord[]>(`/records/pet/${petId}`);
    return response.data;
  }

  async getMedicalRecordsByUserId(userId: number): Promise<MedicalRecord[]> {
    const response = await this.api.get<MedicalRecord[]>(`/records/user/${userId}`);
    return response.data;
  }

  async createMedicalRecord(recordData: MedicalRecordCreateRequest): Promise<MedicalRecord> {
    const response = await this.api.post<MedicalRecord>('/records', recordData);
    return response.data;
  }

  async updateMedicalRecord(id: number, recordData: Partial<MedicalRecord>): Promise<MedicalRecord> {
    const response = await this.api.put<MedicalRecord>(`/records/${id}`, recordData);
    return response.data;
  }

  async deleteMedicalRecord(id: number): Promise<MedicalRecord> {
    const response = await this.api.delete<MedicalRecord>(`/records/${id}`);
    return response.data;
  }

  // Cage endpoints
  async getAllCages(): Promise<Cage[]> {
    const response = await this.api.get<Cage[]>('/cages');
    return response.data;
  }

  async getCageById(id: number): Promise<Cage> {
    const response = await this.api.get<Cage>(`/cages/${id}`);
    return response.data;
  }

  async getCageByPetId(petId: number): Promise<Cage> {
    const response = await this.api.get<Cage>(`/cages/pet/${petId}`);
    return response.data;
  }

  async getCagesByStatus(status: string): Promise<Cage[]> {
    const response = await this.api.get<Cage[]>(`/cages/status/${status}`);
    return response.data;
  }

  async getCagesFiltered(type?: string, size?: string): Promise<Cage[]> {
    const params = new URLSearchParams();
    if (type) params.append('type', type);
    if (size) params.append('size', size);
    
    const response = await this.api.get<Cage[]>(`/cages/filter?${params.toString()}`);
    return response.data;
  }

  async createCage(cageData: CageCreateRequest): Promise<Cage> {
    const response = await this.api.post<Cage>('/cages', cageData);
    return response.data;
  }

  async updateCage(id: number, cageData: Partial<Cage>): Promise<Cage> {
    const response = await this.api.put<Cage>(`/cages/${id}`, cageData);
    return response.data;
  }

  async deleteCage(id: number): Promise<Cage> {
    const response = await this.api.delete<Cage>(`/cages/${id}`);
    return response.data;
  }
}

export default ApiService.getInstance(); 