package com.demo.pet.services;

import com.demo.pet.dtos.MedicalRecordDTO;

import java.util.List;

/**
 * Service interface for managing medical record business logic in the Pet Clinic system.
 * <p>
 * Provides methods for CRUD operations and retrieval by pet or user.
 * </p>
 * <p>
 *     See more in: <a href="../../../../custom-docs/ServiceOverview.html" target="_blank">ServiceOverview</a>
 * </p>
 *
 * @see com.demo.pet.dtos.MedicalRecordDTO
 * @since 1.0
 */
public interface MedicalRecordService {
    /**
     * Retrieves all medical records.
     *
     * @return List of all MedicalRecordDTOs.
     */
    List<MedicalRecordDTO> getAllRecords();

    /**
     * Retrieves a medical record by its ID.
     *
     * @param id The ID of the medical record to retrieve.
     * @return MedicalRecordDTO representing the record with the specified ID.
     */
    MedicalRecordDTO getRecordById(Long id);

    /**
     * Retrieves all medical records for a specific pet.
     *
     * @param petId The ID of the pet to get records for.
     * @return List of MedicalRecordDTOs representing the pet's medical records.
     */
    List<MedicalRecordDTO> getRecordsByPetId(Long petId);

    /**
     * Retrieves all medical records for a specific user.
     *
     * @param userId The ID of the user to get records for.
     * @return List of MedicalRecordDTOs representing the user's medical records.
     */
    List<MedicalRecordDTO> getRecordsByUserId(Long userId);

    /**
     * Adds a new medical record.
     *
     * @param dto The medical record data to add.
     * @return The added MedicalRecordDTO.
     */
    MedicalRecordDTO addRecord(MedicalRecordDTO dto);

    /**
     * Updates an existing medical record by its ID.
     *
     * @param id  The ID of the medical record to update.
     * @param dto The updated medical record data.
     * @return Updated MedicalRecordDTO.
     */
    MedicalRecordDTO updateRecord(Long id, MedicalRecordDTO dto);

    /**
     * Deletes a medical record by its ID.
     *
     * @param id The ID of the medical record to delete.
     * @return The deleted MedicalRecordDTO.
     */
    // only admin and doctor can delete record
    MedicalRecordDTO deleteRecord(Long id);

    /**
     * Retrieves the currently logged-in user's medical records.
     *
     * @return List of MedicalRecordDTOs representing the user's medical records.
     */
    // ham phu tro getMyRecords
    List<MedicalRecordDTO> getMyRecords();
}