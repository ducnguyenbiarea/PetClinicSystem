package com.demo.pet.repositories;

import com.demo.pet.models.ServiceBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository interface for managing {@link ServiceBooking} entities in the Pet Clinic system.
 * <p>
 * Provides CRUD operations and custom queries for service booking data, abstracting database access.
 * </p>
 * <p>
 *     See info about Repository Overview: <a href="../../../../custom-docs/RepoOverview.html" target="_blank">RepoOverview</a>
 * </p>
 * <p>
 *     Annotated with {@link Repository} for Spring component scanning and exception translation.
 * </p>
 *
 * @see com.demo.pet.models.ServiceBooking
 * @see org.springframework.data.jpa.repository.JpaRepository
 * @since 1.0
 */
@Repository
public interface ServiceBookingRepo extends JpaRepository<ServiceBooking, Long> {
    /**
     * Finds all service bookings made by a specific user.
     *
     * @param userId the ID of the user
     * @return list of service bookings for the user
     */
    List<ServiceBooking> findByUserId(Long userId);

    /**
     * Finds all service bookings for a specific service.
     *
     * @param serviceId the ID of the service
     * @return list of service bookings for the service
     */
    List<ServiceBooking> findByServicesId(Long serviceId);
}
