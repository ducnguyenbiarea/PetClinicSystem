package com.demo.pet.services;

import com.demo.pet.dtos.ServiceBookingDTO;
import com.demo.pet.dtos.subDTO.BookingStatusDTO;
import com.demo.pet.models.ServiceBooking;

import java.util.List;


/**
 * Service interface for managing medical record business logic in the Pet Clinic system.
 * <p>
 * Provides methods for CRUD operations and retrieval by pet or user.
 * </p>
 * <p>
 *     See more in: <a href="../../../../custom-docs/ServiceOverview.html" target="_blank">ServiceOverview</a>
 * </p>
 *
 * @see com.demo.pet.dtos.MedicalRecordDTO
 * @since 1.0
 */
public interface ServiceBookingService {
    /**
     * Get all service bookings.
     *
     * @return List of ServiceBookingDTO representing all bookings.
     */
    List<ServiceBookingDTO> getAllBookings();

    /**
     * Get a booking by its ID.
     *
     * @param id The ID of the booking to retrieve.
     * @return ServiceBookingDTO representing the booking with the specified ID.
     */
    ServiceBookingDTO getBookingById(Long id);

    /**
     * Get all bookings made by a specific user by their ID.
     *
     * @param userId The ID of the user to get bookings for.
     * @return List of ServiceBookingDTO representing the user's bookings.
     */
    List<ServiceBookingDTO> getBookingsByUserId(Long userId);

    /**
     * Get all bookings for a specific service by its ID.
     *
     * @param serviceId The ID of the service to get bookings for.
     * @return List of ServiceBookingDTO representing the bookings for the specified service.
     */
    List<ServiceBookingDTO> getBookingsByServiceId(Long serviceId);

    /**
     * Create a new booking.
     *
     * @param bookingDTO The booking details to create.
     * @return Created ServiceBookingDTO.
     */
    ServiceBookingDTO createBooking(ServiceBookingDTO bookingDTO);

    /**
     * Update an existing booking by its ID.
     *
     * @param id         The ID of the booking to update.
     * @param bookingDTO The updated booking details.
     * @return Updated ServiceBookingDTO.
     */
    ServiceBookingDTO updateBooking(Long id, ServiceBookingDTO bookingDTO);

    /**
     * Cancel a booking by its ID.
     *
     * @param id The ID of the booking to cancel.
     * @return Updated ServiceBookingDTO with the status set to "CANCELLED".
     */
    ServiceBookingDTO cancelBooking(Long id);

    /**
     * Delete a booking by its ID.
     *
     * @param id The ID of the booking to delete.
     * @return Deleted ServiceBookingDTO.
     */
    ServiceBookingDTO deleteBooking(Long id);

    /**
     * Get the status of a booking by its ID.
     *
     * @param id The ID of the booking to retrieve the status for.
     * @return BookingStatusDTO containing the booking ID and its status.
     */
    BookingStatusDTO getBookingStatus(Long id);

    /**
     * Update the status of a booking.
     *
     * @param id     The ID of the booking to update.
     * @param status The new status to set for the booking.
     * @return Updated ServiceBookingDTO with the new status.
     */
    ServiceBookingDTO updateBookingStatus(Long id, String status);

    /**
     * Get all bookings made by the currently authenticated user.
     *
     * @return List of ServiceBookingDTO representing the user's bookings.
     */
    List<ServiceBookingDTO> getMyBookings();
}
