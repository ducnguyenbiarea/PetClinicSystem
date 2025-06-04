package com.demo.pet.controllers;

import com.demo.pet.dtos.PetDTO;
import com.demo.pet.services.Impl.PetServiceImpl;
import com.demo.pet.services.PetService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for managing pet-related operations in the Pet Clinic system.
 * <p>
 * Exposes endpoints for CRUD operations and retrieval of pets by user.
 * </p>
 * <p>
 *     See info about Controllers Overview: <a href="../../../../custom-docs/ControllerOverview.html" target="_blank">Controllers Overview</a>
 * </p>
 * <p>
 *     See info about Controller Annotations: <a href="../../../../custom-docs/ControllerAnnotation.html" target="_blank">Controller Annotation</a>
 * </p>
 *
 * @see com.demo.pet.services.PetService
 * @see com.demo.pet.dtos.PetDTO
 * @since 1.0
 */
@RestController
@RequestMapping("/api/pets")
@RequiredArgsConstructor
public class PetController {
    private final PetService petService;

    /**
     * Retrieves all pets in the system.
     * <p>
     *     Only accessible by users with ADMIN or STAFF roles.
     * </p>
     *
     * @return a list of all pets
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @GetMapping("")
    public ResponseEntity<List<PetDTO>> getAllPets() {
        return ResponseEntity.ok(petService.getAllPets());
    }

    /**
     * Retrieves a pet by its ID.
     *
     * @param id the ID of the pet to retrieve
     * @return the pet with the specified ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<PetDTO> getPetById(@PathVariable Long id) {
        return ResponseEntity.ok(petService.getPetById(id));
    }

    /**
     * Retrieves all pets owned by a specific user.
     *
     * @param userId the ID of the user whose pets are to be retrieved
     * @return a list of pets owned by the specified user
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<PetDTO>> getPetsByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(petService.getPetsByUserId(userId));
    }

    /**
     * Adds a new pet to the system.
     * <p>
     *     Only accessible by users with ADMIN or STAFF roles.
     * </p>
     *
     * @param petDTO the data transfer object containing pet details
     * @return the added pet
     */
    @PostMapping("")
    public ResponseEntity<PetDTO> addPet(@RequestBody PetDTO petDTO) {
        return ResponseEntity.ok(petService.addPet(petDTO));
    }

    /**
     * Updates an existing pet's details.
     * <p>
     *     Only accessible by users with ADMIN or STAFF roles.
     * </p>
     *
     * @param id the ID of the pet to update
     * @param petDTO the data transfer object containing updated pet details
     * @return the updated pet
     */
    @PutMapping("/{id}")
    public ResponseEntity<PetDTO> updatePet(@PathVariable Long id, @RequestBody PetDTO petDTO) {
        return ResponseEntity.ok(petService.updatePet(id, petDTO));
    }

    /**
     * Deletes a pet from the system.
     * <p>
     *     Only accessible by users with ADMIN or STAFF roles.
     * </p>
     *
     * @param id the ID of the pet to delete
     * @return the deleted pet
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<PetDTO> deletePet(@PathVariable Long id) {
        return ResponseEntity.ok(petService.deletePet(id));
    }

    /**
     * Retrieves the pets owned by the currently authenticated user.
     *
     * @return a list of pets owned by the current user
     */
    @GetMapping("/my-pets")
    public ResponseEntity<List<PetDTO>> getMyPets() {
        return ResponseEntity.ok(petService.getMyPet());
    }
}
