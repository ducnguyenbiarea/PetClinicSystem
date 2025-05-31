---

## Postman Request Key-Value Pairs for API Endpoints

### AuthController (`/api/auth`)

#### Register (`POST /api/auth/register`)
- **Body (raw, JSON):**
  - `user_name`: string
  - `email`: string
  - `phone`: string
  - `password`: string

#### Login (`POST /api/auth/login`)
- **Body (x-www-form-urlencoded):**
  - `username`: string (email)
  - `password`: string

#### Logout (`POST /api/auth/logout`)
- No body required.

---

### UserController (`/api/users`)

#### Create User (`POST /api/users`)
- **Body (raw, JSON):**
  - `user_name`: string
  - `email`: string
  - `phone`: string
  - `password`: string

#### Update User (`PUT /api/users/{id}`)
- **Body (raw, JSON):**
  - `user_name`: string
  - `email`: string
  - `phone`: string

#### Change User Role (`PATCH /api/users/{id}/role?newRole=staff`)
- **Query Param:**
  - `newRole`: string (e.g., "staff", "admin", "owner")

---

### PetController (`/api/pets`)

#### Add Pet (`POST /api/pets`)
- **Body (raw, JSON):**
  - `name`: string
  - `birth_date`: string (YYYY-MM-DD)
  - `gender`: string ("MALE" or "FEMALE")
  - `species`: string
  - `color`: string
  - `health_info`: string
  - `user_id`: integer

#### Update Pet (`PUT /api/pets/{id}`)
- **Body (raw, JSON):** (same as above)

---

### ServiceController (`/api/services`)

#### Add Service (`POST /api/services`)
- **Body (raw, JSON):**
  - `service_name`: string
  - `category`: string
  - `description`: string
  - `price`: number

#### Update Service (`PUT /api/services/{id}`)
- **Body (raw, JSON):** (same as above)

---

### ServiceBookingController (`/api/bookings`)

#### Create Booking (`POST /api/bookings`)
- **Body (raw, JSON):**
  - `start_date`: string (YYYY-MM-DD)
  - `end_date`: string (YYYY-MM-DD or empty)
  - `notes`: string
  - `user_id`: integer
  - `service_id`: integer

#### Update Booking (`PUT /api/bookings/{id}`)
- **Body (raw, JSON):** (same as above)

#### Update Booking Status (`PATCH /api/bookings/{id}/status?status=COMPLETED`)
- **Query Param:**
  - `status`: string (e.g., "PENDING", "COMPLETED", "CANCELLED")

---

### MedicalRecordController (`/api/records`)

#### Add Medical Record (`POST /api/records`)
- **Body (raw, JSON):**
  - `diagnosis`: string
  - `prescription`: string
  - `notes`: string
  - `next_meeting_date`: string (YYYY-MM-DD)
  - `pet_id`: integer
  - `user_id`: integer

#### Update Medical Record (`PUT /api/records/{id}`)
- **Body (raw, JSON):** (same as above)

---

### CageController (`/api/cages`)

#### Add Cage (`POST /api/cages`)
- **Body (raw, JSON):**
  - `type`: string (e.g., "DOG", "CAT")
  - `size`: string (e.g., "Large", "Small")
  - `status`: string (e.g., "AVAILABLE", "CLEANING")
  - `start_date`: string (YYYY-MM-DD)
  - `end_date`: string (YYYY-MM-DD)
  - `pet_id`: integer

#### Update Cage (`PUT /api/cages/{id}`)
- **Body (raw, JSON):** (same as above)

---

For GET, DELETE, and most PATCH requests, you usually do not need a body—just set the correct URL and method.

### AuthController (`/api/auth`)
- `GET /login` — Returns login instructions
  - **Response:**
    ```json
    "Please POST your credentials to this endpoint"
    ```
- `POST /register` — Register new user (body: UserDTO)
  - **Response:**
    ```json
    {
      "id": 1,
      "name": "string",
      "email": "string",
      "phone": "string",
      "roles": "OWNER"
    }
    ```
- `POST /login` — Login (handled by Spring Security)
  - **Success:**
    ```json
    {
      "message": "Login successful",
      "username": "user@example.com",
      "roles": ["ROLE_OWNER"]
    }
    ```
  - **Failure:**
    ```json
    {
      "message": "Login failed",
      "error": "Bad credentials"
    }
    ```
- `GET /access-denied` — Access denied message
  - **Response:**
    ```json
    "You don't have permission to access this resource"
    ```

### UserController (`/api/users`)
- `GET /` — List all users
  - **Response:** Array of UserDTO
- `GET /{id}` — Get user by ID
  - **Response:** UserDTO
- `GET /email/{email}` — Get user by email
  - **Response:** UserDTO
- `POST /` — Create user (body: UserDTO)
  - **Response:** UserDTO
- `PUT /{id}` — Update user (body: UserDTO)
  - **Response:** UserDTO
- `DELETE /{id}` — Delete user
  - **Response:** UserDTO
- `GET /my-info` — Get current user info
  - **Response:** UserDTO
- `GET /{id}/role` — Get user role (returns UserRoleDTO)
  - **Response:**
    ```json
    {
      "id": 1,
      "roles": "OWNER"
    }
    ```
- `PATCH /{id}/role` — Update user role (admin only)
  - **Response:** UserDTO

