package com.demo.pet.dtos.subDTO;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * Data Transfer Object (DTO) for representing a user's role in the Pet Clinic system.
 * <p>
 * Used to transfer user ID and role information between application layers or over the network,
 * decoupling the API contract from the internal model structure.
 * </p>
 * See info about DTOs Overview: <a href="../../../custom-docs/DtosOverview.html" target="_blank">DTOs Overview</a>
 * <p>
 *     See info about DTOs Annotation: <a href="../../../custom-docs/DtosAnnotation.html" target="_blank">DTOs Annotation</a>
 * </p>
 *
 * @since 1.0
 */
@Data
@AllArgsConstructor
public class UserRoleDTO {
    /**
     * Unique identifier for the user.
     */
    private Long id;

    /**
     * Role of the user (enum as string).
     */
    private String roles;
}
