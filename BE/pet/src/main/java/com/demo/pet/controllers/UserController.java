package com.demo.pet.controllers;

import com.demo.pet.dtos.UserDTO;
import com.demo.pet.dtos.subDTO.UserRoleDTO;
import com.demo.pet.models.User;
import com.demo.pet.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

/**
 * REST controller for managing user-related operations in the Pet Clinic system.
 * <p>
 * Exposes endpoints for user CRUD operations, role management, and user information retrieval.
 * </p>
 * <p>
 *     See info about Controllers Overview: <a href="../../../../custom-docs/ControllerOverview.html" target="_blank">Controllers Overview</a>
 * </p>
 * <p>
 *     See info about Controller Annotations: <a href="../../../../custom-docs/ControllerAnnotation.html" target="_blank">Controller Annotation</a>
 * </p>
 *
 * @see com.demo.pet.services.UserService
 * @see com.demo.pet.dtos.UserDTO
 * @since 1.0
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/users")
public class UserController {
    private final UserService userService;

    /**
     * Endpoint to get all users.
     * Accessible by users with ADMIN or STAFF roles.
     *
     * @return List of UserDTO objects representing all users.
     */
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    @GetMapping("")
    public ResponseEntity<List<UserDTO>> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    /**
     * Endpoint to get a user by their ID.
     *
     * @param id The ID of the user to retrieve.
     * @return UserDTO object representing the user with the specified ID.
     */
    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Long id) {
        return ResponseEntity.ok(userService.getUserById(id));
    }

    /**
     * Endpoint to get a user by their email.
     *
     * @param email The email of the user to retrieve.
     * @return UserDTO object representing the user with the specified email.
     */
    @GetMapping("/email/{email}")
    public ResponseEntity<UserDTO> getUserByEmail(@PathVariable String email) {
        return ResponseEntity.ok(userService.getUserByEmail(email));
    }

    /**
     * Endpoint to create a new user.
     * Accessible by users with ADMIN or STAFF roles.
     *
     * @param userDTO The UserDTO object containing user details.
     * @return UserDTO object representing the created user.
     */
    @PostMapping("")
    public ResponseEntity<UserDTO> createUser(@RequestBody UserDTO userDTO) {
        return ResponseEntity.ok(userService.addUser(userDTO));
    }

    /**
     * Endpoint to update an existing user.
     *
     * @param id The ID of the user to update.
     * @param userDTO The UserDTO object containing updated user details.
     * @return UserDTO object representing the updated user.
     */
    @PutMapping("/{id}")
    public ResponseEntity<UserDTO> updateUser(
            @PathVariable Long id,
            @RequestBody UserDTO userDTO) {
        return ResponseEntity.ok(userService.updateUser(id, userDTO));
    }

    /**
     * Endpoint to delete a user by their ID.
     *
     * @param id The ID of the user to delete.
     * @return UserDTO object representing the deleted user.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<UserDTO> deleteUser(@PathVariable Long id) {
        return ResponseEntity.ok(userService.deleteUser(id));
    }

    /**
     * Endpoint to get the currently authenticated user's information.
     *
     * @return UserDTO object representing the current user's information.
     */
    @GetMapping("/my-info")
    public ResponseEntity<UserDTO> getMyInfo() {
        return ResponseEntity.ok(userService.getMyInfo());
    }

    /**
     * Endpoint to get the role of a user by their ID.
     *
     * @param id The ID of the user whose role is to be retrieved.
     * @return UserRoleDTO object representing the user's role.
     */
    @GetMapping("/{id}/role")
    public ResponseEntity<UserRoleDTO> getUserRole(@PathVariable Long id) {
        return ResponseEntity.ok(userService.getUserRole(id));
    }

    /**
     * Endpoint to update the role of a user.
     * Accessible only by users with ADMIN role.
     *
     * @param id The ID of the user whose role is to be updated.
     * @param newRole The new role to assign to the user.
     * @return UserDTO object representing the user with the updated role.
     */
    //Only for admin
    @PreAuthorize("hasRole('ADMIN')")
    @PatchMapping("/{id}/role")
    public ResponseEntity<UserDTO> updateUserRole(
            @PathVariable Long id,
            @RequestParam String newRole) {
        return ResponseEntity.ok(userService.updateUserRole(id, newRole));
    }
}
