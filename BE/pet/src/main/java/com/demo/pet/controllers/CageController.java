package com.demo.pet.controllers;

import com.demo.pet.dtos.CageDTO;
import com.demo.pet.services.CageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for managing cage-related operations in the Pet Clinic system.
 * <p>
 * Exposes endpoints for CRUD operations on cages, as well as filtering and lookup by status, type, size, or pet.
 * <br>
 * Security is enforced via method-level annotations to restrict sensitive actions to authorized roles.
 * </p>
 * <p>
 *     See info about Controllers Overview: <a href="../../../../custom-docs/ControllerOverview.html" target="_blank">Controllers Overview</a>
 * </p>
 * <p>
 *     See info about Controller Annotations: <a href="../../../../custom-docs/ControllerAnnotation.html" target="_blank">Controller Annotation</a>
 * </p>
 *
 * @see com.demo.pet.services.CageService
 * @see com.demo.pet.dtos.CageDTO
 * @since 1.0
 */
@RestController
@RequestMapping("/api/cages")
@RequiredArgsConstructor
public class CageController {
    private final CageService cageService;

    /**
     * Retrieves a list of all cages.
     * <p>
     * This endpoint is accessible to users with ADMIN or STAFF roles.
     * </p>
     *
     * @return A ResponseEntity containing a list of CageDTO objects.
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @GetMapping("")
    public ResponseEntity<List<CageDTO>> getAllCages() {
        return ResponseEntity.ok(cageService.getAllCages());
    }

    /**
     * Retrieves a cage by its ID.
     * <p>
     * This endpoint is accessible to all users.
     * </p>
     *
     * @param id The ID of the cage to retrieve.
     * @return A ResponseEntity containing the CageDTO object.
     */
    @GetMapping("/{id}")
    public ResponseEntity<CageDTO> getCageById(@PathVariable Long id) {
        return ResponseEntity.ok(cageService.getCageById(id));
    }

    /**
     * Retrieves a cage by the ID of the pet it contains.
     * <p>
     * This endpoint is accessible to all users.
     * </p>
     *
     * @param petId The ID of the pet whose cage is to be retrieved.
     * @return A ResponseEntity containing the CageDTO object.
     */
    @GetMapping("/pet/{petId}")
    public ResponseEntity<CageDTO> getCageByPetId(@PathVariable Long petId) {
        return ResponseEntity.ok(cageService.getCageByPetId(petId));
    }

    /**
     * Adds a new cage.
     * <p>
     * This endpoint is accessible to users with ADMIN or STAFF roles.
     * </p>
     *
     * @param dto The CageDTO object containing the details of the cage to be added.
     * @return A ResponseEntity containing the added CageDTO object.
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @PostMapping("")
    public ResponseEntity<CageDTO> addCage(@RequestBody CageDTO dto) {
        return ResponseEntity.ok(cageService.addCage(dto));
    }

    /**
     * Updates an existing cage.
     * <p>
     * This endpoint is accessible to users with ADMIN or STAFF roles.
     * </p>
     *
     * @param id  The ID of the cage to be updated.
     * @param dto The CageDTO object containing the updated details of the cage.
     * @return A ResponseEntity containing the updated CageDTO object.
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @PutMapping("/{id}")
    public ResponseEntity<CageDTO> updateCage(@PathVariable Long id, @RequestBody CageDTO dto) {
        return ResponseEntity.ok(cageService.updateCage(id, dto));
    }

    /**
     * Deletes a cage by its ID.
     * <p>
     * This endpoint is accessible to users with ADMIN or STAFF roles.
     * </p>
     *
     * @param id The ID of the cage to be deleted.
     * @return A ResponseEntity containing the deleted CageDTO object.
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @DeleteMapping("/{id}")
    public ResponseEntity<CageDTO> deleteCage(@PathVariable Long id) {
        return ResponseEntity.ok(cageService.deleteCage(id));
    }

    /**
     * Retrieves a list of cages by their status.
     * <p>
     * This endpoint is accessible to users with ADMIN or STAFF roles.
     * </p>
     *
     * @param status The status of the cages to retrieve.
     * @return A ResponseEntity containing a list of CageDTO objects.
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @GetMapping("/status/{status}")
    public ResponseEntity<List<CageDTO>> getCagesByStatus(@PathVariable String status) {
        return ResponseEntity.ok(cageService.getCagesByStatus(status));
    }

    /**
     * Retrieves a list of cages by their type and size.
     * <p>
     * This endpoint is accessible to users with ADMIN or STAFF roles.
     * </p>
     *
     * @param type The type of the cages to retrieve.
     * @param size The size of the cages to retrieve.
     * @return A ResponseEntity containing a list of CageDTO objects.
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @GetMapping("/filter")
    public ResponseEntity<List<CageDTO>> getCagesByTypeAndSize(
            @RequestParam String type,
            @RequestParam String size) {
        return ResponseEntity.ok(cageService.getCagesByTypeAndSize(type, size));
    }
}
