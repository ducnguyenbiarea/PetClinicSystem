package com.demo.pet.dtos;

import com.demo.pet.models.Cage;
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
        "type",
        "size",
        "status",
        "start_date",
        "end_date",
        "pet_id"
})
public class CageDTO {
    Long id;

    String type;

    String size;

    String status;

    @JsonProperty("start_date")
    LocalDate startDate;

    @JsonProperty("end_date")
    LocalDate endDate;

    @JsonProperty("pet_id")
    Long petId;

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