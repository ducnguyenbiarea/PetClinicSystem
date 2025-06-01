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

@Getter
@Setter
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonPropertyOrder({
        "id",
        "user_name",
        "password",
        "phone",
        "email",
        "roles"
})
public class UserDTO {
    Long id;

    @JsonProperty("user_name")
    @Size(min = 2, message = "Username must be at least 2 characters long")
    String name;

    @JsonProperty(value = "password", access = JsonProperty.Access.WRITE_ONLY)
    @Size(min = 10, message = "Password must be at least 10 characters long")
    String password;

    @JsonProperty("phone")
    String phone;

    @JsonProperty("email")
    String email;

    @JsonProperty("roles")
    String roles;

    public static UserDTO fromEntity(User user) {
        return new UserDTO(
                user.getId(),
                user.getName(),
                user.getPassWord(),
                user.getPhone(),
                user.getEmail(),
                user.getRoles().name()
        );
    }
}
