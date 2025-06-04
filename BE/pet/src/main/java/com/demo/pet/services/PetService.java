package com.demo.pet.services;

import com.demo.pet.dtos.PetDTO;
import com.demo.pet.models.Pet;

import java.util.List;

/**
 * Service interface for managing pet-related business logic in the Pet Clinic system.
 * <p>
 * Provides methods for CRUD operations and retrieval of pets by user.
 * </p>
 * <p>
 *     See more in: <a href="../../../../custom-docs/ServiceOverview.html" target="_blank">ServiceOverview</a>
 * </p>
 *
 * @see com.demo.pet.dtos.PetDTO
 * @since 1.0
 */
public interface PetService {
    /**
     * Retrieves all pets.
     *
     * @return List of all PetDTOs.
     */
    List<PetDTO> getAllPets();

    /**
     * Retrieves a pet by its ID.
     *
     * @param id The ID of the pet to retrieve.
     * @return PetDTO representing the pet with the specified ID.
     */
    PetDTO getPetById(Long id);

    /**
     * Retrieves all pets owned by a specific user.
     *
     * @param userId The ID of the user to get pets for.
     * @return List of PetDTOs representing the user's pets.
     */
    List<PetDTO> getPetsByUserId(Long userId);

    /**
     * Adds a new pet.
     *
     * @param petDTO The pet data to add.
     * @return The added PetDTO.
     */
    PetDTO addPet(PetDTO petDTO);

    /**
     * Updates an existing pet by its ID.
     *
     * @param id     The ID of the pet to update.
     * @param petDTO The updated pet data.
     * @return Updated PetDTO.
     */
    PetDTO updatePet(Long id, PetDTO petDTO);

    /**
     * Deletes a pet by its ID.
     *
     * @param id The ID of the pet to delete.
     * @return The deleted PetDTO.
     */
    PetDTO deletePet(Long id);

    /**
     * Retrieves the currently logged-in user's pets.
     *
     * @return List of PetDTOs representing the user's pets.
     */
    List<PetDTO> getMyPet();
}
