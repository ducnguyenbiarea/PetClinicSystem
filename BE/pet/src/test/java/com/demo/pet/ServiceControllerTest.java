package com.demo.pet.controllers;

import com.demo.pet.dtos.ServicesDTO;
import com.demo.pet.models.Services;
import com.demo.pet.services.ServicesService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ServiceControllerTest {

    @Mock
    private ServicesService servicesService;

    @InjectMocks
    private ServiceController serviceController;

    private ServicesDTO serviceDTO;
    private List<ServicesDTO> serviceDTOList;

    @BeforeEach
    void setUp() {
        // Create ServicesDTO test data
        serviceDTO = new ServicesDTO(
                1L,
                "Grooming",
                "CARE",
                "Full pet grooming service",
                50.0
        );

        ServicesDTO secondService = new ServicesDTO(
                2L,
                "Vaccination",
                "MEDICAL",
                "Regular vaccination service",
                75.0
        );

        serviceDTOList = Arrays.asList(serviceDTO, secondService);
    }

    @Test
    void getAllServices_shouldReturnList() {
        when(servicesService.getAllServices()).thenReturn(serviceDTOList);

        ResponseEntity<List<ServicesDTO>> response = serviceController.getAllServices();

        assertEquals(2, response.getBody().size());
        verify(servicesService).getAllServices();
    }

    @Test
    void getServiceById_shouldReturnService() {
        when(servicesService.getServicesById(1L)).thenReturn(serviceDTO);

        ResponseEntity<ServicesDTO> response = serviceController.getServiceById(1L);

        assertEquals(serviceDTO, response.getBody());
        verify(servicesService).getServicesById(1L);
    }

    @Test
    void addService_shouldReturnCreatedService() {
        when(servicesService.addServices(serviceDTO)).thenReturn(serviceDTO);

        ResponseEntity<ServicesDTO> response = serviceController.addService(serviceDTO);

        assertEquals(serviceDTO, response.getBody());
        verify(servicesService).addServices(serviceDTO);
    }

    @Test
    void updateService_shouldReturnUpdatedService() {
        when(servicesService.updateServices(1L, serviceDTO)).thenReturn(serviceDTO);

        ResponseEntity<ServicesDTO> response = serviceController.updateService(1L, serviceDTO);

        assertEquals(serviceDTO, response.getBody());
        verify(servicesService).updateServices(1L, serviceDTO);
    }

    @Test
    void deleteService_shouldReturnDeletedService() {
        when(servicesService.deleteServices(1L)).thenReturn(serviceDTO);

        ResponseEntity<ServicesDTO> response = serviceController.deleteService(1L);

        assertEquals(serviceDTO, response.getBody());
        verify(servicesService).deleteServices(1L);
    }
}