### PetController (`/api/pets`)
- `GET /` — List all pets
  - **Response:** Array of PetDTO
- `GET /{id}` — Get pet by ID
  - **Response:** PetDTO
- `GET /user/{userId}` — Get pets by user
  - **Response:** Array of PetDTO
- `POST /` — Add pet (body: PetDTO)
  - **Response:** PetDTO
- `PUT /{id}` — Update pet (body: PetDTO)
  - **Response:** PetDTO
- `DELETE /{id}` — Delete pet
  - **Response:** PetDTO
- `GET /my-pets` — Get current user's pets
  - **Response:** Array of PetDTO

### CageController (`/api/cages`)
- `GET /` — List all cages
  - **Response:** Array of CageDTO
- `GET /{id}` — Get cage by ID
  - **Response:** CageDTO
- `GET /pet/{petId}` — Get cage by pet
  - **Response:** CageDTO
- `POST /` — Add cage (body: CageDTO)
  - **Response:** CageDTO
- `PUT /{id}` — Update cage (body: CageDTO)
  - **Response:** CageDTO
- `DELETE /{id}` — Delete cage
  - **Response:** CageDTO
- `GET /status/{status}` — Filter cages by status
  - **Response:** Array of CageDTO
- `GET /filter?type=...&size=...` — Filter cages by type and size
  - **Response:** Array of CageDTO

### MedicalRecordController (`/api/records`)
- `GET /` — List all records
  - **Response:** Array of MedicalRecordDTO
- `GET /{id}` — Get record by ID
  - **Response:** MedicalRecordDTO
- `GET /pet/{petId}` — Get records by pet
  - **Response:** Array of MedicalRecordDTO
- `GET /user/{userId}` — Get records by user
  - **Response:** Array of MedicalRecordDTO
- `POST /` — Add record (body: MedicalRecordDTO)
  - **Response:** MedicalRecordDTO
- `PUT /{id}` — Update record (body: MedicalRecordDTO)
  - **Response:** MedicalRecordDTO
- `DELETE /{id}` — Delete record (admin/doctor only)
  - **Response:** MedicalRecordDTO
- `GET /my-records` — Get current user's records
  - **Response:** Array of MedicalRecordDTO

### ServiceController (`/api/services`)
- `GET /` — List all services
  - **Response:** Array of ServicesDTO
- `GET /{id}` — Get service by ID
  - **Response:** ServicesDTO
- `POST /` — Add service (admin only, body: ServicesDTO)
  - **Response:** ServicesDTO
- `PUT /{id}` — Update service (body: ServicesDTO)
  - **Response:** ServicesDTO
- `DELETE /{id}` — Delete service
  - **Response:** ServicesDTO

### ServiceBookingController (`/api/bookings`)
- `GET /` — List all bookings
  - **Response:** Array of ServiceBookingDTO
- `GET /{id}` — Get booking by ID
  - **Response:** ServiceBookingDTO
- `GET /user/{userId}` — Get bookings by user
  - **Response:** Array of ServiceBookingDTO
- `GET /service/{serviceId}` — Get bookings by service
  - **Response:** Array of ServiceBookingDTO
- `POST /` — Create booking (body: ServiceBookingDTO)
  - **Response:** ServiceBookingDTO
- `PUT /{id}` — Update booking (body: ServiceBookingDTO)
  - **Response:** ServiceBookingDTO
- `PUT /{id}/cancel` — Cancel booking
  - **Response:** ServiceBookingDTO
- `DELETE /{id}` — Delete booking (admin only)
  - **Response:** ServiceBookingDTO
- `GET /{id}/status` — Get booking status
  - **Response:**
    ```json
    {
      "id": 1,
      "status": "PENDING"
    }
    ```
  - **PATCH /{id}/status?status=...** — Update booking status (admin/staff only)
    - **Response:** ServiceBookingDTO
- `GET /my-bookings` — Get current user's bookings
  - **Response:** Array of ServiceBookingDTO

---

## 3. Return Format

### Success
- Returns DTO objects (e.g., `UserDTO`, `PetDTO`, etc.)
- Lists are returned as arrays of DTOs

### Error
- Standard error JSON:
  ```json
  {
    "status": 400,
    "message": "Validation failed",
    "errors": ["field: error message", ...]
  }
  ```
- Other errors (e.g., unauthorized, forbidden) follow similar structure with appropriate status/message

### Auth Responses
- On login success:
  ```json
  {
    "message": "Login successful",
    "username": "user@example.com",
    "roles": ["ROLE_OWNER"]
  }
  ```
- On login failure:
  ```json
  {
    "message": "Login failed",
    "error": "Bad credentials"
  }
  ```
- On logout:
  ```json
  {
    "message": "Logged out successfully"
  }
  ```


### Accounts
The original passwords for the initial accounts are defined in the `ApplicationInitConfig` class. Based on the provided context, here are the initial accounts and their raw passwords:

- **Admin Account:**
  - Email: `admin@example.com`
  - Password: `admin123`

- **Owner Account:**
  - Email: `owner@example.com`
  - Password: `owner123`

- **Staff Account:**
  - Email: `staff@example.com`
  - Password: `staff123`

- **Doctor Account:**
  - Email: `doctor@example.com`
  - Password: `doctor123`

These accounts are created during application startup if they do not already exist. The passwords are hashed using BCrypt before being stored in the database.