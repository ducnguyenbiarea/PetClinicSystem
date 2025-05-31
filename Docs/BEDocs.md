# PetClinicSystem Backend Documentation (Java Spring Boot)

## 1. Guidelines to Run the Backend

### Prerequisites
- Java 17+
- Maven
- MySQL

### Database Configuration
- Database name: `test_MedicalRecord`
- Configure your MySQL server and update credentials in `application.properties`:
  ```properties
  spring.datasource.url=jdbc:mysql://localhost:3306/test_MedicalRecord
  spring.datasource.username=<your_mysql_user>
  spring.datasource.password=<your_mysql_password>
  ```
- The backend will auto-create/update tables on startup.

### Build & Run
```sh
cd BE/pet
mvn clean install
mvn spring-boot:run
```

---

## 2. API Documentation

This section details all available API endpoints, their request/response formats, and database interactions.

### AuthController (`/api/auth`)

Base Path: `/api/auth`

- `GET /login`
  - **Description:** Returns login instructions. This endpoint typically informs the client to use a POST request for actual login.
  - **Request Body:** None.
  - **Response (200 OK, application/json):**
    ```json
    "Please POST your credentials to this endpoint"
    ```
  - **Database Interaction:** None. This is a static informational response.

- `POST /register`
  - **Description:** Registers a new user.
  - **Request Body (application/json):**
    ```json
    {
      "user_name": "string",    // e.g., "John Doe"
      "email": "string",        // e.g., "john.doe@example.com"
      "phone": "string",        // e.g., "1234567890"
      "password": "string"      // e.g., "securePassword123"
    }
    ```
  - **Response (Success - 200 OK, application/json):** `UserDTO` (excluding password)
    ```json
    {
      "id": "integer",          // e.g., 1
      "user_name": "string",    // e.g., "John Doe"
      "email": "string",        // e.g., "john.doe@example.com"
      "phone": "string",        // e.g., "1234567890"
      "roles": "string"         // e.g., "OWNER" (Actual roles might be an array like ["ROLE_OWNER"])
    }
    ```
  - **Database Interaction:** Inserts a new record into the `users` table. The password will be hashed before storage. A default role (e.g., "OWNER") is typically assigned.

