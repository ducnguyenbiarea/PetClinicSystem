package com.demo.pet.services;

import com.demo.pet.dtos.UserDTO;
import com.demo.pet.dtos.subDTO.UserRoleDTO;
import com.demo.pet.models.User;

import java.util.List;

/**
 * Service interface for managing user-related business logic in the Pet Clinic system.
 * <p>
 * Provides methods for user registration, update, deletion, role management, and retrieval of user information.
 * </p>
 * <p>
 *     See more in: <a href="../../../../custom-docs/ServiceOverview.html" target="_blank">ServiceOverview</a>
 * </p>
 *
 * @see com.demo.pet.dtos.UserDTO
 * @since 1.0
 */
public interface UserService {
    /**
     * Retrieves all users.
     * @return list of all users
     */
    List<UserDTO> getAllUsers();

    /**
     * Retrieves a user by their ID.
     * @param id the ID of the user
     * @return the user with the specified ID
     */
    UserDTO getUserById(Long id);

    /**
     * Retrieves a user by their email.
     * @param email the email of the user
     * @return the user with the specified email
     */
    UserDTO getUserByEmail(String email);

    /**
     * Adds a new user.
     * @param userDTO the user data to add
     * @return the added user
     */
    UserDTO addUser(UserDTO userDTO);

    /**
     * Updates an existing user.
     * @param id the ID of the user to update
     * @param userDTO the updated user data
     * @return the updated user
     */
    UserDTO updateUser(Long id, UserDTO userDTO);

    /**
     * Deletes a user by their ID.
     * @param id the ID of the user to delete
     * @return the deleted user
     */
    UserDTO deleteUser(Long id);

    /**
     * Retrieves the currently logged-in user's information.
     * @return the current user's information
     */
    UserDTO getMyInfo();

    /**
     * Retrieves the role of a user by their ID.
     * @param id the ID of the user
     * @return the user's role information
     */
    UserRoleDTO getUserRole(Long id);

    /**
     * Updates the role of a user by their ID.
     * @param id the ID of the user
     * @param newRole the new role to assign to the user
     * @return the updated user with the new role
     */
    //Only For Admin
    UserDTO updateUserRole(Long id, String newRole);
}
