package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

/**
 * Represents a service entity that can be booked by customers.
 * <p>
 * Services belong to specific categories and have associated pricing.
 * Each service can be linked to multiple bookings through {@link ServiceBooking}.
 * </p>
 * See info about Models Overview:  <a href="../../../../custom-docs/ModelsOverview.html" target="_blank">Models Overview</a>
 * <p>
 *     See info about Models Annotation:  <a href="../../../../custom-docs/ModelsAnnotation.html" target="_blank">Models Annotation</a>
 * </p>
 *
 * @see BaseModel
 * @see ServiceBooking
 * @since 1.0
 */
@Getter
@Setter
@Entity
@Table(name = "services")
@FieldDefaults(level = AccessLevel.PRIVATE)
@AllArgsConstructor
@NoArgsConstructor
public class Services extends BaseModel {
    /**
     * The name of the service (max 100 characters).
     * Must not be null.
     */
    @Column(name = "name", nullable = false, length = 100)
    String name;

    /**
     * Category classification of the service.
     * This field uses an enum to define the type of service.
     * @see CategoryTypes
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "category")
    CategoryTypes category;

    /**
     * Detailed description of the service.
     * Stored as TEXT in database.
     */
    @Column(name = "description", columnDefinition = "TEXT")
    String description;

    /**
     * Price of the service in the default currency.
     * Must be a positive number if specified.
     * May be null for services with dynamic pricing.
     */
    @Column(name = "price")
    Double price;

    /**
     * List of bookings associated with this service.
     * This is the inverse side of the bidirectional relationship.
     * Mapped by the "services" field in {@link ServiceBooking}.
     */
    @OneToMany(mappedBy = "services")
    List<ServiceBooking> serviceBookingList;

    /**
     * Enum representing the categories of services.
     * Used to classify services into logical groups.
     * <p>
     *     Possible values include: <br>
     *     - EMERGENCY: Services related to urgent care. <br>
     *     - HEALTH: General health services. <br>
     *     - CARE: Services focused on pet care. <br>
     *     - MEDICAL: Medical services for pets.
     * </p>
     *
     * @see #EMERGENCY Emergency medical services
     * @see #HEALTH General health checkups
     * @see #CARE Daily care services (e.g., grooming)
     * @see #MEDICAL Specialized medical procedures
     */
    public enum CategoryTypes {
        /** Emergency medical services (e.g., injury treatment). */
        EMERGENCY,
        /** Routine health services (e.g., vaccination). */
        HEALTH,
        /** Non-medical care (e.g., pet sitting). */
        CARE,
        /** Advanced medical procedures (e.g., surgery). */
        MEDICAL
    }
}
