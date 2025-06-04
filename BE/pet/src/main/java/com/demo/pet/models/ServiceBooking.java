package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

/**
 * Represents a booking of a service by a user in the Pet Clinic system.
 * <p>
 * Each booking links a user to a specific service, with a defined time period and status.
 * Bookings can include additional notes and track their current state.
 * </p>
 * See info about Models Overview:  <a href="../../../../custom-docs/ModelsOverview.html" target="_blank">Models Overview</a>
 * <p>
 *     See info about Models Annotation:  <a href="../../../../custom-docs/ModelsAnnotation.html" target="_blank">Models Annotation</a>
 * </p>
 *
 * @see BaseModel
 * @see User
 * @see Services
 * @since 1.0
 */
@Getter
@Setter
@Entity
@Table(name = "service_booking")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ServiceBooking extends BaseModel {
    /**
     * Start date of the service booking.
     * Must not be null.
     */
    @Column(name = "start_date", nullable = false)
    LocalDate startDate;

    /**
     * End date of the service booking.
     * May be null for single-day or open-ended bookings.
     */
    @Column(name = "end_date")
    LocalDate endDate;

    /**
     * Status of the booking.
     * Uses an enum to represent the current state.
     * @see SubscriptionStatus
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "status", columnDefinition = "VARCHAR(20) DEFAULT 'PENDING'")
    SubscriptionStatus status; // PENDING, ACCEPTED, COMPLETED, CANCELLED

    /**
     * Additional notes or instructions for the booking.
     * Stored as TEXT in the database.
     */
    @Column(name = "notes", columnDefinition = "TEXT")
    String notes;

    /**
     * The user who made the booking.
     * Many-to-one relationship to {@link User}.
     */
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    User user;

    /**
     * The service being booked.
     * Many-to-one relationship to {@link Services}.
     */
    @ManyToOne
    @JoinColumn(name = "service_id", nullable = false)
    Services services;

    /**
     * Enum representing the possible statuses of a service booking.
     * <p>
     *     Possible values include: <br>
     *     - PENDING: Booking is awaiting confirmation. <br>
     *     - ACCEPTED: Booking has been accepted. <br>
     *     - COMPLETED: Service has been provided. <br>
     *     - CANCELLED: Booking was cancelled.
     * </p>
     *
     * @see #PENDING Awaiting confirmation
     * @see #ACCEPTED Confirmed and scheduled
     * @see #COMPLETED Service completed
     * @see #CANCELLED Booking cancelled
     */
    public enum SubscriptionStatus {
        /** Booking is awaiting confirmation. */
        PENDING,
        /** Booking has been accepted. */
        ACCEPTED,
        /** Service has been completed. */
        COMPLETED,
        /** Booking was cancelled. */
        CANCELLED
    }
}
