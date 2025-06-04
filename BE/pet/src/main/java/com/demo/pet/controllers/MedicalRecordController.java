package com.demo.pet.controllers;

import com.demo.pet.dtos.MedicalRecordDTO;
import com.demo.pet.services.MedicalRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for managing medical record operations in the Pet Clinic system.
 * <p>
 * Exposes endpoints for CRUD operations and retrieval of records by pet or user.
 * </p>
 * <p>
 *     See info about Controllers Overview: <a href="../../../../custom-docs/ControllerOverview.html" target="_blank">Controllers Overview</a>
 * </p>
 * <p>
 *     See info about Controller Annotations: <a href="../../../../custom-docs/ControllerAnnotation.html" target="_blank">Controller Annotation</a>
 * </p>
 *
 * @see com.demo.pet.services.MedicalRecordService
 * @see com.demo.pet.dtos.MedicalRecordDTO
 * @since 1.0
 */
@RestController
@RequestMapping("/api/records")
@RequiredArgsConstructor
public class MedicalRecordController {
    private final MedicalRecordService recordService;

    /**
     * Retrieves all medical records.
     * <p>
     *     Accessible by ADMIN, DOCTOR, and STAFF roles.
     * </p>
     *
     * @return List of all medical records
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('DOCTOR') or hasRole('STAFF')")
    @GetMapping("")
    public ResponseEntity<List<MedicalRecordDTO>> getAllRecords() {
        return ResponseEntity.ok(recordService.getAllRecords());
    }

    /**
     * Retrieves a medical record by ID.
     *
     * @param id The record ID.
     * @return The MedicalRecordDTO object.
     */
    @GetMapping("/{id}")
    public ResponseEntity<MedicalRecordDTO> getRecordById(@PathVariable Long id) {
        return ResponseEntity.ok(recordService.getRecordById(id));
    }

    /**
     * Retrieves medical records by pet ID.
     *
     * @param petId The pet ID.
     * @return List of MedicalRecordDTO objects associated with the pet.
     */
    @GetMapping("/pet/{petId}")
    public ResponseEntity<List<MedicalRecordDTO>> getRecordsByPetId(@PathVariable Long petId) {
        return ResponseEntity.ok(recordService.getRecordsByPetId(petId));
    }

    /**
     * Retrieves all medical records for a specific user.
     *
     * @param userId The user ID.
     * @return A list of MedicalRecordDTO objects.
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<MedicalRecordDTO>> getRecordsByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(recordService.getRecordsByUserId(userId));
    }

    /**
     * Adds a new medical record.
     * <p>
     * Accessible to users with ADMIN or DOCTOR roles.
     * </p>
     *
     * @param dto The MedicalRecordDTO object.
     * @return The created MedicalRecordDTO object.
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('DOCTOR')")
    @PostMapping("")
    public ResponseEntity<MedicalRecordDTO> addRecord(@RequestBody MedicalRecordDTO dto) {
        return ResponseEntity.ok(recordService.addRecord(dto));
    }

/**
     * Updates an existing medical record.
     * <p>
     * Accessible to users with ADMIN or DOCTOR roles.
     * </p>
     *
     * @param id  The record ID.
     * @param dto The MedicalRecordDTO object with updated data.
     * @return The updated MedicalRecordDTO object.
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('DOCTOR')")
    @PutMapping("/{id}")
    public ResponseEntity<MedicalRecordDTO> updateRecord(@PathVariable Long id, @RequestBody MedicalRecordDTO dto) {
        return ResponseEntity.ok(recordService.updateRecord(id, dto));
    }

/**
     * Deletes a medical record by ID.
     * <p>
     * Accessible to users with ADMIN or DOCTOR roles.
     * </p>
     *
     * @param id The record ID.
     * @return The deleted MedicalRecordDTO object.
     */
    // Only admin and doctor can delete record
    @PreAuthorize("hasRole('ADMIN') or hasRole('DOCTOR')")
    @DeleteMapping("/{id}")
    public ResponseEntity<MedicalRecordDTO> deleteRecord(@PathVariable Long id) {
        return ResponseEntity.ok(recordService.deleteRecord(id));
    }

    /**
     * Retrieves the medical records of the currently authenticated user.
     * <p>
     * Accessible to all authenticated users.
     * </p>
     *
     * @return List of MedicalRecordDTO objects for the current user.
     */
    @GetMapping("/my-records")
    public ResponseEntity<List<MedicalRecordDTO>> getMyRecords() {
        return ResponseEntity.ok(recordService.getMyRecords());
    }
}
