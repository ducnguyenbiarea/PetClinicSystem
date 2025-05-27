package com.demo.pet.services;

import com.demo.pet.dtos.ServicesDTO;
import java.util.List;

public interface ServicesService {
    List<ServicesDTO> getAllServices();

    ServicesDTO getServicesById(Long id);

    ServicesDTO addServices(ServicesDTO servicesDTO);

    ServicesDTO updateServices(Long id, ServicesDTO servicesDTO);

    ServicesDTO deleteServices(Long id);
}
