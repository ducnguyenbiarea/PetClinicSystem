package com.demo.pet.services;

import com.demo.pet.dtos.PetDTO;
import com.demo.pet.models.Pet;

import java.util.List;

public interface PetService {
    List<PetDTO> getAllPets();

    PetDTO getPetById(Long id);

    List<PetDTO> getPetsByUserId(Long userId);

    PetDTO addPet(PetDTO petDTO);

    PetDTO updatePet(Long id, PetDTO petDTO);

    PetDTO deletePet(Long id);

    List<PetDTO> getMyPet();
}