- `POST /login`
  - **Description:** Authenticates a user and establishes a session. This is typically handled by Spring Security.
  - **Request Body (application/x-www-form-urlencoded):**
    - `username`: string (user's email, e.g., "john.doe@example.com")
    - `password`: string (user's password, e.g., "securePassword123")
  - **Response (Success - 200 OK, application/json):**
    ```json
    {
      "message": "Login successful",
      "username": "string",        // e.g., "john.doe@example.com"
      "roles": ["string"]         // e.g., ["ROLE_OWNER", "ROLE_USER"]
    }
    ```
  - **Response (Failure - 401 Unauthorized, application/json):** (Refer to Section 3 for general error structure)
    ```json
    {
      "message": "Login failed",
      "error": "Bad credentials"
    }
    ```
  - **Database Interaction:** Reads user credentials (username/email and hashed password) from the `users` table for verification. May update session-related information.

- `POST /logout`
  - **Description:** Logs out the current authenticated user by invalidating their session.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):**
    ```json
    {
      "message": "Logged out successfully"
    }
    ```
  - **Database Interaction:** Invalidates the user's current session. No direct database table changes, but session store might be affected.

- `GET /access-denied`
  - **Description:** Returns an access denied message. This is usually a redirection target by Spring Security when authorization fails.
  - **Request Body:** None.
  - **Response (403 Forbidden, application/json):**
    ```json
    "You don't have permission to access this resource"
    ```
  - **Database Interaction:** None.

### UserController (`/api/users`)

Base Path: `/api/users`

- `GET /`
  - **Description:** Lists all users. (Requires appropriate permissions, e.g., ADMIN)
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `UserDTO`
    ```json
    [
      {
        "id": "integer",
        "user_name": "string",
        "email": "string",
        "phone": "string",
        "roles": "string" // or ["string"]
      }
    ]
    ```
  - **Database Interaction:** Retrieves all records from the `users` table.

- `GET /{id}`
  - **Description:** Gets a specific user by their ID.
  - **Path Variable:** `id` (integer) - The ID of the user.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `UserDTO`
    ```json
    {
      "id": "integer",
      "user_name": "string",
      "email": "string",
      "phone": "string",
      "roles": "string" // or ["string"]
    }
    ```
  - **Database Interaction:** Retrieves a single record from the `users` table where `id` matches.

- `GET /email/{email}`
  - **Description:** Gets a specific user by their email address.
  - **Path Variable:** `email` (string) - The email of the user.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `UserDTO`
    ```json
    {
      "id": "integer",
      "user_name": "string",
      "email": "string",
      "phone": "string",
      "roles": "string" // or ["string"]
    }
    ```
  - **Database Interaction:** Retrieves a single record from the `users` table where `email` matches.

- `POST /`
  - **Description:** Creates a new user. (Typically admin-only, or similar to `/api/auth/register` if public)
  - **Request Body (application/json):**
    ```json
    {
      "user_name": "string",
      "password": "string", // Will be hashed
      "phone": "string",
      "email": "string",
      "roles": "string" // e.g., "STAFF", optional, defaults may apply
    }
    ```
  - **Response (Success - 201 Created or 200 OK, application/json):** `UserDTO`
    ```json
    {
      "id": "integer",
      "user_name": "string",
      "email": "string",
      "phone": "string",
      "roles": "string" // or ["string"]
    }
    ```
  - **Database Interaction:** Inserts a new record into the `users` table.

- `PUT /{id}`
  - **Description:** Updates an existing user's information.
  - **Path Variable:** `id` (integer) - The ID of the user to update.
  - **Request Body (application/json):**
    ```json
    {
      "user_name": "string", // Fields to update
      "phone": "string",
      "email": "string"
      // Password updates might be handled by a separate endpoint
      // Role updates are typically via the PATCH /{id}/role endpoint
    }
    ```
  - **Response (Success - 200 OK, application/json):** `UserDTO`
    ```json
    {
      "id": "integer",
      "user_name": "string",
      "email": "string",
      "phone": "string",
      "roles": "string" // or ["string"]
    }
    ```
  - **Database Interaction:** Updates an existing record in the `users` table where `id` matches.

- `DELETE /{id}`
  - **Description:** Deletes a user. (Requires appropriate permissions, e.g., ADMIN)
  - **Path Variable:** `id` (integer) - The ID of the user to delete.
  - **Request Body:** None.
  - **Response (Success - 200 OK or 204 No Content, application/json):** `UserDTO` of the deleted user or a success message.
    ```json
    {
      "id": "integer",          // Or a message like {"message": "User deleted successfully"}
      "user_name": "string",
      // ... other fields ...
    }
    ```
  - **Database Interaction:** Deletes a record from the `users` table where `id` matches. Consider related data and cascading deletes or soft deletes.

- `GET /my-info`
  - **Description:** Gets the information of the currently authenticated user.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `UserDTO`
    ```json
    {
      "id": "integer",
      "user_name": "string",
      "email": "string",
      "phone": "string",
      "roles": "string" // or ["string"]
    }
    ```
  - **Database Interaction:** Retrieves the record for the currently authenticated user from the `users` table.

- `GET /{id}/role`
  - **Description:** Gets the role(s) of a specific user.
  - **Path Variable:** `id` (integer) - The ID of the user.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `UserRoleDTO`
    ```json
    {
      "id": "integer",         // User ID
      "roles": "string"        // e.g., "OWNER" (or an array like ["ROLE_OWNER"])
    }
    ```
  - **Database Interaction:** Retrieves the role information for the specified user from the `users` table.

- `PATCH /{id}/role`
  - **Description:** Updates the role(s) of a specific user. (Admin only)
  - **Path Variable:** `id` (integer) - The ID of the user.
  - **Query Parameter:** `newRole` (string) - The new role to assign (e.g., "staff", "admin").
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `UserDTO` (updated user)
    ```json
    {
      "id": "integer",
      "user_name": "string",
      "email": "string",
      "phone": "string",
      "roles": "string" // or ["string"], reflecting the new role
    }
    ```
  - **Database Interaction:** Updates the role field for the specified user in the `users` table.

### PetController (`/api/pets`)

Base Path: `/api/pets`

- `GET /`
  - **Description:** Lists all pets. (Admin/Staff might see all, owners see their own based on implementation)
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `PetDTO`
    ```json
    [
      {
        "id": "integer",
        "name": "string",
        "birth_date": "string", // "YYYY-MM-DD"
        "gender": "string",     // "MALE", "FEMALE"
        "species": "string",
        "color": "string",
        "health_info": "string",
        "user_id": "integer"    // Owner's user ID
      }
    ]
    ```
  - **Database Interaction:** Retrieves records from the `pets` table. May join with `users` table to filter by owner or include owner details.

- `GET /{id}`
  - **Description:** Gets a specific pet by its ID.
  - **Path Variable:** `id` (integer) - The ID of the pet.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `PetDTO`
    ```json
    {
      "id": "integer",
      "name": "string",
      "birth_date": "string", // "YYYY-MM-DD"
      "gender": "string",
      "species": "string",
      "color": "string",
      "health_info": "string",
      "user_id": "integer"
    }
    ```
  - **Database Interaction:** Retrieves a single record from the `pets` table where `id` matches.

- `GET /user/{userId}`
  - **Description:** Gets all pets belonging to a specific user.
  - **Path Variable:** `userId` (integer) - The ID of the user (owner).
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `PetDTO`
  - **Database Interaction:** Retrieves records from the `pets` table where `user_id` matches the provided `userId`.

- `POST /`
  - **Description:** Adds a new pet. The `user_id` in the body links the pet to its owner.
  - **Request Body (application/json):**
    ```json
    {
      "name": "string",          // e.g., "Buddy"
      "birth_date": "string",   // "YYYY-MM-DD", e.g., "2022-01-15"
      "gender": "string",       // "MALE" or "FEMALE"
      "species": "string",      // e.g., "Dog"
      "color": "string",        // e.g., "Golden"
      "health_info": "string",  // e.g., "Vaccinated and healthy"
      "user_id": "integer"      // ID of the owner (User)
    }
    ```
  - **Response (Success - 201 Created or 200 OK, application/json):** `PetDTO`
  - **Database Interaction:** Inserts a new record into the `pets` table.

- `PUT /{id}`
  - **Description:** Updates an existing pet's information.
  - **Path Variable:** `id` (integer) - The ID of the pet to update.
  - **Request Body (application/json):** `PetDTO` structure (fields to update)
    ```json
    {
      "name": "string",
      "birth_date": "string", // "YYYY-MM-DD"
      "gender": "string",
      "species": "string",
      "color": "string",
      "health_info": "string",
      "user_id": "integer" // Usually not changed here, or validated for permission
    }
    ```
  - **Response (Success - 200 OK, application/json):** `PetDTO`
  - **Database Interaction:** Updates an existing record in the `pets` table where `id` matches.

- `DELETE /{id}`
  - **Description:** Deletes a pet.
  - **Path Variable:** `id` (integer) - The ID of the pet to delete.
  - **Request Body:** None.
  - **Response (Success - 200 OK or 204 No Content, application/json):** `PetDTO` of the deleted pet or a success message.
  - **Database Interaction:** Deletes a record from the `pets` table where `id` matches. Consider implications for related records (e.g., medical records, bookings).

- `GET /my-pets`
  - **Description:** Gets all pets belonging to the currently authenticated user.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `PetDTO`
  - **Database Interaction:** Retrieves records from the `pets` table where `user_id` matches the ID of the currently authenticated user.

### CageController (`/api/cages`)

Base Path: `/api/cages`

- `GET /`
  - **Description:** Lists all cages.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `CageDTO`
    ```json
    [
      {
        "id": "integer",
        "type": "string",       // e.g., "DOG", "CAT"
        "size": "string",       // e.g., "Large", "Medium", "Small"
        "status": "string",     // e.g., "AVAILABLE", "OCCUPIED", "CLEANING", "MAINTENANCE"
        "start_date": "string", // "YYYY-MM-DD HH:mm:ss" or "YYYY-MM-DD", occupancy start
        "end_date": "string",   // "YYYY-MM-DD HH:mm:ss" or "YYYY-MM-DD", occupancy end
        "pet_id": "integer"     // ID of the pet currently in the cage (nullable)
      }
    ]
    ```
  - **Database Interaction:** Retrieves all records from the `cages` table.

- `GET /{id}`
  - **Description:** Gets a specific cage by its ID.
  - **Path Variable:** `id` (integer) - The ID of the cage.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `CageDTO`
  - **Database Interaction:** Retrieves a single record from the `cages` table where `id` matches.

- `GET /pet/{petId}`
  - **Description:** Gets the cage occupied by a specific pet.
  - **Path Variable:** `petId` (integer) - The ID of the pet.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `CageDTO` (or null/404 if pet not in a cage)
  - **Database Interaction:** Retrieves records from the `cages` table where `pet_id` matches.

- `POST /`
  - **Description:** Adds a new cage to the system. (Admin/Staff only)
  - **Request Body (application/json):**
    ```json
    {
      "type": "string",       // e.g., "DOG"
      "size": "string",       // e.g., "Large"
      "status": "string",     // e.g., "AVAILABLE"
      "start_date": "string", // Optional, for initial assignment
      "end_date": "string",   // Optional
      "pet_id": "integer"     // Optional, if assigning a pet immediately
    }
    ```
  - **Response (Success - 201 Created or 200 OK, application/json):** `CageDTO`
  - **Database Interaction:** Inserts a new record into the `cages` table.

- `PUT /{id}`
  - **Description:** Updates an existing cage's information or status.
  - **Path Variable:** `id` (integer) - The ID of the cage to update.
  - **Request Body (application/json):** `CageDTO` structure (fields to update)
    ```json
    {
      "type": "string",
      "size": "string",
      "status": "string",
      "start_date": "string",
      "end_date": "string",
      "pet_id": "integer" // Can be null to free up cage
    }
    ```
  - **Response (Success - 200 OK, application/json):** `CageDTO`
  - **Database Interaction:** Updates an existing record in the `cages` table where `id` matches. This is key for managing cage occupancy.

- `DELETE /{id}`
  - **Description:** Deletes a cage from the system. (Admin/Staff only)
  - **Path Variable:** `id` (integer) - The ID of the cage to delete.
  - **Request Body:** None.
  - **Response (Success - 200 OK or 204 No Content, application/json):** `CageDTO` or success message.
  - **Database Interaction:** Deletes a record from the `cages` table where `id` matches. Ensure cage is not occupied or handle re-assignment.

- `GET /status/{status}`
  - **Description:** Filters cages by their status.
  - **Path Variable:** `status` (string) - The status to filter by (e.g., "AVAILABLE", "OCCUPIED").
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `CageDTO`
  - **Database Interaction:** Retrieves records from the `cages` table where `status` matches.

- `GET /filter`
  - **Description:** Filters cages by type and size.
  - **Query Parameters:**
    - `type` (string, optional) - e.g., "DOG", "CAT"
    - `size` (string, optional) - e.g., "Large", "Small"
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `CageDTO`
  - **Database Interaction:** Retrieves records from the `cages` table matching the provided `type` and/or `size`.

### MedicalRecordController (`/api/records`)

Base Path: `/api/records`

- `GET /`
  - **Description:** Lists all medical records. (Admin/Doctor/Staff only)
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `MedicalRecordDTO`
    ```json
    [
      {
        "id": "integer",
        "diagnosis": "string",
        "prescription": "string",
        "notes": "string",
        "next_meeting_date": "string", // "YYYY-MM-DD" or "YYYY-MM-DD HH:mm:ss"
        "record_date": "string",       // "YYYY-MM-DD HH:mm:ss" (Creation date of record)
        "pet_id": "integer",
        "user_id": "integer"           // ID of the vet/staff who created the record
      }
    ]
    ```
  - **Database Interaction:** Retrieves all records from the `medical_records` table. May join with `pets` and `users` tables.

- `GET /{id}`
  - **Description:** Gets a specific medical record by its ID.
  - **Path Variable:** `id` (integer) - The ID of the medical record.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `MedicalRecordDTO`
  - **Database Interaction:** Retrieves a single record from the `medical_records` table where `id` matches.

- `GET /pet/{petId}`
  - **Description:** Gets all medical records for a specific pet.
  - **Path Variable:** `petId` (integer) - The ID of the pet.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `MedicalRecordDTO`
  - **Database Interaction:** Retrieves records from the `medical_records` table where `pet_id` matches.

- `GET /user/{userId}`
  - **Description:** Gets all medical records created by a specific user (vet/staff).
  - **Path Variable:** `userId` (integer) - The ID of the user (vet/staff).
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `MedicalRecordDTO`
  - **Database Interaction:** Retrieves records from the `medical_records` table where `user_id` (creator) matches.

- `POST /`
  - **Description:** Adds a new medical record for a pet. (Doctor/Staff only)
  - **Request Body (application/json):**
    ```json
    {
      "diagnosis": "string",          // e.g., "Fever and dehydration"
      "prescription": "string",       // e.g., "Rehydration and rest"
      "notes": "string",              // e.g., "Pet should recover in 3 days"
      "next_meeting_date": "string",  // "YYYY-MM-DD", e.g., "2025-06-10"
      "pet_id": "integer",            // ID of the pet
      "user_id": "integer"            // ID of the vet/staff creating the record (often current user)
    }
    ```
  - **Response (Success - 201 Created or 200 OK, application/json):** `MedicalRecordDTO`
  - **Database Interaction:** Inserts a new record into the `medical_records` table. `record_date` is typically set to current timestamp by the server.

- `PUT /{id}`
  - **Description:** Updates an existing medical record. (Doctor/Staff only)
  - **Path Variable:** `id` (integer) - The ID of the medical record to update.
  - **Request Body (application/json):** `MedicalRecordDTO` structure (fields to update)
    ```json
    {
      "diagnosis": "string",
      "prescription": "string",
      "notes": "string",
      "next_meeting_date": "string" // "YYYY-MM-DD"
      // pet_id and user_id are usually not changed here
    }
    ```
  - **Response (Success - 200 OK, application/json):** `MedicalRecordDTO`
  - **Database Interaction:** Updates an existing record in the `medical_records` table where `id` matches.

- `DELETE /{id}`
  - **Description:** Deletes a medical record. (Admin/Doctor only, or specific permissions)
  - **Path Variable:** `id` (integer) - The ID of the medical record to delete.
  - **Request Body:** None.
  - **Response (Success - 200 OK or 204 No Content, application/json):** `MedicalRecordDTO` or success message.
  - **Database Interaction:** Deletes a record from the `medical_records` table where `id` matches. (Consider if soft delete is more appropriate).

- `GET /my-records`
  - **Description:** Gets medical records relevant to the current user. If user is an owner, gets records for their pets. If user is a vet/staff, gets records they created.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `MedicalRecordDTO`
  - **Database Interaction:** Retrieves records from `medical_records`. If owner, filters by `pet_id` for their pets. If vet/staff, filters by `user_id` (creator).

### ServiceController (`/api/services`)

Base Path: `/api/services`

- `GET /`
  - **Description:** Lists all available services.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `ServicesDTO` (or `ServiceDTO`)
    ```json
    [
      {
        "id": "integer",
        "service_name": "string", // e.g., "Vaccination"
        "category": "string",     // e.g., "Health Check", "Grooming"
        "description": "string",
        "price": "number"         // e.g., 75.00
      }
    ]
    ```
  - **Database Interaction:** Retrieves all records from the `services` table.

- `GET /{id}`
  - **Description:** Gets a specific service by its ID.
  - **Path Variable:** `id` (integer) - The ID of the service.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `ServicesDTO`
  - **Database Interaction:** Retrieves a single record from the `services` table where `id` matches.

- `POST /`
  - **Description:** Adds a new service. (Admin only)
  - **Request Body (application/json):**
    ```json
    {
      "service_name": "string",
      "category": "string",
      "description": "string",
      "price": "number"
    }
    ```
  - **Response (Success - 201 Created or 200 OK, application/json):** `ServicesDTO`
  - **Database Interaction:** Inserts a new record into the `services` table.

- `PUT /{id}`
  - **Description:** Updates an existing service. (Admin only)
  - **Path Variable:** `id` (integer) - The ID of the service to update.
  - **Request Body (application/json):** `ServicesDTO` structure (fields to update)
    ```json
    {
      "service_name": "string",
      "category": "string",
      "description": "string",
      "price": "number"
    }
    ```
  - **Response (Success - 200 OK, application/json):** `ServicesDTO`
  - **Database Interaction:** Updates an existing record in the `services` table where `id` matches.

- `DELETE /{id}`
  - **Description:** Deletes a service. (Admin only)
  - **Path Variable:** `id` (integer) - The ID of the service to delete.
  - **Request Body:** None.
  - **Response (Success - 200 OK or 204 No Content, application/json):** `ServicesDTO` or success message.
  - **Database Interaction:** Deletes a record from the `services` table where `id` matches. Consider impact on existing bookings.

### ServiceBookingController (`/api/bookings`)

Base Path: `/api/bookings`

- `GET /`
  - **Description:** Lists all service bookings. (Admin/Staff only)
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `ServiceBookingDTO`
    ```json
    [
      {
        "id": "integer",
        "start_date": "string",   // "YYYY-MM-DD HH:mm:ss" or "YYYY-MM-DD"
        "end_date": "string",     // "YYYY-MM-DD HH:mm:ss" or "YYYY-MM-DD" (can be null/empty if not applicable)
        "notes": "string",
        "status": "string",       // e.g., "PENDING", "CONFIRMED", "CANCELLED", "COMPLETED"
        "user_id": "integer",     // Customer who booked
        "service_id": "integer",  // Service booked
        "pet_id": "integer"       // Optional: Pet for which service is booked
      }
    ]
    ```
  - **Database Interaction:** Retrieves all records from the `service_bookings` table. May join with `users`, `services`, `pets`.

- `GET /{id}`
  - **Description:** Gets a specific booking by its ID.
  - **Path Variable:** `id` (integer) - The ID of the booking.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `ServiceBookingDTO`
  - **Database Interaction:** Retrieves a single record from the `service_bookings` table where `id` matches.

- `GET /user/{userId}`
  - **Description:** Gets all bookings made by a specific user (customer).
  - **Path Variable:** `userId` (integer) - The ID of the user.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `ServiceBookingDTO`
  - **Database Interaction:** Retrieves records from the `service_bookings` table where `user_id` matches.

- `GET /service/{serviceId}`
  - **Description:** Gets all bookings for a specific service.
  - **Path Variable:** `serviceId` (integer) - The ID of the service.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `ServiceBookingDTO`
  - **Database Interaction:** Retrieves records from the `service_bookings` table where `service_id` matches.

- `POST /`
  - **Description:** Creates a new service booking.
  - **Request Body (application/json):**
    ```json
    {
      "start_date": "string",   // "YYYY-MM-DD" or "YYYY-MM-DD HH:mm:ss"
      "end_date": "string",     // Optional, "YYYY-MM-DD" or "YYYY-MM-DD HH:mm:ss"
      "notes": "string",
      "user_id": "integer",     // ID of the customer (usually current authenticated user)
      "service_id": "integer",  // ID of the service being booked
      "pet_id": "integer"       // Optional: ID of the pet for the service
    }
    ```
  - **Response (Success - 201 Created or 200 OK, application/json):** `ServiceBookingDTO` (with status "PENDING" or similar default)
  - **Database Interaction:** Inserts a new record into the `service_bookings` table. Default status is set (e.g., "PENDING").

- `PUT /{id}`
  - **Description:** Updates an existing booking. (Customer for their own, or Staff/Admin)
  - **Path Variable:** `id` (integer) - The ID of the booking to update.
  - **Request Body (application/json):** `ServiceBookingDTO` structure (fields to update)
    ```json
    {
      "start_date": "string",
      "end_date": "string",
      "notes": "string",
      "service_id": "integer", // Potentially updatable
      "pet_id": "integer"      // Potentially updatable
      // status is usually updated via PATCH /{id}/status
    }
    ```
  - **Response (Success - 200 OK, application/json):** `ServiceBookingDTO`
  - **Database Interaction:** Updates an existing record in the `service_bookings` table where `id` matches.

- `PUT /{id}/cancel`
  - **Description:** Cancels a booking.
  - **Path Variable:** `id` (integer) - The ID of the booking to cancel.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `ServiceBookingDTO` (with status "CANCELLED")
  - **Database Interaction:** Updates the `status` field of the booking record in `service_bookings` table to "CANCELLED".

- `DELETE /{id}`
  - **Description:** Deletes a booking. (Admin only, or specific conditions)
  - **Path Variable:** `id` (integer) - The ID of the booking to delete.
  - **Request Body:** None.
  - **Response (Success - 200 OK or 204 No Content, application/json):** `ServiceBookingDTO` or success message.
  - **Database Interaction:** Deletes a record from the `service_bookings` table where `id` matches.

- `GET /{id}/status`
  - **Description:** Gets the status of a specific booking.
  - **Path Variable:** `id` (integer) - The ID of the booking.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):**
    ```json
    {
      "id": "integer",      // Booking ID
      "status": "string"    // e.g., "PENDING", "CONFIRMED"
    }
    ```
  - **Database Interaction:** Retrieves the `status` field from the `service_bookings` table for the given `id`.

