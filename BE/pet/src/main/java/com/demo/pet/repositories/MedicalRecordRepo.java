package com.demo.pet.repositories;

import com.demo.pet.models.MedicalRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository interface for managing {@link MedicalRecord} entities in the Pet Clinic system.
 * <p>
 * Provides CRUD operations and custom queries for medical record data, abstracting database access.
 * </p>
 * <p>
 *     See info about Repository Overview: <a href="../../../../custom-docs/RepoOverview.html" target="_blank">RepoOverview</a>
 * </p>
 * <p>
 *     Annotated with {@link Repository} for Spring component scanning and exception translation.
 * </p>
 *
 * @see com.demo.pet.models.MedicalRecord
 * @see org.springframework.data.jpa.repository.JpaRepository
 * @since 1.0
 */
@Repository
public interface MedicalRecordRepo extends JpaRepository<MedicalRecord, Long> {
    /**
     * Finds all medical records for a specific pet.
     *
     * @param petId the ID of the pet
     * @return list of medical records for the pet
     */
    List<MedicalRecord> findByPetId(Long petId);

    /**
     * Finds all medical records associated with a specific user (doctor or staff).
     *
     * @param userId the ID of the user
     * @return list of medical records for the user
     */
    List<MedicalRecord> findByUserId(Long userId);
}
