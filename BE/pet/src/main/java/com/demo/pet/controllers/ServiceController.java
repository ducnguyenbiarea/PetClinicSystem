package com.demo.pet.controllers;

import com.demo.pet.dtos.ServicesDTO;
import com.demo.pet.services.ServicesService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/services")
@RequiredArgsConstructor
public class ServiceController {
    private final ServicesService servicesService;

    @GetMapping("")
    public ResponseEntity<List<ServicesDTO>> getAllServices() {
        return ResponseEntity.ok(servicesService.getAllServices());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ServicesDTO> getServiceById(@PathVariable Long id) {
        return ResponseEntity.ok(servicesService.getServicesById(id));
    }


    @PostMapping("")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ServicesDTO> addService(@RequestBody ServicesDTO servicesDTO) {
        return ResponseEntity.ok(servicesService.addServices(servicesDTO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ServicesDTO> updateService(
            @PathVariable Long id,
            @RequestBody ServicesDTO servicesDTO) {
        return ResponseEntity.ok(servicesService.updateServices(id, servicesDTO));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ServicesDTO> deleteService(@PathVariable Long id) {
        return ResponseEntity.ok(servicesService.deleteServices(id));
    }
}
