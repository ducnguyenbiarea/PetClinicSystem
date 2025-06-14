package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "services")
@FieldDefaults(level = AccessLevel.PRIVATE)
@AllArgsConstructor
@NoArgsConstructor
public class Services extends BaseModel {
    @Column(name = "name", nullable = false, length = 100)
    String name;

    @Enumerated(EnumType.STRING)
    @Column(name = "category")
    CategoryTypes category;

    @Column(name = "description", columnDefinition = "TEXT")
    String description;

    @Column(name = "price")
    Double price;

    @OneToMany(mappedBy = "services")
    List<ServiceBooking> serviceBookingList;

    public enum CategoryTypes {
        EMERGENCY, HEALTH, CARE, MEDICAL
    }
}
