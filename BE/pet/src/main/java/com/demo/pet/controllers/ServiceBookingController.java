package com.demo.pet.controllers;

import com.demo.pet.dtos.ServiceBookingDTO;
import com.demo.pet.dtos.subDTO.BookingStatusDTO;
import com.demo.pet.models.ServiceBooking;
import com.demo.pet.services.ServiceBookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for managing service booking operations in the Pet Clinic system.
 * <p>
 * Exposes endpoints for CRUD operations, booking status management, and retrieval by user or service.
 * </p>
 * <p>
 *     See info about Controllers Overview: <a href="../../../../custom-docs/ControllerOverview.html" target="_blank">Controllers Overview</a>
 * </p>
 * <p>
 *     See info about Controller Annotations: <a href="../../../../custom-docs/ControllerAnnotation.html" target="_blank">Controller Annotation</a>
 * </p>
 *
 * @see com.demo.pet.services.ServiceBookingService
 * @see com.demo.pet.dtos.ServiceBookingDTO
 * @since 1.0
 */
@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class ServiceBookingController {
    private final ServiceBookingService bookingService;

    /**
     * Retrieves all service bookings.
     * <p>
     *     Accessible by users with ADMIN or STAFF roles.
     * </p>
     *
     * @return a list of all service bookings
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @GetMapping("")
    public ResponseEntity<List<ServiceBookingDTO>> getAllBookings() {
        return ResponseEntity.ok(bookingService.getAllBookings());
    }

    /**
     * Retrieves a service booking by its ID.
     *
     * @param id the ID of the booking
     * @return the service booking with the specified ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<ServiceBookingDTO> getBookingById(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.getBookingById(id));
    }

    /**
     * Retrieves all bookings made by a specific user.
     *
     * @param userId The user ID.
     * @return A list of ServiceBookingDTO objects.
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<ServiceBookingDTO>> getBookingsByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(bookingService.getBookingsByUserId(userId));
    }

    /**
     * Retrieves all bookings for a specific service.
     *
     * @param serviceId The service ID.
     * @return A list of ServiceBookingDTO objects.
     */
    @GetMapping("/service/{serviceId}")
    public ResponseEntity<List<ServiceBookingDTO>> getBookingsByServiceId(@PathVariable Long serviceId) {
        return ResponseEntity.ok(bookingService.getBookingsByServiceId(serviceId));
    }

    /**
     * Creates a new booking.
     *
     * @param bookingDTO The ServiceBookingDTO object.
     * @return The created ServiceBookingDTO object.
     */
    @PostMapping("")
    public ResponseEntity<ServiceBookingDTO> createBooking(@RequestBody ServiceBookingDTO bookingDTO) {
        return ResponseEntity.ok(bookingService.createBooking(bookingDTO));
    }

    /**
     * Updates an existing booking.
     *
     * @param id         The booking ID.
     * @param bookingDTO The updated ServiceBookingDTO object.
     * @return The updated ServiceBookingDTO object.
     */
    @PutMapping("/{id}")
    public ResponseEntity<ServiceBookingDTO> updateBooking(@PathVariable Long id, @RequestBody ServiceBookingDTO bookingDTO) {
        return ResponseEntity.ok(bookingService.updateBooking(id, bookingDTO));
    }

    /**
     * Cancels a booking.
     *
     * @param id The booking ID.
     * @return The cancelled ServiceBookingDTO object.
     */
    @PutMapping("/{id}/cancel")
    public ResponseEntity<ServiceBookingDTO> cancelBooking(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.cancelBooking(id));
    }

    /**
     * Deletes a booking.
     * <p>
     *     Accessible by users with ADMIN or STAFF roles.
     * </p>
     *
     * @param id the ID of the booking to delete
     * @return the deleted service booking
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @DeleteMapping("/{id}")
    public ResponseEntity<ServiceBookingDTO> deleteBooking(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.deleteBooking(id));
    }

    /**
     * Retrieves the status of a booking by ID.
     *
     * @param id The booking ID.
     * @return The BookingStatusDTO object.
     */
    @GetMapping("/{id}/status")
    public ResponseEntity<BookingStatusDTO> getBookingStatus(@PathVariable Long id){
        return ResponseEntity.ok(bookingService.getBookingStatus(id));
    }

    /**
     * Updates the status of a booking.
     * <p>
     *     Accessible by users with ADMIN or STAFF roles.
     * </p>
     *
     * @param id the ID of the booking
     * @param status the new status to set
     * @return the updated service booking
     */
    // only for admin and staff
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @PatchMapping("/{id}/status")
    public ResponseEntity<ServiceBookingDTO> updateBookingStatus(@PathVariable Long id, @RequestParam String status) {
        return ResponseEntity.ok(bookingService.updateBookingStatus(id, status));
    }

    /**
     * Retrieves all bookings made by the currently authenticated user.
     * <p>
     *     Accessible by all authenticated users.
     * </p>
     *
     * @return a list of service bookings made by the current user
     */
    @GetMapping("/my-bookings")
    public ResponseEntity<List<ServiceBookingDTO>> getMyBookings() {
        return ResponseEntity.ok(bookingService.getMyBookings());
    }
}
