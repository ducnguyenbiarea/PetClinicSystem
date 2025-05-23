package com.demo.pet.services;

import com.demo.pet.dtos.PetDTO;
import com.demo.pet.models.Pet;

import java.util.List;

public interface PetService {
    public List<PetDTO> getAllPets();

    public PetDTO mapToDTO(Pet pet);
}
