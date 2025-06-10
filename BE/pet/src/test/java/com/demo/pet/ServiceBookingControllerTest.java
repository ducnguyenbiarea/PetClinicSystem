package com.demo.pet.controllers;

import com.demo.pet.dtos.ServiceBookingDTO;
import com.demo.pet.dtos.subDTO.BookingStatusDTO;
import com.demo.pet.services.ServiceBookingService;
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
class ServiceBookingControllerTest {

    @Mock
    private ServiceBookingService bookingService;

    @InjectMocks
    private ServiceBookingController bookingController;

    private ServiceBookingDTO bookingDTO;
    private List<ServiceBookingDTO> bookingDTOList;
    private BookingStatusDTO bookingStatusDTO;

    @BeforeEach
    void setUp() {
        // Create ServiceBookingDTO test data
        bookingDTO = new ServiceBookingDTO(
                1L,
                LocalDate.now(),
                LocalDate.now().plusDays(7),
                "Regular grooming service",
                1L,
                2L
        );

        ServiceBookingDTO secondBooking = new ServiceBookingDTO(
                2L,
                LocalDate.now().plusDays(3),
                LocalDate.now().plusDays(5),
                "Checkup and vaccines",
                2L,
                3L
        );

        bookingDTOList = Arrays.asList(bookingDTO, secondBooking);
        bookingStatusDTO = new BookingStatusDTO(1L, "PENDING");
    }

    @Test
    void getAllBookings_shouldReturnList() {
        when(bookingService.getAllBookings()).thenReturn(bookingDTOList);

        ResponseEntity<List<ServiceBookingDTO>> response = bookingController.getAllBookings();

        assertEquals(2, response.getBody().size());
        verify(bookingService).getAllBookings();
    }

    @Test
    void getBookingById_shouldReturnBooking() {
        when(bookingService.getBookingById(1L)).thenReturn(bookingDTO);

        ResponseEntity<ServiceBookingDTO> response = bookingController.getBookingById(1L);

        assertEquals(bookingDTO, response.getBody());
        verify(bookingService).getBookingById(1L);
    }

    @Test
    void getBookingsByUserId_shouldReturnBookingList() {
        when(bookingService.getBookingsByUserId(1L)).thenReturn(Arrays.asList(bookingDTO));

        ResponseEntity<List<ServiceBookingDTO>> response = bookingController.getBookingsByUserId(1L);

        assertEquals(1, response.getBody().size());
        assertEquals(1L, response.getBody().get(0).getUserId());
        verify(bookingService).getBookingsByUserId(1L);
    }

    @Test
    void getBookingsByServiceId_shouldReturnBookingList() {
        when(bookingService.getBookingsByServiceId(2L)).thenReturn(Arrays.asList(bookingDTO));

        ResponseEntity<List<ServiceBookingDTO>> response = bookingController.getBookingsByServiceId(2L);

        assertEquals(1, response.getBody().size());
        assertEquals(2L, response.getBody().get(0).getServiceId());
        verify(bookingService).getBookingsByServiceId(2L);
    }

    @Test
    void createBooking_shouldReturnCreatedBooking() {
        when(bookingService.createBooking(bookingDTO)).thenReturn(bookingDTO);

        ResponseEntity<ServiceBookingDTO> response = bookingController.createBooking(bookingDTO);

        assertEquals(bookingDTO, response.getBody());
        verify(bookingService).createBooking(bookingDTO);
    }

    @Test
    void updateBooking_shouldReturnUpdatedBooking() {
        when(bookingService.updateBooking(1L, bookingDTO)).thenReturn(bookingDTO);

        ResponseEntity<ServiceBookingDTO> response = bookingController.updateBooking(1L, bookingDTO);

        assertEquals(bookingDTO, response.getBody());
        verify(bookingService).updateBooking(1L, bookingDTO);
    }

    @Test
    void cancelBooking_shouldReturnCancelledBooking() {
        when(bookingService.cancelBooking(1L)).thenReturn(bookingDTO);

        ResponseEntity<ServiceBookingDTO> response = bookingController.cancelBooking(1L);

        assertEquals(bookingDTO, response.getBody());
        verify(bookingService).cancelBooking(1L);
    }

    @Test
    void deleteBooking_shouldReturnDeletedBooking() {
        when(bookingService.deleteBooking(1L)).thenReturn(bookingDTO);

        ResponseEntity<ServiceBookingDTO> response = bookingController.deleteBooking(1L);

        assertEquals(bookingDTO, response.getBody());
        verify(bookingService).deleteBooking(1L);
    }

    @Test
    void getBookingStatus_shouldReturnStatus() {
        when(bookingService.getBookingStatus(1L)).thenReturn(bookingStatusDTO);

        ResponseEntity<BookingStatusDTO> response = bookingController.getBookingStatus(1L);

        assertEquals(bookingStatusDTO, response.getBody());
        assertEquals("PENDING", response.getBody().getStatus());
        verify(bookingService).getBookingStatus(1L);
    }

    @Test
    void updateBookingStatus_shouldReturnUpdatedBooking() {
        when(bookingService.updateBookingStatus(1L, "ACCEPTED")).thenReturn(bookingDTO);

        ResponseEntity<ServiceBookingDTO> response = bookingController.updateBookingStatus(1L, "ACCEPTED");

        assertEquals(bookingDTO, response.getBody());
        verify(bookingService).updateBookingStatus(1L, "ACCEPTED");
    }

    @Test
    void getMyBookings_shouldReturnUserBookings() {
        when(bookingService.getMyBookings()).thenReturn(Arrays.asList(bookingDTO));

        ResponseEntity<List<ServiceBookingDTO>> response = bookingController.getMyBookings();

        assertEquals(1, response.getBody().size());
        assertEquals(1L, response.getBody().get(0).getId());
        verify(bookingService).getMyBookings();
    }
}