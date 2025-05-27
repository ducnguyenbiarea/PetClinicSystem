package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "service_booking")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ServiceBooking extends BaseModel {
    @Column(name = "start_date", nullable = false)
    LocalDate startDate;

    @Column(name = "end_date", nullable = false)
    LocalDate endDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", columnDefinition = "VARCHAR(20) DEFAULT 'PENDING'")
    SubscriptionStatus status; // Pending, Completed, Cancelled

    @Column(name = "notes", columnDefinition = "TEXT")
    String notes;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    User user;

    @ManyToOne
    @JoinColumn(name = "service_id", nullable = false)
    Services services;

    public enum SubscriptionStatus {
        PENDING, COMPLETED, CANCELLED
    }
}
