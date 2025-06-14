package com.demo.pet.controllers;

import com.demo.pet.dtos.CageDTO;
import com.demo.pet.services.CageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cages")
@RequiredArgsConstructor
public class CageController {
    private final CageService cageService;

    @GetMapping("")
    public ResponseEntity<List<CageDTO>> getAllCages() {
        return ResponseEntity.ok(cageService.getAllCages());
    }

    @GetMapping("/{id}")
    public ResponseEntity<CageDTO> getCageById(@PathVariable Long id) {
        return ResponseEntity.ok(cageService.getCageById(id));
    }

    @GetMapping("/pet/{petId}")
    public ResponseEntity<CageDTO> getCageByPetId(@PathVariable Long petId) {
        return ResponseEntity.ok(cageService.getCageByPetId(petId));
    }

    @PostMapping("")
    public ResponseEntity<CageDTO> addCage(@RequestBody CageDTO dto) {
        return ResponseEntity.ok(cageService.addCage(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<CageDTO> updateCage(@PathVariable Long id, @RequestBody CageDTO dto) {
        return ResponseEntity.ok(cageService.updateCage(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<CageDTO> deleteCage(@PathVariable Long id) {
        return ResponseEntity.ok(cageService.deleteCage(id));
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<CageDTO>> getCagesByStatus(@PathVariable String status) {
        return ResponseEntity.ok(cageService.getCagesByStatus(status));
    }

    @GetMapping("/filter")
    public ResponseEntity<List<CageDTO>> getCagesByTypeAndSize(
            @RequestParam String type,
            @RequestParam String size) {
        return ResponseEntity.ok(cageService.getCagesByTypeAndSize(type, size));
    }
}
