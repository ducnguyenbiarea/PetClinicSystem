package com.demo.pet.services;

import com.demo.pet.dtos.CageDTO;

import java.util.List;

public interface CageService {
    List<CageDTO> getAllCages();

    CageDTO getCageById(Long id);

    CageDTO addCage(CageDTO dto);

    CageDTO updateCage(Long id, CageDTO dto);

    CageDTO deleteCage(Long id);

    CageDTO getCageByPetId(Long petId);

    List<CageDTO> getCagesByStatus(String status);

    List<CageDTO> getCagesByTypeAndSize(String type, String size);
}
