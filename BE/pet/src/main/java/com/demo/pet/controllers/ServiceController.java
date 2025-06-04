package com.demo.pet.controllers;

import com.demo.pet.dtos.ServicesDTO;
import com.demo.pet.services.ServicesService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * REST controller for managing service-related operations in the Pet Clinic system.
 * <p>
 * Exposes endpoints for CRUD operations and retrieval of available services.
 * </p>
 * <p>
 *     See info about Controllers Overview: <a href="../../../../custom-docs/ControllerOverview.html" target="_blank">Controllers Overview</a>
 * </p>
 * <p>
 *     See info about Controller Annotations: <a href="../../../../custom-docs/ControllerAnnotation.html" target="_blank">Controller Annotation</a>
 * </p>
 *
 * @see com.demo.pet.services.ServicesService
 * @see com.demo.pet.dtos.ServicesDTO
 * @since 1.0
 */
@RestController
@RequestMapping("/api/services")
@RequiredArgsConstructor
public class ServiceController {
    private final ServicesService servicesService;

    /**
     * Retrieves all available services.
     *
     * @return a list of all services in the system.
     */
    @GetMapping("")
    public ResponseEntity<List<ServicesDTO>> getAllServices() {
        return ResponseEntity.ok(servicesService.getAllServices());
    }

    /**
     * Retrieves a specific service by its ID.
     *
     * @param id the ID of the service to retrieve.
     * @return the service with the specified ID.
     */
    @GetMapping("/{id}")
    public ResponseEntity<ServicesDTO> getServiceById(@PathVariable Long id) {
        return ResponseEntity.ok(servicesService.getServicesById(id));
    }

    /**
     * Adds a new service.
     * <p>
     * Accessible to users with ADMIN role.
     * </p>
     *
     * @param servicesDTO The ServicesDTO object.
     * @return The created ServicesDTO object.
     */
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("")
    public ResponseEntity<ServicesDTO> addService(@RequestBody ServicesDTO servicesDTO) {
        return ResponseEntity.ok(servicesService.addServices(servicesDTO));
    }

    /**
     * Updates an existing service.
     * <p>
     * Accessible to users with ADMIN role.
     * </p>
     *
     * @param id          The ID of the service to update.
     * @param servicesDTO The updated ServicesDTO object.
     * @return The updated ServicesDTO object.
     */
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<ServicesDTO> updateService(
            @PathVariable Long id,
            @RequestBody ServicesDTO servicesDTO) {
        return ResponseEntity.ok(servicesService.updateServices(id, servicesDTO));
    }

    /**
     * Deletes a service by its ID.
     * <p>
     * Accessible to users with ADMIN role.
     * </p>
     *
     * @param id The ID of the service to delete.
     * @return The deleted ServicesDTO object.
     */
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<ServicesDTO> deleteService(@PathVariable Long id) {
        return ResponseEntity.ok(servicesService.deleteServices(id));
    }
}
