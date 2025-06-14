package com.demo.pet;

import com.demo.pet.dtos.MedicalRecordDTO;
import com.demo.pet.services.MedicalRecordService;
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
class MedicalRecordControllerTest {

    @Mock
    private MedicalRecordService recordService;

    @InjectMocks
    private MedicalRecordController recordController;

    private MedicalRecordDTO recordDTO;
    private List<MedicalRecordDTO> recordDTOList;

    @BeforeEach
    void setUp() {
        // Create MedicalRecordDTO test data
        recordDTO = new MedicalRecordDTO(
                1L,
                "Regular checkup",
                "Vitamins twice daily",
                "Patient is healthy",
                LocalDate.now().plusDays(30),
                1L,
                2L
        );

        MedicalRecordDTO secondRecord = new MedicalRecordDTO(
                2L,
                "Vaccination",
                "Rest for 24 hours",
                "Annual vaccination completed",
                LocalDate.now().plusMonths(6),
                2L,
                2L
        );

        recordDTOList = Arrays.asList(recordDTO, secondRecord);
    }

    @Test
    void getAllRecords_shouldReturnList() {
        when(recordService.getAllRecords()).thenReturn(recordDTOList);

        ResponseEntity<List<MedicalRecordDTO>> response = recordController.getAllRecords();

        assertEquals(2, response.getBody().size());
        verify(recordService).getAllRecords();
    }

    @Test
    void getRecordById_shouldReturnRecord() {
        when(recordService.getRecordById(1L)).thenReturn(recordDTO);

        ResponseEntity<MedicalRecordDTO> response = recordController.getRecordById(1L);

        assertEquals(recordDTO, response.getBody());
        verify(recordService).getRecordById(1L);
    }

    @Test
    void getRecordsByPetId_shouldReturnRecordList() {
        when(recordService.getRecordsByPetId(1L)).thenReturn(Arrays.asList(recordDTO));

        ResponseEntity<List<MedicalRecordDTO>> response = recordController.getRecordsByPetId(1L);

        assertEquals(1, response.getBody().size());
        assertEquals("Regular checkup", response.getBody().get(0).getDiagnosis());
        verify(recordService).getRecordsByPetId(1L);
    }

    @Test
    void getRecordsByUserId_shouldReturnRecordList() {
        when(recordService.getRecordsByUserId(2L)).thenReturn(recordDTOList);

        ResponseEntity<List<MedicalRecordDTO>> response = recordController.getRecordsByUserId(2L);

        assertEquals(2, response.getBody().size());
        verify(recordService).getRecordsByUserId(2L);
    }

    @Test
    void addRecord_shouldReturnCreatedRecord() {
        when(recordService.addRecord(recordDTO)).thenReturn(recordDTO);

        ResponseEntity<MedicalRecordDTO> response = recordController.addRecord(recordDTO);

        assertEquals(recordDTO, response.getBody());
        verify(recordService).addRecord(recordDTO);
    }

    @Test
    void updateRecord_shouldReturnUpdatedRecord() {
        when(recordService.updateRecord(1L, recordDTO)).thenReturn(recordDTO);

        ResponseEntity<MedicalRecordDTO> response = recordController.updateRecord(1L, recordDTO);

        assertEquals(recordDTO, response.getBody());
        verify(recordService).updateRecord(1L, recordDTO);
    }

    @Test
    void deleteRecord_shouldReturnDeletedRecord() {
        when(recordService.deleteRecord(1L)).thenReturn(recordDTO);

        ResponseEntity<MedicalRecordDTO> response = recordController.deleteRecord(1L);

        assertEquals(recordDTO, response.getBody());
        verify(recordService).deleteRecord(1L);
    }

    @Test
    void getMyRecords_shouldReturnUserRecords() {
        when(recordService.getMyRecords()).thenReturn(Arrays.asList(recordDTO));

        ResponseEntity<List<MedicalRecordDTO>> response = recordController.getMyRecords();

        assertEquals(1, response.getBody().size());
        assertEquals(1L, response.getBody().get(0).getId());
        assertEquals("Regular checkup", response.getBody().get(0).getDiagnosis());
        verify(recordService).getMyRecords();
    }
}