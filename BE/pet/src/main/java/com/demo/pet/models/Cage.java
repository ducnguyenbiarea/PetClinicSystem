package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "cage")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cage extends BaseModel {
    @Column(name = "type", length = 50)
    String type;

    @Column(name = "size", length = 30)
    String size;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", columnDefinition = "VARCHAR(20) DEFAULT 'AVAILABLE'")
    Status status;

    @Column(name = "start_date")
    LocalDate startDate;

    @Column(name = "end_date")
    LocalDate endDate;

    // Áp dụng thao tác xóa/sửa lên Pet
    // Cho phép pet = null
    @OneToOne(cascade = CascadeType.ALL, optional = true)
    @JoinColumn(name = "pet_id", unique = true)
    Pet pet;

    public enum Status {
        AVAILABLE,  // Chuồng trống
        OCCUPIED,   // Đang có thú
        CLEANING    // Đang vệ sinh
    }
}