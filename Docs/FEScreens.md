<!-- ...existing code... -->
# Front-End Screens Analysis for PetClinicSystem

This document outlines potential front-end screens based on the backend API capabilities and user roles. The system supports role-based access, meaning users will only see screens and functionalities relevant to their permissions. The goal is to minimize the number of distinct screens by using shared interfaces with role-specific actions.

## User Roles Identified:
-   **Owner:** Pet owners who use the system to manage their pets and appointments.
-   **Staff:** Clinic staff who manage administrative tasks, bookings, and potentially assist with pet and cage management.
-   **Doctor:** Veterinarians who manage medical records and provide care.
-   **Admin:** System administrators with full access to manage users, services, and all other aspects of the system.

---

## I. Common Screens (Accessible to most authenticated users)

1.  **Login Screen**
    *   **Functionality:** User authentication (email/password).
    *   **Relevant APIs:** `POST /api/auth/login`
    *   **Accessible by:** All users (before authentication).

2.  **Registration Screen**
    *   **Functionality:** New user registration (primarily for Owners).
    *   **Relevant APIs:** `POST /api/auth/register`
    *   **Accessible by:** Prospective Owners.

3.  **Dashboard/Home Screen**
    *   **Functionality:** Landing page after login, displaying relevant information and navigation based on user role. May include summaries or quick links to role-specific management areas.
    *   **Accessible by:** All authenticated users. Content will vary.

4.  **My Profile Screen**
    *   **Functionality:** View and update the logged-in user's own information (name, email, phone). Password change.
    *   **Relevant APIs:** `GET /api/users/my-info`, `PUT /api/users/{id}` (for self)
    *   **Accessible by:** All authenticated users.

5.  **Services List Screen**
    *   **Functionality:** Browse available clinic services, view details and pricing.
    *   **Relevant APIs:** `GET /api/services`, `GET /api/services/{id}`
    *   **Accessible by:** All users (authenticated or public, depending on design).

6.  **Access Denied Screen**
    *   **Functionality:** Displayed when a user attempts to access a resource they don't have permission for.
    *   **Relevant APIs:** `GET /api/auth/access-denied` (redirect target)
    *   **Accessible by:** Any user who triggers an authorization failure.

---

## II. Owner-Specific Screens

1.  **My Pets & Medical Records Screen**
    *   **Functionality:**
        *   List pets owned by the logged-in user.
        *   Add new pet, edit existing pet details, delete pet.
        *   View detailed information for a selected pet.
        *   View medical records for a selected pet.
    *   **Relevant APIs:**
        *   Pets: `GET /api/pets/my-pets`, `POST /api/pets`, `GET /api/pets/{id}`, `PUT /api/pets/{id}`, `DELETE /api/pets/{id}`
        *   Medical Records: `GET /api/records/pet/{petId}` (for viewing)
    *   **Accessible by:** Owner.
    *   **Sub-screens/Modals:** Add Pet Form, Edit Pet Form.

2.  **My Bookings Screen**
    *   **Functionality:**
        *   List bookings made by the logged-in user.
        *   Create new booking (selecting service, pet, date).
        *   View booking details.
        *   Cancel an upcoming booking (if permitted by business logic).
    *   **Relevant APIs:** `GET /api/bookings/my-bookings`, `POST /api/bookings`, `GET /api/bookings/{id}`, `PUT /api/bookings/{id}/cancel` (or `PATCH /api/bookings/{id}/status` to set to CANCELLED)
    *   **Accessible by:** Owner.
    *   **Sub-screens/Modals:** Create Booking Form.

---

## III. Clinic Operations Management Screen

*(This screen consolidates Pet, Cage, and Booking management for authorized staff, with enhanced capabilities for Admins.)*

