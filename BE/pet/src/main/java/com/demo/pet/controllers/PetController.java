package com.demo.pet.controllers;

import com.demo.pet.dtos.PetDTO;
import com.demo.pet.services.Impl.PetServiceImpl;
import com.demo.pet.services.PetService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pets")
@RequiredArgsConstructor
public class PetController {
    private final PetService petService;

    @GetMapping("")
    public ResponseEntity<List<PetDTO>> getAllPets() {
        return ResponseEntity.ok(petService.getAllPets());
    }

    @GetMapping("/{id}")
    public ResponseEntity<PetDTO> getPetById(@PathVariable Long id) {
        return ResponseEntity.ok(petService.getPetById(id));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<PetDTO>> getPetsByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(petService.getPetsByUserId(userId));
    }

    @PostMapping("")
    public ResponseEntity<PetDTO> addPet(@RequestBody PetDTO petDTO) {
        return ResponseEntity.ok(petService.addPet(petDTO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PetDTO> updatePet(@PathVariable Long id, @RequestBody PetDTO petDTO) {
        return ResponseEntity.ok(petService.updatePet(id, petDTO));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<PetDTO> deletePet(@PathVariable Long id) {
        return ResponseEntity.ok(petService.deletePet(id));
    }

    @GetMapping("/my-pets")
    public ResponseEntity<List<PetDTO>> getMyPets() {
        return ResponseEntity.ok(petService.getMyPet());
    }
}
