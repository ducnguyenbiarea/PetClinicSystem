package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

/**
 * Represents a pet entity in the Pet Clinic system.
 * <p>
 * Each pet is owned by a user, may be assigned to a cage, and can have multiple medical records.
 * Pets have attributes such as name, birth date, gender, species, color, and health information.
 * </p>
 * See info about Models Overview:  <a href="../../../../custom-docs/ModelsOverview.html" target="_blank">Models Overview</a>
 * <p>
 *     See info about Models Annotation:  <a href="../../../../custom-docs/ModelsAnnotation.html" target="_blank">Models Annotation</a>
 * </p>
 *
 * @see BaseModel
 * @see User
 * @see Cage
 * @see MedicalRecord
 * @since 1.0
 */
@Getter
@Setter
@Entity
@Table(name = "pet")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Pet extends BaseModel {
    /**
     * Name of the pet (max 100 characters).
     * Must not be null.
     */
    @Column(name = "name", nullable = false, length = 100)
    String name;

    /**
     * Birth date of the pet.
     */
    @Column(name = "birth_date")
    LocalDate birthDate;

    /**
     * Gender of the pet.
     * Uses an enum to specify gender.
     * @see Gender
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "gender")
    Gender gender;

    /**
     * Species of the pet (e.g., dog, cat).
     */
    @Column(name = "species", length = 50)
    String species;

    /**
     * Color of the pet.
     */
    @Column(name = "color", length = 30)
    String color;

    /**
     * Health information about the pet.
     * Stored as TEXT in the database.
     */
    @Column(name = "health_info", columnDefinition = "TEXT")
    String healthInfo;

    /**
     * The user who owns the pet.
     * Many-to-one relationship to {@link User}.
     */
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    User user;

    /**
     * The cage assigned to the pet (optional, one-to-one).
     * Inverse side of the relationship.
     */
    // Tham chiếu ngược lại trường 'pet' trong Cage
    // Tự động xử lý khi Pet bị xóa (set null pet_id trong cage)
    @OneToOne(mappedBy = "pet", orphanRemoval = true)
    Cage cage;

    /**
     * List of medical records for the pet.
     * One-to-many relationship, mapped by the "pet" field in {@link MedicalRecord}.
     */
    @OneToMany(mappedBy = "pet")
    List<MedicalRecord> medicalRecordList;

    /**
     * Enum representing the gender of the pet.
     * <p>
     *     Possible values include: <br>
     *     - MALE: Male pet. <br>
     *     - FEMALE: Female pet.
     * </p>
     *
     * @see #MALE Male pet
     * @see #FEMALE Female pet
     */
    public enum Gender {
        /** Male pet. */
        MALE,
        /** Female pet. */
        FEMALE
    }
}