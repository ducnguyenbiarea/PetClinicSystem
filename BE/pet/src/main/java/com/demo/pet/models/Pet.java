package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "pet")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Pet extends BaseModel {
    @Column(name = "name", nullable = false, length = 100)
    String name;

    @Column(name = "birth_date")
    LocalDate birthDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender")
    Gender gender;

    @Column(name = "species", length = 50)
    String species;

    @Column(name = "color", length = 30)
    String color;

    @Column(name = "health_info", columnDefinition = "TEXT")
    String healthInfo;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    User user;

    // Tham chiếu ngược lại trường 'pet' trong Cage
    // Tự động xử lý khi Pet bị xóa (set null pet_id trong cage)
    @OneToOne(mappedBy = "pet", orphanRemoval = true)
    Cage cage;

    @OneToMany(mappedBy = "pet")
    List<MedicalRecord> medicalRecordList;


    public enum Gender {
        MALE, FEMALE
    }
}