- `PATCH /{id}/status`
  - **Description:** Updates the status of a booking. (Admin/Staff only)
  - **Path Variable:** `id` (integer) - The ID of the booking.
  - **Query Parameter:** `status` (string) - The new status (e.g., "CONFIRMED", "COMPLETED", "CANCELLED").
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** `ServiceBookingDTO` (updated booking)
  - **Database Interaction:** Updates the `status` field of the booking record in the `service_bookings` table.

- `GET /my-bookings`
  - **Description:** Gets all bookings made by the currently authenticated user.
  - **Request Body:** None.
  - **Response (Success - 200 OK, application/json):** Array of `ServiceBookingDTO`
  - **Database Interaction:** Retrieves records from the `service_bookings` table where `user_id` matches the ID of the currently authenticated user.

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

---

## 4. Permissions & Roles

- **Roles:** OWNER, STAFF, DOCTOR, ADMIN
- **Role assignment:** Set on user creation or via admin endpoint
- **Role usage:**
  - Returned in user info endpoints (e.g., `/api/users/{id}/role`, `/api/users/my-info`)
  - Flutter frontend should use the `roles` field to control access to features
- **Endpoint restrictions:**
  - Some endpoints (e.g., update user role, add service) are restricted to ADMIN or specific roles (see controller method annotations)

---

## 5. Backend Flow

- On startup, the backend auto-creates tables and initial users for each role if not present (see `ApplicationInitConfig`)
- Authentication is handled by Spring Security (form login, session-based)
- Authorization is enforced via method-level security and custom handlers for access denied/unauthorized
- All API errors are returned in a consistent JSON format

---

## 6. Database Name
- The MySQL database name is: `test_MedicalRecord`

---

## 7. Notes for Flutter Frontend
- Use the `/api/auth/login` endpoint for authentication; store session/cookie as needed
- Use `/api/users/my-info` to get current user info and role
- Use the `roles` field to control frontend permissions
- Handle error responses as described above

---

*Generated by reading the backend source code. For further details, see the Java classes in `BE/pet/src/main/java/com/demo/pet/`.*
