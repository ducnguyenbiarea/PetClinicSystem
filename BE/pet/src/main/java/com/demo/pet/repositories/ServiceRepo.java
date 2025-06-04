package com.demo.pet.repositories;

import com.demo.pet.models.Services;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository interface for managing {@link Services} entities in the Pet Clinic system.
 * <p>
 * Provides CRUD operations for service data, abstracting database access.
 * </p>
 * <p>
 *     See info about Repository Overview: <a href="../../../../custom-docs/RepoOverview.html" target="_blank">RepoOverview</a>
 * </p>
 * <p>
 *     Annotated with {@link Repository} for Spring component scanning and exception translation.
 * </p>
 *
 * @see com.demo.pet.models.Services
 * @see org.springframework.data.jpa.repository.JpaRepository
 * @since 1.0
 */
@Repository
public interface ServiceRepo extends JpaRepository<Services, Long> {
    /**
     * Retrieves all available services.
     *
     * @return list of all services
     */
    @Override
    List<Services> findAll();
}
