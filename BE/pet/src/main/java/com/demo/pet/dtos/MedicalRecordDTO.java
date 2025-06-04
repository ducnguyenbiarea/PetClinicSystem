package com.demo.pet.dtos;

import com.demo.pet.models.MedicalRecord;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

/**
 * Represents a Data Transfer Object (DTO) for medical record data in the Pet Clinic system.
 * <p>
 * Used to transfer medical record information between application layers or over the network,
 * decoupling the API contract from the internal model structure.
 * Includes fields such as diagnosis, prescription, notes, next meeting date, pet ID, and user ID.
 * </p>
 * See info about DTOs Overview: <a href="../../../../custom-docs/DtosOverview.html" target="_blank">DTOs Overview</a>
 * <p>
 *     See info about DTOs Annotation: <a href="../../../../custom-docs/DtosAnnotation.html" target="_blank">DTOs Annotation</a>
 * </p>
 *
 * @see com.demo.pet.models.MedicalRecord
 * @since 1.0
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonPropertyOrder({
        "id",
        "diagnosis",
        "prescription",
        "notes",
        "next_meeting_date",
        "pet_id",
        "user_id"
})
public class MedicalRecordDTO {
    /**
     * Unique identifier for the medical record.
     */
    Long id;

    /**
     * Diagnosis details for the medical record.
     */
    String diagnosis;

    /**
     * Prescription details for the medical record.
     */
    String prescription;

    /**
     * Additional notes for the medical record.
     */
    String notes;

    /**
     * Next scheduled meeting date for follow-up.
     * <p>
     * Mapped to "next_meeting_date" in JSON.
     * </p>
     */
    @JsonProperty("next_meeting_date")
    LocalDate nextMeetingDate;

    /**
     * ID of the pet related to this medical record.
     * <p>
     * Mapped to "pet_id" in JSON.
     * </p>
     */
    @JsonProperty("pet_id")
    Long petId;

    /**
     * ID of the user (doctor or staff) associated with this medical record.
     * <p>
     * Mapped to "user_id" in JSON.
     * </p>
     */
    @JsonProperty("user_id")
    Long userId;

    /**
     * Converts a {@link com.demo.pet.models.MedicalRecord} entity to a {@code MedicalRecordDTO}.
     *
     * @param record the MedicalRecord entity to convert
     * @return a new MedicalRecordDTO with data mapped from the entity
     */
    public static MedicalRecordDTO fromEntity(MedicalRecord record) {
        return new MedicalRecordDTO(
                record.getId(),
                record.getDiagnosis(),
                record.getPrescription(),
                record.getNotes(),
                record.getNextMeetingDate(),
                record.getPet() != null ? record.getPet().getId() : null,
                record.getUser() != null ? record.getUser().getId() : null
        );
    }
}
