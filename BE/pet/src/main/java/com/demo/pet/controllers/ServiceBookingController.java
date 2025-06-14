package com.demo.pet.controllers;

import com.demo.pet.dtos.ServiceBookingDTO;
import com.demo.pet.dtos.subDTO.BookingStatusDTO;
import com.demo.pet.models.ServiceBooking;
import com.demo.pet.services.ServiceBookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class ServiceBookingController {
    private final ServiceBookingService bookingService;

    @GetMapping("")
    public ResponseEntity<List<ServiceBookingDTO>> getAllBookings() {
        return ResponseEntity.ok(bookingService.getAllBookings());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ServiceBookingDTO> getBookingById(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.getBookingById(id));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<ServiceBookingDTO>> getBookingsByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(bookingService.getBookingsByUserId(userId));
    }

    @GetMapping("/service/{serviceId}")
    public ResponseEntity<List<ServiceBookingDTO>> getBookingsByServiceId(@PathVariable Long serviceId) {
        return ResponseEntity.ok(bookingService.getBookingsByServiceId(serviceId));
    }

    @PostMapping("")
    public ResponseEntity<ServiceBookingDTO> createBooking(@RequestBody ServiceBookingDTO bookingDTO) {
        return ResponseEntity.ok(bookingService.createBooking(bookingDTO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ServiceBookingDTO> updateBooking(@PathVariable Long id, @RequestBody ServiceBookingDTO bookingDTO) {
        return ResponseEntity.ok(bookingService.updateBooking(id, bookingDTO));
    }

    @PutMapping("/{id}/cancel")
    public ResponseEntity<ServiceBookingDTO> cancelBooking(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.cancelBooking(id));
    }

    // only for admin
    @DeleteMapping("/{id}")
    public ResponseEntity<ServiceBookingDTO> deleteBooking(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.deleteBooking(id));
    }

    @GetMapping("/{id}/status")
    public ResponseEntity<BookingStatusDTO> getBookingStatus(@PathVariable Long id){
        return ResponseEntity.ok(bookingService.getBookingStatus(id));
    }

    // only for admin and staff
    @PatchMapping("/{id}/status")
    public ResponseEntity<ServiceBookingDTO> updateBookingStatus(@PathVariable Long id, @RequestParam String status) {
        return ResponseEntity.ok(bookingService.updateBookingStatus(id, status));
    }

    @GetMapping("/my-bookings")
    public ResponseEntity<List<ServiceBookingDTO>> getMyBookings() {
        return ResponseEntity.ok(bookingService.getMyBookings());
    }
}
