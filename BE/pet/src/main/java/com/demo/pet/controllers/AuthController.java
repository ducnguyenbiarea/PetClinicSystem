package com.demo.pet.controllers;

import com.demo.pet.dtos.UserDTO;
import com.demo.pet.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;

    @GetMapping("/login")
    public String loginPage() {
        return "Please POST your credentials to this endpoint";
    }

    @PostMapping("/register")
    public ResponseEntity<UserDTO> registerUser(@RequestBody UserDTO userDTO) {
        return ResponseEntity.ok(userService.addUser(userDTO));
    }

    @PostMapping("/login")
    public String performLogin() {
        // Spring Security sẽ tự động xử lý đăng nhập
        return "Login processing...";
    }

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "You don't have permission to access this resource";
    }
}
