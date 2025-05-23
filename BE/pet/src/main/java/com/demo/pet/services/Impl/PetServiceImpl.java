package com.demo.pet.services.Impl;


import com.demo.pet.dtos.PetDTO;
import com.demo.pet.models.Pet;
import com.demo.pet.repositories.PetRepo;
import com.demo.pet.services.PetService;
import lombok.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PetServiceImpl implements PetService {

    @Autowired
    private final PetRepo petRepo;

    @Override
    public List<PetDTO> getAllPets() {
        return petRepo.findAll().stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public PetDTO mapToDTO(Pet pet) {
        return PetDTO.builder()
                .name(pet.getName())
                .birthDate(pet.getBirthDate())
                .gender(pet.getGender().name())
                .species(pet.getSpecies())
                .color(pet.getColor())
                .image(pet.getImage())
                .healthInfo(pet.getHealthInfo())
                .build();
    }
}
