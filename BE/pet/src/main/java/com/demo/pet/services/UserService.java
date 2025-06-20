package com.demo.pet.services;

import com.demo.pet.dtos.UserDTO;
import com.demo.pet.dtos.subDTO.UserRoleDTO;
import com.demo.pet.models.User;

import java.util.List;

public interface UserService {
    List<UserDTO> getAllUsers();

    UserDTO getUserById(Long id);

    UserDTO getUserByEmail(String email);

    UserDTO addUser(UserDTO userDTO);

    UserDTO updateUser(Long id, UserDTO userDTO);

    UserDTO deleteUser(Long id);

    UserDTO getMyInfo();

    UserRoleDTO getUserRole(Long id);

    //Only For Admin
    UserDTO updateUserRole(Long id, String newRole);
}
