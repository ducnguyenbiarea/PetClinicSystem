package com.demo.pet.dtos;

import com.demo.pet.models.User;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import jakarta.validation.constraints.Size;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;
import java.util.List;

/**
 * Represents a Data Transfer Object (DTO) for user data in the Pet Clinic system.
 * <p>
 * Used to transfer user information between application layers or over the network,
 * decoupling the API contract from the internal model structure.
 * Includes fields such as user name, password, phone, and email.
 * </p>
 * See info about DTOs Overview: <a href="../../../../custom-docs/DtosOverview.html" target="_blank">DTOs Overview</a>
 * <p>
 *     See info about DTOs Annotation: <a href="../../../../custom-docs/DtosAnnotation.html" target="_blank">DTOs Annotation</a>
 * </p>
 *
 * @see com.demo.pet.models.User
 * @since 1.0
 */
@Getter
@Setter
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonPropertyOrder({
        "id",
        "user_name",
        "password",
        "phone",
        "email"
})
public class UserDTO {
    /**
     * Unique identifier for the user.
     */
    Long id;

    /**
     * User's full name.
     * <p>
     * Mapped to "user_name" in JSON.
     * Must be at least 2 characters long.
     * </p>
     */
    @JsonProperty("user_name")
    @Size(min = 2, message = "Username must be at least 2 characters long")
    String name;

    /**
     * User's password.
     * <p>
     * Write-only in JSON serialization for security.
     * Must be at least 10 characters long.
     * </p>
     */
    @JsonProperty(value = "password", access = JsonProperty.Access.WRITE_ONLY)
    @Size(min = 10, message = "Password must be at least 10 characters long")
    String password;

    /**
     * User's phone number.
     */
    @JsonProperty("phone")
    String phone;

    /**
     * User's email address.
     */
    @JsonProperty("email")
    String email;

    /**
     * Converts a {@link com.demo.pet.models.User} entity to a {@code UserDTO}.
     *
     * @param user the User entity to convert
     * @return a new UserDTO with data mapped from the entity
     */
    public static UserDTO fromEntity(User user) {
        return new UserDTO(
                user.getId(),
                user.getName(),
                user.getPassWord(),
                user.getPhone(),
                user.getEmail()
        );
    }
}
