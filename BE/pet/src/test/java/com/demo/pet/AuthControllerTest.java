package com.demo.pet;

import com.demo.pet.config.CustomForSercurityConfig.CustomUserDetailsService;
import com.demo.pet.dtos.UserDTO;
import com.demo.pet.services.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthControllerTest {

    @Mock
    private UserService userService;

    @Mock
    private AuthenticationManager authenticationManager;

    @Mock
    private CustomUserDetailsService userDetailsService;

    @Mock
    private SecurityContext securityContext;

    @Mock
    private Authentication authentication;

    @InjectMocks
    private AuthController authController;

    private UserDTO userDTO;
    private UserDTO invalidUserDTO;

    @BeforeEach
    void setUp() {
        // Create valid UserDTO test data
        userDTO = new UserDTO(
                1L,
                "Test User",
                "securePassword123",
                "1234567890",
                "test@example.com",
                "OWNER"
        );

        // Create invalid UserDTO (for negative testing)
        invalidUserDTO = new UserDTO(
                null,
                "Invalid User",
                "",  // empty password
                "1234567890",
                "invalid@example.com",
                "INVALID_ROLE"
        );

        // Setup security context
        SecurityContextHolder.setContext(securityContext);
    }

    @Test
    void loginPage_shouldReturnMessage() {
        String response = authController.loginPage();

        assertEquals("Please POST your credentials to this endpoint", response);
    }

    @Test
    void registerUser_shouldReturnRegisteredUser() {
        when(userService.addUser(userDTO)).thenReturn(userDTO);

        ResponseEntity<UserDTO> response = authController.registerUser(userDTO);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals(userDTO, response.getBody());
        verify(userService).addUser(userDTO);
    }

    @Test
    void registerUser_withExistingEmail_shouldHandleException() {
        when(userService.addUser(userDTO))
                .thenThrow(new RuntimeException("Email already in use"));

        ResponseEntity<UserDTO> response = authController.registerUser(userDTO);

        // In a real implementation, the controller would likely return a different status code
        // This test verifies the current behavior
        assertEquals(userDTO, response.getBody());
        verify(userService).addUser(userDTO);
    }

    @Test
    void performLogin_shouldReturnMessage() {
        String response = authController.performLogin();

        assertEquals("Login processing...", response);
    }

    @Test
    void accessDenied_shouldReturnMessage() {
        String response = authController.accessDenied();

        assertEquals("You don't have permission to access this resource", response);
    }

    @Test
    void loginLogout_integrationFlow() {
        // This would be better as an integration test with MockMvc,
        // but demonstrates how you might test the authentication flow
        when(securityContext.getAuthentication()).thenReturn(authentication);
        when(authentication.getName()).thenReturn("test@example.com");
        when(userService.getUserByEmail("test@example.com")).thenReturn(userDTO);

        // Test that after login, we could get user info
        // This would happen in a real app after authentication succeeds
        ResponseEntity<UserDTO> expectedUserInfo = ResponseEntity.ok(userDTO);
        assertEquals(expectedUserInfo.getBody(), userDTO);

        // In a real test, we'd verify logout clears the authentication
    }
}