package com.demo.pet.services.Impl;

import com.demo.pet.dtos.ServiceBookingDTO;
import com.demo.pet.dtos.subDTO.BookingStatusDTO;
import com.demo.pet.models.ServiceBooking;
import com.demo.pet.repositories.ServiceBookingRepo;
import com.demo.pet.repositories.ServiceRepo;
import com.demo.pet.repositories.UserRepo;
import com.demo.pet.services.ServiceBookingService;
import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class ServiceBookingServiceImpl implements ServiceBookingService{
    ServiceBookingRepo bookingRepo;
    UserRepo userRepo;
    ServiceRepo serviceRepo;

    @Override
    public List<ServiceBookingDTO> getAllBookings() {
        return bookingRepo.findAll().stream().map(ServiceBookingDTO::fromEntity).toList();
    }

    @Override
    public ServiceBookingDTO getBookingById(Long id) {
        return ServiceBookingDTO.fromEntity(bookingRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found with id: " + id)));
    }

    @Override
    public List<ServiceBookingDTO> getBookingsByUserId(Long userId) {
        return bookingRepo.findByUserId(userId).stream()
                .map(ServiceBookingDTO::fromEntity)
                .toList();
    }

    @Override
    public List<ServiceBookingDTO> getBookingsByServiceId(Long serviceId) {
        return bookingRepo.findByServicesId(serviceId).stream()
                .map(ServiceBookingDTO::fromEntity)
                .toList();
    }

    @Override
    @Transactional
    public ServiceBookingDTO createBooking(ServiceBookingDTO bookingDTO) {
        ServiceBooking serviceBooking = new ServiceBooking();

        serviceBooking.setStartDate(bookingDTO.getStartDate());
        serviceBooking.setEndDate(bookingDTO.getEndDate());
        serviceBooking.setStatus(ServiceBooking.SubscriptionStatus.PENDING); // Default status
        serviceBooking.setNotes(bookingDTO.getNotes());
        serviceBooking.setUser(userRepo.findById(bookingDTO.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with id: " + bookingDTO.getUserId())));
        serviceBooking.setServices(serviceRepo.findById(bookingDTO.getServiceId())
                .orElseThrow(() -> new RuntimeException("Service not found with id: " + bookingDTO.getServiceId())));

        return ServiceBookingDTO.fromEntity(bookingRepo.save(serviceBooking));
    }

    @Override
    @Transactional
    public ServiceBookingDTO updateBooking(Long id, ServiceBookingDTO bookingDTO) {
        ServiceBooking serviceBooking = bookingRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found with id: " + id));

        // Update booking fields only if they are not null
        if (bookingDTO.getStartDate() != null){
            serviceBooking.setStartDate(bookingDTO.getStartDate());
        } else {
            throw new RuntimeException("Start date cannot be null");
        }

        if (bookingDTO.getEndDate() != null) serviceBooking.setEndDate(bookingDTO.getEndDate());
        if (bookingDTO.getNotes() != null) serviceBooking.setNotes(bookingDTO.getNotes());

        // Ensure user ID and service ID are not null and fetch the user and service
        if (bookingDTO.getUserId() != null) {
            serviceBooking.setUser(userRepo.findById(bookingDTO.getUserId())
                    .orElseThrow(() -> new RuntimeException("User not found with id: " + bookingDTO.getUserId())));
        } else {
            throw new RuntimeException("User ID cannot be null");
        }

        if (bookingDTO.getServiceId() != null) {
            serviceBooking.setServices(serviceRepo.findById(bookingDTO.getServiceId())
                    .orElseThrow(() -> new RuntimeException("Service not found with id: " + bookingDTO.getServiceId())));
        } else {
            throw new RuntimeException("Service ID cannot be null");
        }

        return ServiceBookingDTO.fromEntity(bookingRepo.save(serviceBooking));
    }

    @Override
    @Transactional
    public ServiceBookingDTO cancelBooking(Long id){
        // Find the booking by ID
        ServiceBooking serviceBooking = bookingRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found with id: " + id));

        // Check if the booking is already cancelled or completed
        serviceBooking.setStatus(ServiceBooking.SubscriptionStatus.CANCELLED);
        return ServiceBookingDTO.fromEntity(bookingRepo.save(serviceBooking));
    }

    @Override
    @Transactional
    public ServiceBookingDTO deleteBooking(Long id) {
        ServiceBooking serviceBooking = bookingRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found with id: " + id));

        if (serviceBooking.getStatus() == ServiceBooking.SubscriptionStatus.PENDING) {
            bookingRepo.delete(serviceBooking);
            return ServiceBookingDTO.fromEntity(serviceBooking);
        }
        throw new IllegalStateException("Cannot delete booking with status: " + serviceBooking.getStatus());
    }

    @Override
    public BookingStatusDTO getBookingStatus(Long id){
        ServiceBooking serviceBooking = bookingRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found with id: " + id));

        return new BookingStatusDTO(serviceBooking.getId(), serviceBooking.getStatus().name());
    }

    @Override
    @Transactional
    public ServiceBookingDTO updateBookingStatus(Long id, String status) {
        ServiceBooking serviceBooking = bookingRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found with id: " + id));

        try {
            serviceBooking.setStatus(ServiceBooking.SubscriptionStatus.valueOf(status.toUpperCase()));
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid status: " + status);
        }

        return ServiceBookingDTO.fromEntity(bookingRepo.save(serviceBooking));
    }

    @Override
    public List<ServiceBookingDTO> getMyBookings() {
        // Get authenticated user's email
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName(); // Email được lưu trong principal

        // Find user ID by email
        var userId = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email))
                .getId();

        // Fetch bookings by user ID
        return bookingRepo.findByUserId(userId).stream()
                .map(ServiceBookingDTO::fromEntity)
                .toList();
    }
}
