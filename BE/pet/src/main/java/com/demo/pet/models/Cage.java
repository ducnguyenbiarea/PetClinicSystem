package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

/**
 * Represents a cage entity in the Pet Clinic system.
 * <p>
 * Each cage can be assigned to a pet (optional, one-to-one), has a type, size, status, and occupancy dates.
 * Cages are used to house pets temporarily or during their stay at the clinic.
 * </p>
 * See info about Models Overview:  <a href="../../../../custom-docs/ModelsOverview.html" target="_blank">Models Overview</a>
 * <p>
 *     See info about Models Annotation:  <a href="../../../../custom-docs/ModelsAnnotation.html" target="_blank">Models Annotation</a>
 * </p>
 *
 * @see BaseModel
 * @see Pet
 * @since 1.0
 */
@Getter
@Setter
@Entity
@Table(name = "cage")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cage extends BaseModel {
    /**
     * Type of the cage (e.g., small, large, special).
     * Must not be null.
     */
    @Column(name = "type", length = 50, nullable = false)
    String type;

    /**
     * Size of the cage (e.g., S, M, L).
     * Must not be null.
     */
    @Column(name = "size", length = 30, nullable = false)
    String size;

    /**
     * Status of the cage.
     * Uses an enum to specify if the cage is available, occupied, or being cleaned.
     * @see Status
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "status", columnDefinition = "VARCHAR(20) DEFAULT 'AVAILABLE'")
    Status status;

    /**
     * Start date of occupancy.
     */
    @Column(name = "start_date")
    LocalDate startDate;

    /**
     * End date of occupancy.
     */
    @Column(name = "end_date")
    LocalDate endDate;

    /**
     * The pet assigned to this cage (optional, one-to-one).
     * Cascade operations are applied to the pet.
     */
    // Áp dụng thao tác xóa/sửa lên Pet
    // Cho phép pet = null
    @OneToOne(cascade = CascadeType.ALL, optional = true)
    @JoinColumn(name = "pet_id", unique = true)
    Pet pet;

    /**
     * Enum representing the status of the cage.
     * <p>
     *     Possible values include: <br>
     *     - AVAILABLE: Cage is empty and ready for use. <br>
     *     - OCCUPIED: Cage is currently housing a pet. <br>
     *     - CLEANING: Cage is being cleaned and not available.
     * </p>
     *
     * @see #AVAILABLE Cage is available
     * @see #OCCUPIED Cage is occupied
     * @see #CLEANING Cage is being cleaned
     */
    public enum Status {
        /** Cage is available for use. */
        AVAILABLE,  // Chuồng trống
        /** Cage is currently occupied by a pet. */
        OCCUPIED,   // Đang có thú
        /** Cage is being cleaned. */
        CLEANING    // Đang vệ sinh
    }
}