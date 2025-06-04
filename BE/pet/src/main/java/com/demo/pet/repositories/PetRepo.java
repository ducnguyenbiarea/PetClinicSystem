package com.demo.pet.repositories;

import com.demo.pet.models.Pet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository interface for managing {@link Pet} entities in the Pet Clinic system.
 * <p>
 * Provides CRUD operations and custom queries for pet data, abstracting database access.
 * </p>
 * <p>
 *     See info about Repository Overview: <a href="../../../../custom-docs/RepoOverview.html" target="_blank">RepoOverview</a>
 * </p>
 * <p>
 *     Annotated with {@link Repository} for Spring component scanning and exception translation.
 * </p>
 *
 * @see com.demo.pet.models.Pet
 * @see org.springframework.data.jpa.repository.JpaRepository
 * @since 1.0
 */
@Repository
public interface PetRepo extends JpaRepository<Pet, Long> {

    /**
     * Finds all pets owned by a specific user.
     *
     * @param userId the ID of the user (owner)
     * @return list of pets belonging to the user
     */
    List<Pet> findByUserId(Long userId);
}
