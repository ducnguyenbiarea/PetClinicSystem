package com.demo.pet.services.Impl;

import com.demo.pet.dtos.ServicesDTO;
import com.demo.pet.models.ServiceBooking;
import com.demo.pet.models.Services;
import com.demo.pet.repositories.ServiceRepo;
import com.demo.pet.services.ServicesService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class ServicesServiceImpl implements ServicesService {
    ServiceRepo serviceRepo;

    @Override
    public List<ServicesDTO> getAllServices() {
        return serviceRepo.findAll().stream().map(ServicesDTO::fromEntity).toList();
    }

    @Override
    public ServicesDTO getServicesById(Long id) {
        return ServicesDTO.fromEntity(Objects.requireNonNull(serviceRepo.findById(id)
                .orElseThrow(()-> new RuntimeException("Services not found with id: " + id))));
    }

    @Override
    public ServicesDTO addServices(ServicesDTO servicesDTO) {
        Services services = new Services();

        services.setName(servicesDTO.getName());
        services.setCategory(Services.CategoryTypes.valueOf(servicesDTO.getCategory().toUpperCase()));
        services.setDescription(servicesDTO.getDescription());
        services.setPrice(servicesDTO.getPrice());

        return ServicesDTO.fromEntity(serviceRepo.save(services));
    }

    @Override
    public ServicesDTO updateServices(Long id, ServicesDTO servicesDTO) {
        Services services = serviceRepo.findById(id).orElseThrow(() -> new RuntimeException("Service not found with id: " + id));

        if(servicesDTO.getName() != null) services.setName(servicesDTO.getName());
        if(servicesDTO.getCategory() != null) services.setCategory(Services.CategoryTypes.valueOf(servicesDTO.getCategory().toUpperCase()));
        if(servicesDTO.getDescription() != null) services.setDescription(servicesDTO.getDescription());
        if(servicesDTO.getPrice() != null) services.setPrice(servicesDTO.getPrice());

        return ServicesDTO.fromEntity(serviceRepo.save(services));
    }

    @Override
    public ServicesDTO deleteServices(Long id) {
        Services services = serviceRepo.findById(id).orElseThrow(() -> new RuntimeException("Service not found with id: " + id));

//        2. Kiểm tra xem có bất kỳ ServiceBooking nào đang ở trạng thái PENDING không
//        boolean hasPendingBookings = services.getServiceBookingList().stream()
//                .anyMatch(booking -> booking.getStatus() == ServiceBooking.SubscriptionStatus.PENDING);
//
//        if (hasPendingBookings) {
//            throw new IllegalStateException(
//                    "Cannot delete service because there are " +
//                            services.getServiceBookingList().stream()
//                                    .filter(booking -> booking.getStatus() == ServiceBooking.SubscriptionStatus.PENDING)
//                                    .count() +
//                            " pending booking(s) for this service"
//            );
//        }

        serviceRepo.delete(services);

        return ServicesDTO.fromEntity(services);
    }
}
