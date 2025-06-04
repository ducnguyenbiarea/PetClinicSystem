package com.demo.pet.services;

import com.demo.pet.dtos.CageDTO;

import java.util.List;

/**
 * Service interface for managing cage-related business logic in the Pet Clinic system.
 * <p>
 * Provides methods for CRUD operations, assignment to pets, and filtering by status, type, or size.
 * </p>
 * <p>
 *     See more in: <a href="../../../../custom-docs/ServiceOverview.html" target="_blank">ServiceOverview</a>
 * </p>
 *
 * @see com.demo.pet.dtos.CageDTO
 * @since 1.0
 */
public interface CageService {
    /**
     * Retrieves all cages.
     *
     * @return List of all CageDTOs.
     */
    List<CageDTO> getAllCages();

    /**
     * Retrieves a cage by its ID.
     *
     * @param id The ID of the cage to retrieve.
     * @return CageDTO representing the cage with the specified ID.
     */
    CageDTO getCageById(Long id);

    /**
     * Adds a new cage.
     *
     * @param dto The cage data to add.
     * @return The added CageDTO.
     */
    CageDTO addCage(CageDTO dto);

    /**
     * Updates an existing cage by its ID.
     *
     * @param id  The ID of the cage to update.
     * @param dto The updated cage data.
     * @return Updated CageDTO.
     */
    CageDTO updateCage(Long id, CageDTO dto);

    /**
     * Deletes a cage by its ID.
     *
     * @param id The ID of the cage to delete.
     * @return Deleted CageDTO.
     */
    CageDTO deleteCage(Long id);

    /**
     * Assigns a cage to a pet by the pet's ID.
     *
     * @param petId The ID of the pet to assign the cage to.
     * @return Updated CageDTO with the assigned pet.
     */
    CageDTO getCageByPetId(Long petId);

    /**
     * Retrieves cages by their status.
     *
     * @param status The status to filter cages by.
     * @return List of CageDTOs with the specified status.
     */
    List<CageDTO> getCagesByStatus(String status);

    /**
     * Retrieves cages by their type and size.
     *
     * @param type The type of the cage to filter by.
     * @param size The size of the cage to filter by.
     * @return List of CageDTOs matching the specified type and size.
     */
    List<CageDTO> getCagesByTypeAndSize(String type, String size);
}
