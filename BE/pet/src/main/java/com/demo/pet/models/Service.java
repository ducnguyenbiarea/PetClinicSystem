package com.demo.pet.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.context.annotation.EnableMBeanExport;

import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "service")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Service extends BaseModel {
    @Column(name = "name", nullable = false, length = 100)
    String name;

    @Column(name = "category", length = 50)
    String category;

    @Column(name = "description", columnDefinition = "TEXT")
    String description;

    @Column(name = "price")
    Double price;

    @OneToMany(mappedBy = "service")
    List<ServiceBooking> serviceBookingList;
}
