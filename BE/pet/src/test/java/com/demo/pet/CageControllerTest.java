package com.demo.pet.controllers;

import com.demo.pet.dtos.CageDTO;
import com.demo.pet.models.Cage;
import com.demo.pet.services.CageService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CageControllerTest {

    @Mock
    private CageService cageService;

    @InjectMocks
    private CageController cageController;

    private CageDTO cageDTO;
    private List<CageDTO> cageDTOList;

    @BeforeEach
    void setUp() {
        // Create CageDTO test data
        cageDTO = new CageDTO(
                1L,
                "Dog cage",
                "Medium",
                "AVAILABLE",
                LocalDate.now(),
                LocalDate.now().plusDays(7),
                null
        );

        CageDTO secondCage = new CageDTO(
                2L,
                "Cat cage",
                "Small",
                "OCCUPIED",
                LocalDate.now().minusDays(3),
                LocalDate.now().plusDays(4),
                1L
        );

        cageDTOList = Arrays.asList(cageDTO, secondCage);
    }

    @Test
    void getAllCages_shouldReturnList() {
        when(cageService.getAllCages()).thenReturn(cageDTOList);

        ResponseEntity<List<CageDTO>> response = cageController.getAllCages();

        assertEquals(2, response.getBody().size());
        verify(cageService).getAllCages();
    }

    @Test
    void getCageById_shouldReturnCage() {
        when(cageService.getCageById(1L)).thenReturn(cageDTO);

        ResponseEntity<CageDTO> response = cageController.getCageById(1L);

        assertEquals(cageDTO, response.getBody());
        verify(cageService).getCageById(1L);
    }

    @Test
    void getCageByPetId_shouldReturnCage() {
        when(cageService.getCageByPetId(1L)).thenReturn(cageDTO);

        ResponseEntity<CageDTO> response = cageController.getCageByPetId(1L);

        assertEquals(cageDTO, response.getBody());
        verify(cageService).getCageByPetId(1L);
    }

    @Test
    void addCage_shouldReturnCreatedCage() {
        when(cageService.addCage(cageDTO)).thenReturn(cageDTO);

        ResponseEntity<CageDTO> response = cageController.addCage(cageDTO);

        assertEquals(cageDTO, response.getBody());
        verify(cageService).addCage(cageDTO);
    }

    @Test
    void updateCage_shouldReturnUpdatedCage() {
        when(cageService.updateCage(1L, cageDTO)).thenReturn(cageDTO);

        ResponseEntity<CageDTO> response = cageController.updateCage(1L, cageDTO);

        assertEquals(cageDTO, response.getBody());
        verify(cageService).updateCage(1L, cageDTO);
    }

    @Test
    void deleteCage_shouldReturnDeletedCage() {
        when(cageService.deleteCage(1L)).thenReturn(cageDTO);

        ResponseEntity<CageDTO> response = cageController.deleteCage(1L);

        assertEquals(cageDTO, response.getBody());
        verify(cageService).deleteCage(1L);
    }

    @Test
    void getCagesByStatus_shouldReturnFilteredCages() {
        when(cageService.getCagesByStatus("AVAILABLE")).thenReturn(Arrays.asList(cageDTO));

        ResponseEntity<List<CageDTO>> response = cageController.getCagesByStatus("AVAILABLE");

        assertEquals(1, response.getBody().size());
        assertEquals("AVAILABLE", response.getBody().get(0).getStatus());
        verify(cageService).getCagesByStatus("AVAILABLE");
    }

    @Test
    void getCagesByTypeAndSize_shouldReturnFilteredCages() {
        when(cageService.getCagesByTypeAndSize("Dog cage", "Medium")).thenReturn(Arrays.asList(cageDTO));

        ResponseEntity<List<CageDTO>> response = cageController.getCagesByTypeAndSize("Dog cage", "Medium");

        assertEquals(1, response.getBody().size());
        assertEquals("Dog cage", response.getBody().get(0).getType());
        assertEquals("Medium", response.getBody().get(0).getSize());
        verify(cageService).getCagesByTypeAndSize("Dog cage", "Medium");
    }
}