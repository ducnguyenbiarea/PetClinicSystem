package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

/**
 * Represents a user entity in the Pet Clinic system.
 * <p>
 * Users can have different roles such as OWNER, STAFF, DOCTOR, or ADMIN.
 * Each user may own multiple pets, make service bookings, and be associated with medical records.
 * </p>
 * See info about Models Overview:  <a href="../../../../custom-docs/ModelsOverview.html" target="_blank">Models Overview</a>
 * <p>
 *     See info about Models Annotation:  <a href="../../../../custom-docs/ModelsAnnotation.html" target="_blank">Models Annotation</a>
 * </p>
 *
 * @see BaseModel
 * @see Pet
 * @see ServiceBooking
 * @see MedicalRecord
 * @since 1.0
 */
@Getter
@Setter
@Entity
@Table(name = "users")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User extends BaseModel {
    /**
     * Full name of the user.
     */
    @Column(name = "name")
    String name;

    /**
     * User's password (Encrypted).
     */
    @Column(name = "password")
    String passWord;

    /**
     * Unique phone number for the user.
     */
    @Column(unique = true, name = "phone")
    String phone;

    /**
     * Unique email address for the user.
     */
    @Column(unique = true, name = "email")
    String email;

    /**
     * Role of the user in the system.
     * Uses an enum to define user roles.
     * @see Roles
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "roles", columnDefinition = "VARCHAR(20) DEFAULT 'OWNER'")
    Roles roles;

    /**
     * List of pets owned by the user.
     * One-to-many relationship, mapped by the "user" field in {@link Pet}.
     */
    @OneToMany(mappedBy = "user")
    List<Pet> petList;

    /**
     * List of service bookings made by the user.
     * One-to-many relationship, mapped by the "user" field in {@link ServiceBooking}.
     */
    @OneToMany(mappedBy = "user")
    List<ServiceBooking> serviceBookingList;

    /**
     * List of medical records associated with the user.
     * One-to-many relationship, mapped by the "user" field in {@link MedicalRecord}.
     */
    @OneToMany(mappedBy = "user")
    List<MedicalRecord> medicalRecordList;

    /**
     * Enum representing the possible roles of a user.
     * <p>
     *     Possible values include: <br>
     *     - OWNER: Pet owner. <br>
     *     - STAFF: Staff member. <br>
     *     - DOCTOR: Veterinarian. <br>
     *     - ADMIN: System administrator.
     * </p>
     *
     * @see #OWNER Pet owner
     * @see #STAFF Staff member
     * @see #DOCTOR Veterinarian
     * @see #ADMIN System administrator
     */
    public enum Roles {
        /** Pet owner. */
        OWNER,
        /** Staff member. */
        STAFF,
        /** Veterinarian. */
        DOCTOR,
        /** System administrator. */
        ADMIN
    }
}
