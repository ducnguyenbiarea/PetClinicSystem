package com.demo.pet.dtos;

import com.demo.pet.models.MedicalRecord;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

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
    Long id;

    String diagnosis;

    String prescription;

    String notes;

    @JsonProperty("next_meeting_date")
    LocalDate nextMeetingDate;

    @JsonProperty("pet_id")
    Long petId;

    @JsonProperty("user_id")
    Long userId;

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
