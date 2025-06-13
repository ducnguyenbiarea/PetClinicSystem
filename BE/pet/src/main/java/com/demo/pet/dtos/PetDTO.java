package com.demo.pet.dtos;

import com.demo.pet.models.Pet;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

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
    Long id;

    String name;

    @JsonProperty("birth_date")
    LocalDate birthDate;

    String gender;

    String species;

    String color;

    @JsonProperty("health_info")
    String healthInfo;

    @JsonProperty("user_id")
    Long userId;

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

