package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

/**
 * Represents a medical record for a pet in the Pet Clinic system.
 * <p>
 * Each medical record contains diagnosis, prescription, notes, and the next meeting date.
 * It is associated with a specific pet and a user (doctor or staff).
 * </p>
 * See info about Models Overview:  <a href="../../../../custom-docs/ModelsOverview.html" target="_blank">Models Overview</a>
 * <p>
 *     See info about Models Annotation:  <a href="../../../../custom-docs/ModelsAnnotation.html" target="_blank">Models Annotation</a>
 * </p>
 *
 * @see BaseModel
 * @see Pet
 * @see User
 * @since 1.0
 */
@Getter
@Setter
@Entity
@Table(name = "medical_record")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MedicalRecord extends BaseModel {
    /**
     * Diagnosis details for the medical record.
     * Must not be null. Stored as TEXT.
     */
    @Column(name = "diagnosis", columnDefinition = "TEXT", nullable = false)
    String diagnosis;

    /**
     * Prescription details for the medical record.
     * Stored as TEXT.
     */
    @Column(name = "prescription", columnDefinition = "TEXT")
    String prescription;

    /**
     * Additional notes for the medical record.
     * Stored as TEXT.
     */
    @Column(name = "notes", columnDefinition = "TEXT")
    String notes;

    /**
     * Next scheduled meeting date for follow-up.
     */
    @Column(name = "next_meeting_date")
    LocalDate nextMeetingDate;

    /**
     * The pet related to this medical record.
     * Many-to-one relationship to {@link Pet}.
     */
    @ManyToOne
    @JoinColumn(name = "pet_id", nullable = false)
    Pet pet;

    /**
     * The user (doctor or staff) associated with this medical record.
     * Many-to-one relationship to {@link User}.
     */
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    User user;
}
