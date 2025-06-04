package com.demo.pet.dtos;

import com.demo.pet.models.ServiceBooking;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

/**
 * Represents a Data Transfer Object (DTO) for service booking data in the Pet Clinic system.
 * <p>
 * Used to transfer service booking information between application layers or over the network,
 * decoupling the API contract from the internal model structure.
 * Includes fields such as booking dates, notes, user ID, and service ID.
 * </p>
 * See info about DTOs Overview: <a href="../../../../custom-docs/DtosOverview.html" target="_blank">DTOs Overview</a>
 * <p>
 *     See info about DTOs Annotation: <a href="../../../../custom-docs/DtosAnnotation.html" target="_blank">DTOs Annotation</a>
 * </p>
 *
 * @see com.demo.pet.models.ServiceBooking
 * @since 1.0
 */
@Getter
@Setter
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonPropertyOrder({
        "id",
        "start_date",
        "end_date",
        "notes",
        "user_id",
        "service_id"
})
public class ServiceBookingDTO {
    /**
     * Unique identifier for the service booking.
     */
    Long id;

    /**
     * Start date of the booking.
     * <p>
     * Mapped to "start_date" in JSON.
     * </p>
     */
    @JsonProperty("start_date")
    LocalDate startDate;

    /**
     * End date of the booking.
     * <p>
     * Mapped to "end_date" in JSON.
     * </p>
     */
    @JsonProperty("end_date")
    LocalDate endDate;

    /**
     * Additional notes for the booking.
     */
    String notes;

    /**
     * ID of the user who made the booking.
     * <p>
     * Mapped to "user_id" in JSON.
     * </p>
     */
    @JsonProperty("user_id")
    Long userId;

    /**
     * ID of the service being booked.
     * <p>
     * Mapped to "service_id" in JSON.
     * </p>
     */
    @JsonProperty("service_id")
    Long serviceId;

    /**
     * Converts a {@link com.demo.pet.models.ServiceBooking} entity to a {@code ServiceBookingDTO}.
     *
     * @param serviceBooking the ServiceBooking entity to convert
     * @return a new ServiceBookingDTO with data mapped from the entity
     */
    public static ServiceBookingDTO fromEntity(ServiceBooking serviceBooking) {
        return new ServiceBookingDTO(
                serviceBooking.getId(),
                serviceBooking.getStartDate(),
                serviceBooking.getEndDate(),
                serviceBooking.getNotes(),
                serviceBooking.getUser().getId(),
                serviceBooking.getServices().getId()
        );
    }
}
