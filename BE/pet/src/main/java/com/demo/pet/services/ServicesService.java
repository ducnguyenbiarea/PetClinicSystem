package com.demo.pet.services;

import com.demo.pet.dtos.ServicesDTO;
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
public interface ServicesService {
    /**
     * Retrieves all services.
     *
     * @return List of all ServicesDTOs.
     */
    List<ServicesDTO> getAllServices();

    /**
     * Retrieves a service by its ID.
     *
     * @param id The ID of the service to retrieve.
     * @return ServicesDTO representing the service with the specified ID.
     */
    ServicesDTO getServicesById(Long id);

    /**
     * Adds a new service.
     *
     * @param servicesDTO The service data to add.
     * @return The added ServicesDTO.
     */
    ServicesDTO addServices(ServicesDTO servicesDTO);

    /**
     * Updates an existing service by its ID.
     *
     * @param id The ID of the service to update.
     * @param servicesDTO The updated service data.
     * @return Updated ServicesDTO.
     */
    ServicesDTO updateServices(Long id, ServicesDTO servicesDTO);

    /**
     * Deletes a service by its ID.
     *
     * @param id The ID of the service to delete.
     * @return Deleted ServicesDTO.
     */
    ServicesDTO deleteServices(Long id);
}
