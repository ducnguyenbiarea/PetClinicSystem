package com.demo.pet.controllers;

import com.demo.pet.dtos.UserDTO;
import com.demo.pet.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * REST controller for authentication and registration operations in the Pet Clinic system.
 * <p>
 * Exposes endpoints for user login, registration, and access-denied handling.
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
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;

    /**
     * Endpoint to display a message for the login page.
     * <p>
     * This endpoint is used to inform users that they should POST their credentials
     * to the login endpoint.
     * </p>
     *
     * @return A message indicating how to log in.
     */
    @GetMapping("/login")
    public String loginPage() {
        return "Please POST your credentials to this endpoint";
    }

    /**
     * Endpoint to register a new user.
     * <p>
     * This endpoint allows users to create a new account by providing their details.
     * </p>
     *
     * @param userDTO The data transfer object containing user information.
     * @return The created UserDTO object.
     */
    @PostMapping("/register")
    public ResponseEntity<UserDTO> registerUser(@RequestBody UserDTO userDTO) {
        return ResponseEntity.ok(userService.addUser(userDTO));
    }

    /**
     * Endpoint to handle user login.
     * <p>
     * This endpoint is used to process user login requests. Spring Security will
     * automatically handle the authentication process.
     * </p>
     *
     * @return A message indicating that login processing is underway.
     */
    @PostMapping("/login")
    public String performLogin() {
        // Spring Security sẽ tự động xử lý đăng nhập
        return "Login processing...";
    }

    /**
     * Endpoint to handle access denied scenarios.
     * <p>
     * This endpoint is called when a user tries to access a resource they are not
     * authorized to access.
     * </p>
     *
     * @return A message indicating that access is denied.
     */
    @GetMapping("/access-denied")
    public String accessDenied() {
        return "You don't have permission to access this resource";
    }
}
