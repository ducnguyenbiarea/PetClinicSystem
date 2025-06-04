package com.demo.pet.repositories;

import com.demo.pet.models.Cage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repository interface for managing {@link Cage} entities in the Pet Clinic system.
 * <p>
 * Provides CRUD operations and custom queries for cage data, abstracting database access.
 * </p>
 * <p>
 *     See info about Repository Overview: <a href="../../../../custom-docs/RepoOverview.html" target="_blank">RepoOverview</a>
 * </p>
 * <p>
 *     Annotated with {@link Repository} for Spring component scanning and exception translation.
 * </p>
 *
 * @see com.demo.pet.models.Cage
 * @see org.springframework.data.jpa.repository.JpaRepository
 * @since 1.0
 */
@Repository
public interface CageRepo extends JpaRepository<Cage, Long> {

    /**
     * Finds a cage assigned to a specific pet.
     *
     * @param petId the ID of the pet
     * @return an {@link Optional} containing the cage if found, or empty if not
     */
    Optional<Cage> findByPetId(Long petId);
}
