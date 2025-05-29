package com.demo.pet.services.Impl;

import com.demo.pet.dtos.MedicalRecordDTO;
import com.demo.pet.models.MedicalRecord;
import com.demo.pet.models.Pet;
import com.demo.pet.models.User;
import com.demo.pet.repositories.MedicalRecordRepo;
import com.demo.pet.repositories.PetRepo;
import com.demo.pet.repositories.UserRepo;
import com.demo.pet.services.MedicalRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MedicalRecordServiceImpl implements MedicalRecordService {
    private final MedicalRecordRepo recordRepo;
    private final PetRepo petRepo;
    private final UserRepo userRepo;

    @Override
    public List<MedicalRecordDTO> getAllRecords() {
        return recordRepo.findAll().stream().map(MedicalRecordDTO::fromEntity).toList();
    }

    @Override
    public MedicalRecordDTO getRecordById(Long id) {
        return MedicalRecordDTO.fromEntity(recordRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Medical record not found with id: " + id)));
    }

    @Override
    public List<MedicalRecordDTO> getRecordsByPetId(Long petId) {
        return recordRepo.findByPetId(petId).stream().map(MedicalRecordDTO::fromEntity).toList();
    }

    @Override
    public List<MedicalRecordDTO> getRecordsByUserId(Long userId) {
        return recordRepo.findByUserId(userId).stream().map(MedicalRecordDTO::fromEntity).toList();
    }

    @Override
    @Transactional
    public MedicalRecordDTO addRecord(MedicalRecordDTO dto) {
        MedicalRecord record = new MedicalRecord();

        record.setDiagnosis(dto.getDiagnosis());
        record.setPrescription(dto.getPrescription());
        record.setNotes(dto.getNotes());
        record.setNextMeetingDate(dto.getNextMeetingDate());

        Pet pet = petRepo.findById(dto.getPetId())
                .orElseThrow(() -> new RuntimeException("Pet not found with id: " + dto.getPetId()));
        User user = userRepo.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with id: " + dto.getUserId()));
        record.setPet(pet);
        record.setUser(user);

        return MedicalRecordDTO.fromEntity(recordRepo.save(record));
    }

    @Override
    @Transactional
    public MedicalRecordDTO updateRecord(Long id, MedicalRecordDTO dto) {
        MedicalRecord record = recordRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Medical record not found with id: " + id));

        if (dto.getDiagnosis() != null && !dto.getDiagnosis().isEmpty()) {
            record.setDiagnosis(dto.getDiagnosis());
        } else {
            throw new RuntimeException("Diagnosis cannot be null or empty");
        }

        if (dto.getPrescription() != null) record.setPrescription(dto.getPrescription());
        if (dto.getNotes() != null) record.setNotes(dto.getNotes());
        if (dto.getNextMeetingDate() != null) record.setNextMeetingDate(dto.getNextMeetingDate());

        // Ensure pet and user IDs are not null and fetch the entities
        if (dto.getPetId() != null) {
            Pet pet = petRepo.findById(dto.getPetId())
                    .orElseThrow(() -> new RuntimeException("Pet not found with id: " + dto.getPetId()));
            record.setPet(pet);
        } else {
            throw new RuntimeException("Pet ID cannot be null");
        }

        if (dto.getUserId() != null) {
            User user = userRepo.findById(dto.getUserId())
                    .orElseThrow(() -> new RuntimeException("User not found with id: " + dto.getUserId()));
            record.setUser(user);
        } else {
            throw new RuntimeException("User ID cannot be null");
        }

        return MedicalRecordDTO.fromEntity(recordRepo.save(record));
    }

    @Override
    @Transactional
    public MedicalRecordDTO deleteRecord(Long id) {
        MedicalRecord record = recordRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Medical record not found with id: " + id));

        recordRepo.delete(record);
        return MedicalRecordDTO.fromEntity(record);
    }

    @Override
    public List<MedicalRecordDTO> getMyRecords() {
        // Get authenticated user's email
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName(); // Email được lưu trong principal

        // Find user ID by email
        var userId = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email))
                .getId();

        // Fetch medical records for the user
        return recordRepo.findByUserId(userId).stream()
                .map(MedicalRecordDTO::fromEntity)
                .toList();
    }
}
