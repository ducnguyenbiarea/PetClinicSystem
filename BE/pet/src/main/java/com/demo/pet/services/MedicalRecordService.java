package com.demo.pet.services;

import com.demo.pet.dtos.MedicalRecordDTO;

import java.util.List;

public interface MedicalRecordService {
    List<MedicalRecordDTO> getAllRecords();

    MedicalRecordDTO getRecordById(Long id);

    List<MedicalRecordDTO> getRecordsByPetId(Long petId);

    List<MedicalRecordDTO> getRecordsByUserId(Long userId);

    MedicalRecordDTO addRecord(MedicalRecordDTO dto);

    MedicalRecordDTO updateRecord(Long id, MedicalRecordDTO dto);

    // only admin and doctor can delete record
    MedicalRecordDTO deleteRecord(Long id);

    // ham phu tro getMyRecords
    List<MedicalRecordDTO> getMyRecords();
}