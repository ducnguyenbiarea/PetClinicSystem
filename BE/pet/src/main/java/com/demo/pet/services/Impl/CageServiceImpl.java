package com.demo.pet.services.Impl;

import com.demo.pet.dtos.CageDTO;
import com.demo.pet.models.Cage;
import com.demo.pet.models.Pet;
import com.demo.pet.repositories.CageRepo;
import com.demo.pet.repositories.PetRepo;
import com.demo.pet.services.CageService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CageServiceImpl implements CageService {
    private final CageRepo cageRepo;
    private final PetRepo petRepo;

    @Override
    public List<CageDTO> getAllCages() {
        return cageRepo.findAll().stream().map(CageDTO::fromEntity).toList();
    }

    @Override
    public CageDTO getCageById(Long id) {
        return CageDTO.fromEntity(
                cageRepo.findById(id)
                        .orElseThrow(() -> new EntityNotFoundException("Cage not found with id: " + id))
        );
    }

    @Override
    @Transactional
    public CageDTO addCage(CageDTO dto) {
        if (dto.getType() == null || dto.getType().isBlank())
            throw new IllegalArgumentException("Cage type cannot be null or blank");
        if (dto.getSize() == null || dto.getSize().isBlank())
            throw new IllegalArgumentException("Cage size cannot be null or blank");

        Cage cage = new Cage();
        cage.setType(dto.getType());
        cage.setSize(dto.getSize());
        cage.setStatus(dto.getPetId() != null ? Cage.Status.OCCUPIED : Cage.Status.AVAILABLE); // Default status
        cage.setStartDate(dto.getStartDate() != null ? dto.getStartDate() : null);
        cage.setEndDate(dto.getEndDate() != null ? dto.getEndDate() : null);

        if (dto.getPetId() != null) {
            Pet pet = petRepo.findById(dto.getPetId())
                    .orElseThrow(() -> new EntityNotFoundException("Pet not found with id: " + dto.getPetId()));
            cage.setPet(pet);
        } else {
            cage.setPet(null);
        }

        return CageDTO.fromEntity(cageRepo.save(cage));
    }

    @Override
    @Transactional
    public CageDTO updateCage(Long id, CageDTO dto) {
        Cage cage = cageRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Cage not found with id: " + id));

        if (dto.getType() != null && !dto.getType().isBlank()) cage.setType(dto.getType());
        if (dto.getSize() != null && !dto.getSize().isBlank()) cage.setSize(dto.getSize());
        cage.setStatus(Cage.Status.valueOf(dto.getStatus().toUpperCase()));
        cage.setStartDate(dto.getStartDate() != null ? dto.getStartDate() : null);
        cage.setEndDate(dto.getEndDate() != null ? dto.getEndDate() : null);

        if (dto.getPetId() != null) {
            Pet pet = petRepo.findById(dto.getPetId())
                    .orElseThrow(() -> new EntityNotFoundException("Pet not found with id: " + dto.getPetId()));
            cage.setPet(pet);
        } else{
            cage.setPet(null);
        }

        return CageDTO.fromEntity(cageRepo.save(cage));
    }

    @Override
    @Transactional
    public CageDTO deleteCage(Long id) {
        Cage cage = cageRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Cage not found with id: " + id));

        // Check if the cage is assigned to a pet
        if (cage.getPet() != null) {
            throw new IllegalArgumentException("Cannot delete cage assigned to a pet.");
        }

        cageRepo.delete(cage);
        return CageDTO.fromEntity(cage);
    }

    @Override
    public CageDTO getCageByPetId(Long petId) {
        return CageDTO.fromEntity(cageRepo.findByPetId(petId)
                        .orElseThrow(() -> new EntityNotFoundException("Cage not found for pet id: " + petId)));
    }

    @Override
    public List<CageDTO> getCagesByStatus(String status) {
        Cage.Status cageStatus;

        if (status == null || status.isBlank()) {
            throw new IllegalArgumentException("Cage status cannot be null or blank");
        }

        try {
            cageStatus = Cage.Status.valueOf(status.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid cage status: " + status);
        }

        // Filter cages by status
        return cageRepo.findAll().stream()
                .filter(cage -> cage.getStatus() == cageStatus)
                .map(CageDTO::fromEntity)
                .toList();
    }

    @Override
    public List<CageDTO> getCagesByTypeAndSize(String type, String size) {
        if (type == null || type.isBlank()) {
            throw new IllegalArgumentException("Cage type cannot be null or blank");
        }
        if (size == null || size.isBlank()) {
            throw new IllegalArgumentException("Cage size cannot be null or blank");
        }

        return cageRepo.findAll().stream()
                .filter(cage -> cage.getType().equalsIgnoreCase(type) && cage.getSize().equalsIgnoreCase(size))
                .map(CageDTO::fromEntity)
                .toList();
    }
}
