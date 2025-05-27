package com.demo.pet.config;

import com.demo.pet.models.User;
import com.demo.pet.repositories.UserRepo;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class ApplicationInitConfig {

    PasswordEncoder passwordEncoder;

    @Bean
    public ApplicationRunner applicationRunner(UserRepo userRepo) {
        return args -> {
            createUserIfNotExist(userRepo, "admin@example.com", "admin123", "Admin", "0123456789", User.Roles.ADMIN);
            createUserIfNotExist(userRepo, "owner@example.com", "owner123", "Owner", "0123456790", User.Roles.OWNER);
            createUserIfNotExist(userRepo, "staff@example.com", "staff123", "Staff", "0123456791", User.Roles.STAFF);
            createUserIfNotExist(userRepo, "doctor@example.com", "doctor123", "Doctor", "0123456792", User.Roles.DOCTOR);
        };
    }

    private void createUserIfNotExist(UserRepo userRepo, String email, String rawPassword, String name, String phone, User.Roles role) {
        if (userRepo.findByEmail(email).isEmpty()) {
            User user = User.builder()
                    .name(name)
                    .email(email)
                    .phone(phone)
                    .passWord(passwordEncoder.encode(rawPassword))
                    .roles(role)
                    .build();

            userRepo.save(user);
            log.info("Created {} user: {} / {}", role, email, rawPassword);
        } else {
            log.info("{} user already exists: {}", role, email);
        }
    }
}
