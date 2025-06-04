package com.demo.pet.repositories;

import com.demo.pet.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repository interface for managing {@link User} entities in the Pet Clinic system.
 * <p>
 * Provides CRUD operations and custom queries for user data, abstracting database access.
 * </p>
 * <p>
 *     See info about Repository Overview: <a href="../../../../custom-docs/RepoOverview.html" target="_blank">RepoOverview</a>
 * </p>
 * <p>
 *     Annotated with {@link Repository} for Spring component scanning and exception translation.
 * </p>
 *
 * @see com.demo.pet.models.User
 * @see org.springframework.data.jpa.repository.JpaRepository
 * @since 1.0
 */
@Repository
public interface UserRepo extends JpaRepository<User, Long> {
    /**
     * Finds a user by their email address.
     *
     * @param email the user's email
     * @return an {@link Optional} containing the user if found, or empty if not
     */
    Optional<User> findByEmail(String email);

    /**
     * Finds a user by their phone number.
     *
     * @param phone the user's phone number
     * @return an {@link Optional} containing the user if found, or empty if not
     */
    Optional<User> findByPhone(String phone);

    /**
     * Checks if a user exists with the given email.
     *
     * @param email the email to check
     * @return true if a user exists with the email, false otherwise
     */
    boolean existsByEmail(String email);

    /**
     * Checks if a user exists with the given phone number.
     *
     * @param phone the phone number to check
     * @return true if a user exists with the phone, false otherwise
     */
    boolean existsByPhone(String phone);
}