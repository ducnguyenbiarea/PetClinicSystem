package com.demo.pet.controllers;

import com.demo.pet.dtos.MedicalRecordDTO;
import com.demo.pet.services.MedicalRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/records")
@RequiredArgsConstructor
public class MedicalRecordController {
    private final MedicalRecordService recordService;

    @GetMapping("")
    public ResponseEntity<List<MedicalRecordDTO>> getAllRecords() {
        return ResponseEntity.ok(recordService.getAllRecords());
    }

    @GetMapping("/{id}")
    public ResponseEntity<MedicalRecordDTO> getRecordById(@PathVariable Long id) {
        return ResponseEntity.ok(recordService.getRecordById(id));
    }

    @GetMapping("/pet/{petId}")
    public ResponseEntity<List<MedicalRecordDTO>> getRecordsByPetId(@PathVariable Long petId) {
        return ResponseEntity.ok(recordService.getRecordsByPetId(petId));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<MedicalRecordDTO>> getRecordsByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(recordService.getRecordsByUserId(userId));
    }

    @PostMapping("")
    public ResponseEntity<MedicalRecordDTO> addRecord(@RequestBody MedicalRecordDTO dto) {
        return ResponseEntity.ok(recordService.addRecord(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<MedicalRecordDTO> updateRecord(@PathVariable Long id, @RequestBody MedicalRecordDTO dto) {
        return ResponseEntity.ok(recordService.updateRecord(id, dto));
    }

    // Only admin and doctor can delete record
    @DeleteMapping("/{id}")
    public ResponseEntity<MedicalRecordDTO> deleteRecord(@PathVariable Long id) {
        return ResponseEntity.ok(recordService.deleteRecord(id));
    }

    @GetMapping("/my-records")
    public ResponseEntity<List<MedicalRecordDTO>> getMyRecords() {
        return ResponseEntity.ok(recordService.getMyRecords());
    }
}
