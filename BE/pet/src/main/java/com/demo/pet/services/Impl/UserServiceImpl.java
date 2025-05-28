package com.demo.pet.services.Impl;

import com.demo.pet.dtos.UserDTO;
import com.demo.pet.dtos.subDTO.UserRoleDTO;
import com.demo.pet.models.User;
import com.demo.pet.repositories.UserRepo;
import com.demo.pet.services.UserService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserServiceImpl implements UserService{
    UserRepo userRepo;
    PasswordEncoder passwordEncoder;

    @Override
    public List<UserDTO> getAllUsers() {
        return userRepo.findAll().stream().map(UserDTO::fromEntity).toList();
    }

    @Override
    public UserDTO getUserById(Long id) {
        return UserDTO.fromEntity(userRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id)));
    }

    @Override
    public UserDTO getUserByEmail(String email) {
        return UserDTO.fromEntity(userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email)));
    }

    @Override
    @Transactional
    public UserDTO addUser(UserDTO userDTO) {
        if (userRepo.existsByEmail(userDTO.getEmail())) {
            throw new RuntimeException("Email already in use");
        }

        if (userRepo.existsByPhone(userDTO.getPhone())) {
            throw new RuntimeException("Phone number already in use");
        }

        if (userDTO.getPassword() == null || userDTO.getPassword().isEmpty()) {
            throw new RuntimeException("Password cannot be empty");
        }

        if (userDTO.getEmail() == null || userDTO.getEmail().isEmpty()) {
            throw new RuntimeException("Email cannot be empty");
        }

        User user = new User();
        user.setName(userDTO.getName());
        user.setEmail(userDTO.getEmail());
        user.setPhone(userDTO.getPhone());
        user.setPassWord(passwordEncoder.encode(userDTO.getPassword())); // In real app, password should be encoded
        user.setRoles(User.Roles.OWNER); //mặc định là Owner khi khởi tạo lần đầu

        return UserDTO.fromEntity(userRepo.save(user));
    }

    @Override
    @Transactional
    public UserDTO updateUser(Long id, UserDTO userDTO) {
        User user = userRepo.findById(id).orElseThrow(() -> new RuntimeException("User not found with id: " + id));

        if (userDTO.getName() != null) {
            user.setName(userDTO.getName());
        }

        if (userDTO.getPassword() != null){
            user.setPassWord(userDTO.getPassword());
        }

        if (userDTO.getEmail() != null && !user.getEmail().equals(userDTO.getEmail())) {
            if (userRepo.existsByEmail(userDTO.getEmail())) {
                throw new RuntimeException("Email already in use");
            }
            user.setEmail(userDTO.getEmail());
        }

        if (userDTO.getPhone() != null && !user.getPhone().equals(userDTO.getPhone())) {
            if (userRepo.existsByPhone(userDTO.getPhone())) {
                throw new RuntimeException("Phone number already in use");
            }
            user.setPhone(userDTO.getPhone());
        }

        return UserDTO.fromEntity(userRepo.save(user));
    }


    @Override
    @Transactional
    public UserDTO deleteUser(Long id) {
        User user = userRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));

        // Check if user has any pets, bookings, or medical records before deletion
        if (!user.getPetList().isEmpty() ||
                !user.getServiceBookingList().isEmpty() ||
                !user.getMedicalRecordList().isEmpty()) {
            throw new IllegalStateException("Cannot delete user with associated records");
        }

        userRepo.delete(user);
        return UserDTO.fromEntity(user);
    }

    @Override
    public UserDTO getMyInfo() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName(); // Email được lưu trong principal

        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));

        return UserDTO.fromEntity(user);
    }

    @Override
    public UserRoleDTO getUserRole(Long id){
        User user = userRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));

        return new UserRoleDTO(user.getId(), user.getRoles().name());
    }


    @Override
    @Transactional
    public UserDTO updateUserRole(Long id, String newRole){
        User user = userRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));

        try {
            User.Roles role = User.Roles.valueOf(newRole.toUpperCase());
            user.setRoles(role);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid role: " + newRole);
        }
        userRepo.save(user);
        return UserDTO.fromEntity(user);
    }
}
