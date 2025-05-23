package com.demo.pet.dtos;

import com.demo.pet.models.Pet;
import lombok.*;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PetDTO {
    private String name;
    private LocalDate birthDate;
    private String gender;
    private String species;
    private String color;
    private String image;
    private String healthInfo;

}