*   **Functionality:**
    *   **Pet Management Section:**
        *   List all pets in the system with search/filter.
        *   View/Edit pet details.
        *   (Admin only: Potentially delete pets, reassign ownership if necessary).
    *   **Cage Management Section:**
        *   List all cages, view status (available, occupied, cleaning), filter.
        *   Add, Edit, Delete cages.
        *   Assign/Unassign pets to/from cages.
    *   **Booking Management Section:**
        *   List all bookings, search/filter by user, service, status, date.
        *   View booking details.
        *   Update booking status (e.g., confirm, complete, cancel).
        *   (Admin only: Potentially delete bookings).
*   **Relevant APIs:**
    *   Pets: `GET /api/pets`, `GET /api/pets/{id}`, `PUT /api/pets/{id}`. Admin: `DELETE /api/pets/{id}`.
    *   Cages: `GET /api/cages`, `POST /api/cages`, `GET /api/cages/{id}`, `PUT /api/cages/{id}`, `DELETE /api/cages/{id}`, `GET /api/cages/status/{status}`, `GET /api/cages/filter`, `GET /api/cages/pet/{petId}`.
    *   Bookings: `GET /api/bookings`, `GET /api/bookings/{id}`, `PATCH /api/bookings/{id}/status`, `GET /api/bookings/user/{userId}`, `GET /api/bookings/service/{serviceId}`. Admin: `DELETE /api/bookings/{id}`.
*   **Accessible by:** Staff, Admin. (Doctors might have read-only access to parts or no access depending on workflow).
*   **Sub-screens/Modals:** Add/Edit Pet Form (for staff), Add/Edit Cage Form, Update Booking Status Modal.

---

## IV. Medical Records Management Screen

*(Centralized screen for Doctors, Staff, and Admins to manage medical records, with role-specific capabilities.)*

*   **Functionality:**
    *   List all medical records with comprehensive search/filter (by pet, owner, doctor, date).
    *   View detailed medical record.
    *   View a specific pet's complete medical history.
    *   Add new medical record for a pet (primarily Doctors, possibly Staff).
    *   Edit existing medical record (primarily Doctors, possibly Staff, with restrictions).
    *   (Admin only: Potentially delete or archive medical records, manage record templates if applicable).
*   **Relevant APIs:** `GET /api/records`, `POST /api/records`, `GET /api/records/{id}`, `PUT /api/records/{id}`, `GET /api/records/pet/{petId}`, `GET /api/records/user/{userId}` (to filter records created by a specific doctor/staff), `GET /api/pets/{id}` (to get pet details for context). Admin: `DELETE /api/records/{id}`.
*   **Accessible by:** Doctor, Staff, Admin.
*   **Sub-screens/Modals:** Add/Edit Medical Record Form.

---

## V. Admin-Specific Screens (System-Wide Configuration)

1.  **User Management Screen**
    *   **Functionality:**
        *   List all users (Owners, Staff, Doctors, Admins).
        *   Search/filter users.
        *   Create new users (for Staff, Doctor, Admin roles).
        *   View/Edit user details (name, email, phone, roles).
        *   Activate/Deactivate users.
        *   Delete users.
    *   **Relevant APIs:** `GET /api/users`, `POST /api/users`, `GET /api/users/{id}`, `PUT /api/users/{id}`, `DELETE /api/users/{id}`, `PATCH /api/users/{id}/role`, `GET /api/users/email/{email}`.
    *   **Accessible by:** Admin.
    *   **Sub-screens/Modals:** Add User Form, Edit User Form (including role assignment).

2.  **Service Management Screen**
    *   **Functionality:**
        *   List all clinic services.
        *   Add new services (name, category, description, price).
        *   Edit existing service details.
        *   Delete services (consider impact on existing bookings - soft delete or deactivation might be preferable).
    *   **Relevant APIs:** `GET /api/services`, `POST /api/services`, `GET /api/services/{id}`, `PUT /api/services/{id}`, `DELETE /api/services/{id}`.
    *   **Accessible by:** Admin.
    *   **Sub-screens/Modals:** Add Service Form, Edit Service Form.

---

This revised list aims for a more streamlined front-end by consolidating management tasks into fewer, more powerful screens, leveraging role-based permissions to tailor the user experience. Each screen would still be composed of various UI elements to interact with the backend.
<!-- ...existing code... -->