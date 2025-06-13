package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "medical_record")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MedicalRecord extends BaseModel {
    @Column(name = "diagnosis", columnDefinition = "TEXT", nullable = false)
    String diagnosis;

    @Column(name = "prescription", columnDefinition = "TEXT")
    String prescription;

    @Column(name = "notes", columnDefinition = "TEXT")
    String notes;

    @Column(name = "next_meeting_date")
    LocalDate nextMeetingDate;

    @ManyToOne
    @JoinColumn(name = "pet_id", nullable = false)
    Pet pet;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    User user;
}
