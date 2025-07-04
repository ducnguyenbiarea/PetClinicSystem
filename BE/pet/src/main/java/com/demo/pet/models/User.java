package com.demo.pet.models;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "users")
@FieldDefaults(level = AccessLevel.PRIVATE)
@NoArgsConstructor // tạo No để tự tùy chỉnh truyền tham số nếu cần
@AllArgsConstructor // tạo All để debug nếu cần
@Builder
public class User extends BaseModel {
    @Column(name = "name")
    String name;

    @Column(name = "password")
    String passWord;

    @Column(unique = true, name = "phone")
    String phone;

    @Column(unique = true, name = "email")
    String email;

    @Enumerated(EnumType.STRING)
    @Column(name = "roles", columnDefinition = "VARCHAR(20) DEFAULT 'OWNER'")
    Roles roles;

    @OneToMany(mappedBy = "user")
    List<Pet> petList;

    @OneToMany(mappedBy = "user")
    List<ServiceBooking> serviceBookingList;

    @OneToMany(mappedBy = "user")
    List<MedicalRecord> medicalRecordList;


    public enum Roles {
        OWNER, STAFF, DOCTOR, ADMIN
    }
}
