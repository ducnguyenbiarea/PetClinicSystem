package com.demo.pet;

import com.demo.pet.dtos.PetDTO;
import com.demo.pet.services.PetService;
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
class PetControllerTest {

    @Mock
    private PetService petService;

    @InjectMocks
    private PetController petController;

    private PetDTO petDTO;
    private List<PetDTO> petDTOList;

    @BeforeEach
    void setUp() {
        // Create PetDTO test data
        petDTO = new PetDTO(
                1L,
                "Buddy",
                LocalDate.of(2020, 5, 15),
                "MALE",
                "Dog",
                "Brown",
                "Healthy",
                1L
        );

        PetDTO secondPet = new PetDTO(
                2L,
                "Whiskers",
                LocalDate.of(2019, 3, 10),
                "FEMALE",
                "Cat",
                "White",
                "Regular checkup needed",
                2L
        );

        petDTOList = Arrays.asList(petDTO, secondPet);
    }

    @Test
    void getAllPets_shouldReturnList() {
        when(petService.getAllPets()).thenReturn(petDTOList);

        ResponseEntity<List<PetDTO>> response = petController.getAllPets();

        assertEquals(2, response.getBody().size());
        verify(petService).getAllPets();
    }

    @Test
    void getPetById_shouldReturnPet() {
        when(petService.getPetById(1L)).thenReturn(petDTO);

        ResponseEntity<PetDTO> response = petController.getPetById(1L);

        assertEquals(petDTO, response.getBody());
        verify(petService).getPetById(1L);
    }

    @Test
    void getPetsByUserId_shouldReturnPetList() {
        when(petService.getPetsByUserId(1L)).thenReturn(Arrays.asList(petDTO));

        ResponseEntity<List<PetDTO>> response = petController.getPetsByUserId(1L);

        assertEquals(1, response.getBody().size());
        assertEquals("Buddy", response.getBody().get(0).getName());
        verify(petService).getPetsByUserId(1L);
    }

    @Test
    void addPet_shouldReturnCreatedPet() {
        when(petService.addPet(petDTO)).thenReturn(petDTO);

        ResponseEntity<PetDTO> response = petController.addPet(petDTO);

        assertEquals(petDTO, response.getBody());
        verify(petService).addPet(petDTO);
    }

    @Test
    void updatePet_shouldReturnUpdatedPet() {
        when(petService.updatePet(1L, petDTO)).thenReturn(petDTO);

        ResponseEntity<PetDTO> response = petController.updatePet(1L, petDTO);

        assertEquals(petDTO, response.getBody());
        verify(petService).updatePet(1L, petDTO);
    }

    @Test
    void deletePet_shouldReturnDeletedPet() {
        when(petService.deletePet(1L)).thenReturn(petDTO);

        ResponseEntity<PetDTO> response = petController.deletePet(1L);

        assertEquals(petDTO, response.getBody());
        verify(petService).deletePet(1L);
    }

    @Test
    void getMyPets_shouldReturnUserPets() {
        when(petService.getMyPet()).thenReturn(Arrays.asList(petDTO));

        ResponseEntity<List<PetDTO>> response = petController.getMyPets();

        assertEquals(1, response.getBody().size());
        assertEquals(1L, response.getBody().get(0).getId());
        assertEquals("Buddy", response.getBody().get(0).getName());
        verify(petService).getMyPet();
    }
}