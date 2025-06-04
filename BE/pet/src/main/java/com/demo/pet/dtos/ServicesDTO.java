package com.demo.pet.dtos;

import com.demo.pet.models.Services;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

/**
 * Represents a Data Transfer Object (DTO) for service data in the Pet Clinic system.
 * <p>
 * Used to transfer service information between application layers or over the network,
 * decoupling the API contract from the internal model structure.
 * Includes fields such as service name, category, description, and price.
 * </p>
 * See info about DTOs Overview: <a href="../../../../custom-docs/DtosOverview.html" target="_blank">DTOs Overview</a>
 * <p>
 *     See info about DTOs Annotation: <a href="../../../../custom-docs/DtosAnnotation.html" target="_blank">DTOs Annotation</a>
 * </p>
 *
 * @see com.demo.pet.models.Services
 * @since 1.0
 */
@Getter
@Setter
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonPropertyOrder({
        "id",
        "service_name",
        "category",
        "description",
        "price"
})
public class ServicesDTO {
    /**
     * Unique identifier for the service.
     */
    Long id;

    /**
     * Name of the service.
     * <p>
     * Mapped to "service_name" in JSON.
     * </p>
     */
    @JsonProperty("service_name")
    String name;

    /**
     * Category of the service (enum as string).
     */
    String category; // dùng String để chuyển enum sang tên

    /**
     * Description of the service.
     */
    String description;

    /**
     * Price of the service.
     */
    Double price;

    /**
     * Converts a {@link com.demo.pet.models.Services} entity to a {@code ServicesDTO}.
     *
     * @param services the Services entity to convert
     * @return a new ServicesDTO with data mapped from the entity
     */
    public static ServicesDTO fromEntity(Services services){
        return new ServicesDTO(
                services.getId(),
                services.getName(),
                services.getCategory().name(), // enum to string
                services.getDescription(),
                services.getPrice()
        );
    }
}
