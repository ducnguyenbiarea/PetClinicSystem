package com.demo.pet.repositories;

import com.demo.pet.models.ServiceBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ServiceBookingRepo extends JpaRepository<ServiceBooking, Long> {
    List<ServiceBooking> findByUserId(Long userId);
    List<ServiceBooking> findByServicesId(Long serviceId);
}
