package com.demo.pet.dtos;

import com.demo.pet.models.Cage;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

/**
 * Represents a Data Transfer Object (DTO) for cage data in the Pet Clinic system.
 * <p>
 * Used to transfer cage information between application layers or over the network,
 * decoupling the API contract from the internal model structure.
 * Includes fields such as type, size, status, occupancy dates, and pet ID.
 * </p>
 * See info about DTOs Overview: <a href="../../../../custom-docs/DtosOverview.html" target="_blank">DTOs Overview</a>
 * <p>
 *     See info about DTOs Annotation: <a href="../../../../custom-docs/DtosAnnotation.html" target="_blank">DTOs Annotation</a>
 * </p>
 *
 * @see com.demo.pet.models.Cage
 * @since 1.0
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonPropertyOrder({
        "id",
        "type",
        "size",
        "status",
        "start_date",
        "end_date",
        "pet_id"
})
public class CageDTO {
    /**
     * Unique identifier for the cage.
     */
    Long id;

    /**
     * Type of the cage (e.g., small, large, special).
     */
    String type;

    /**
     * Size of the cage (e.g., S, M, L).
     */
    String size;

    /**
     * Status of the cage (enum as string).
     */
    String status;

    /**
     * Start date of occupancy.
     * <p>
     * Mapped to "start_date" in JSON.
     * </p>
     */
    @JsonProperty("start_date")
    LocalDate startDate;

    /**
     * End date of occupancy.
     * <p>
     * Mapped to "end_date" in JSON.
     * </p>
     */
    @JsonProperty("end_date")
    LocalDate endDate;

    /**
     * ID of the pet assigned to this cage.
     * <p>
     * Mapped to "pet_id" in JSON.
     * </p>
     */
    @JsonProperty("pet_id")
    Long petId;

    /**
     * Converts a {@link com.demo.pet.models.Cage} entity to a {@code CageDTO}.
     *
     * @param cage the Cage entity to convert
     * @return a new CageDTO with data mapped from the entity
     */
    public static CageDTO fromEntity(Cage cage) {
        return new CageDTO(
                cage.getId(),
                cage.getType(),
                cage.getSize(),
                cage.getStatus() != null ? cage.getStatus().name() : null,
                cage.getStartDate(),
                cage.getEndDate(),
                cage.getPet() != null ? cage.getPet().getId() : null
        );
    }
}