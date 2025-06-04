package com.demo.pet.dtos;

import com.demo.pet.models.Pet;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

/**
 * Represents a Data Transfer Object (DTO) for pet data in the Pet Clinic system.
 * <p>
 * Used to transfer pet information between application layers or over the network,
 * decoupling the API contract from the internal model structure.
 * Includes fields such as name, birth date, gender, species, color, health info, and user ID.
 * </p>
 * See info about DTOs Overview: <a href="../../../../custom-docs/DtosOverview.html" target="_blank">DTOs Overview</a>
 * <p>
 *     See info about DTOs Annotation: <a href="../../../../custom-docs/DtosAnnotation.html" target="_blank">DTOs Annotation</a>
 * </p>
 *
 * @see com.demo.pet.models.Pet
 * @since 1.0
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonPropertyOrder({
        "id",
        "name",
        "birth_date",
        "gender",
        "species",
        "color",
        "health_info",
        "user_id"
})
public class PetDTO {
    /**
     * Unique identifier for the pet.
     */
    Long id;

    /**
     * Name of the pet.
     */
    String name;

    /**
     * Birth date of the pet.
     * <p>
     * Mapped to "birth_date" in JSON.
     * </p>
     */
    @JsonProperty("birth_date")
    LocalDate birthDate;

    /**
     * Gender of the pet (enum as string).
     */
    String gender;

    /**
     * Species of the pet.
     */
    String species;

    /**
     * Color of the pet.
     */
    String color;

    /**
     * Health information about the pet.
     * <p>
     * Mapped to "health_info" in JSON.
     * </p>
     */
    @JsonProperty("health_info")
    String healthInfo;

    /**
     * ID of the user (owner) of the pet.
     * <p>
     * Mapped to "user_id" in JSON.
     * </p>
     */
    @JsonProperty("user_id")
    Long userId;

    /**
     * Converts a {@link com.demo.pet.models.Pet} entity to a {@code PetDTO}.
     *
     * @param pet the Pet entity to convert
     * @return a new PetDTO with data mapped from the entity
     */
    public static PetDTO fromEntity(Pet pet) {
        return new PetDTO(
                pet.getId(),
                pet.getName(),
                pet.getBirthDate(),
                pet.getGender() != null ? pet.getGender().name() : null,
                pet.getSpecies(),
                pet.getColor(),
                pet.getHealthInfo(),
                pet.getUser() != null ? pet.getUser().getId() : null
        );
    }
}

