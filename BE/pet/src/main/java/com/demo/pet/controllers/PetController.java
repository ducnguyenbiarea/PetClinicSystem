package com.demo.pet.controllers;

import com.demo.pet.dtos.PetDTO;
import com.demo.pet.services.Impl.PetServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/pets")
@RequiredArgsConstructor
public class PetController {
    private final PetServiceImpl petServiceImpl;

    @GetMapping
    public List<PetDTO> getAllPets() {
        return petServiceImpl.getAllPets();
    }
}
