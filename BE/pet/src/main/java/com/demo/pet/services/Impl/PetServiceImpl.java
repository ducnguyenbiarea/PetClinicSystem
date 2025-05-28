package com.demo.pet.services.Impl;


import com.demo.pet.dtos.PetDTO;
import com.demo.pet.models.Pet;
import com.demo.pet.models.User;
import com.demo.pet.repositories.PetRepo;
import com.demo.pet.repositories.UserRepo;
import com.demo.pet.services.PetService;
import lombok.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PetServiceImpl implements PetService {
    private final PetRepo petRepo;
    private final UserRepo userRepo;

    @Override
    public List<PetDTO> getAllPets() {
        return petRepo.findAll().stream().map(PetDTO::fromEntity).toList();
    }

    @Override
    public PetDTO getPetById(Long id) {
        return PetDTO.fromEntity(petRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Pet not found with id: " + id)));
    }

    @Override
    public List<PetDTO> getPetsByUserId(Long userId) {
        return petRepo.findByUserId(userId).stream().map(PetDTO::fromEntity).toList();
    }

    @Override
    @Transactional
    public PetDTO addPet(PetDTO petDTO) {
        Pet pet = new Pet();
        pet.setName(petDTO.getName());
        pet.setBirthDate(petDTO.getBirthDate());
        pet.setGender(petDTO.getGender() != null ? Pet.Gender.valueOf(petDTO.getGender().toUpperCase()) : null);
        pet.setSpecies(petDTO.getSpecies());
        pet.setColor(petDTO.getColor());
        pet.setHealthInfo(petDTO.getHealthInfo());
        User user = userRepo.findById(petDTO.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with id: " + petDTO.getUserId()));
        pet.setUser(user);

        return PetDTO.fromEntity(petRepo.save(pet));
    }

    @Override
    @Transactional
    public PetDTO updatePet(Long id, PetDTO petDTO) {
        Pet pet = petRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Pet not found with id: " + id));

        // Update pet fields only if they are not null
        if (petDTO.getName() != null) {
            pet.setName(petDTO.getName());
        }else {
            throw new RuntimeException("Pet name cannot be null");
        }

        if (petDTO.getBirthDate() != null) pet.setBirthDate(petDTO.getBirthDate());
        if (petDTO.getGender() != null) pet.setGender(Pet.Gender.valueOf(petDTO.getGender().toUpperCase()));
        if (petDTO.getSpecies() != null) pet.setSpecies(petDTO.getSpecies());
        if (petDTO.getColor() != null) pet.setColor(petDTO.getColor());
        if (petDTO.getHealthInfo() != null) pet.setHealthInfo(petDTO.getHealthInfo());

        // Ensure user ID is not null and fetch the user
        if (petDTO.getUserId() != null) {
            User user = userRepo.findById(petDTO.getUserId())
                    .orElseThrow(() -> new RuntimeException("User not found with id: " + petDTO.getUserId()));
            pet.setUser(user);
        } else {
            throw new RuntimeException("User ID cannot be null");
        }

        return PetDTO.fromEntity(petRepo.save(pet));
    }

    @Override
    @Transactional
    public PetDTO deletePet(Long id) {
        Pet pet = petRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Pet not found with id: " + id));

        // Check if the pet has any associated cage or medical records
        User user = pet.getUser();

        // Check for associated cage
        if (pet.getCage() != null) {
            throw new RuntimeException("Cannot delete pet assigned to a cage.");
        }

        // Check for associated medical records
        if (pet.getMedicalRecordList() != null && !pet.getMedicalRecordList().isEmpty()) {
            throw new RuntimeException("Cannot delete pet with associated medical records.");
        }

        petRepo.delete(pet);
        return PetDTO.fromEntity(pet);
    }

    @Override
    public List<PetDTO> getMyPet() {
        // Get authenticated user's email
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName(); // Email được lưu trong principal

        // Find user ID by email
        var userId = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email))
                .getId();

        // Fetch pets by user ID
        return petRepo.findByUserId(userId).stream()
                .map(PetDTO::fromEntity)
                .toList();
    }
}
