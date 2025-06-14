package com.demo.pet;

import com.demo.pet.dtos.UserDTO;
import com.demo.pet.dtos.subDTO.UserRoleDTO;
import com.demo.pet.services.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserControllerTest {

    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    private UserDTO userDTO;
    private UserRoleDTO userRoleDTO;

    @BeforeEach
    void setUp() {
        // Create UserDTO with all required parameters
        userDTO = new UserDTO(1L, "Test User", "test@example.com", "1234567890", "password", "USER");
        userRoleDTO = new UserRoleDTO(1L, "OWNER");
    }

    @Test
    void getAllUsers_shouldReturnList() {
        when(userService.getAllUsers()).thenReturn(Arrays.asList(userDTO));
        ResponseEntity<List<UserDTO>> response = userController.getAllUsers();
        assertEquals(1, response.getBody().size());
        verify(userService).getAllUsers();
    }

    @Test
    void getUserById_shouldReturnUser() {
        when(userService.getUserById(1L)).thenReturn(userDTO);
        ResponseEntity<UserDTO> response = userController.getUserById(1L);
        assertEquals(userDTO, response.getBody());
        verify(userService).getUserById(1L);
    }

    @Test
    void getUserByEmail_shouldReturnUser() {
        when(userService.getUserByEmail("test@example.com")).thenReturn(userDTO);
        ResponseEntity<UserDTO> response = userController.getUserByEmail("test@example.com");
        assertEquals(userDTO, response.getBody());
        verify(userService).getUserByEmail("test@example.com");
    }

    @Test
    void createUser_shouldReturnCreatedUser() {
        when(userService.addUser(userDTO)).thenReturn(userDTO);
        ResponseEntity<UserDTO> response = userController.createUser(userDTO);
        assertEquals(userDTO, response.getBody());
        verify(userService).addUser(userDTO);
    }

    @Test
    void updateUser_shouldReturnUpdatedUser() {
        when(userService.updateUser(1L, userDTO)).thenReturn(userDTO);
        ResponseEntity<UserDTO> response = userController.updateUser(1L, userDTO);
        assertEquals(userDTO, response.getBody());
        verify(userService).updateUser(1L, userDTO);
    }

    @Test
    void deleteUser_shouldReturnDeletedUser() {
        when(userService.deleteUser(1L)).thenReturn(userDTO);
        ResponseEntity<UserDTO> response = userController.deleteUser(1L);
        assertEquals(userDTO, response.getBody());
        verify(userService).deleteUser(1L);
    }

    @Test
    void getMyInfo_shouldReturnCurrentUser() {
        when(userService.getMyInfo()).thenReturn(userDTO);
        ResponseEntity<UserDTO> response = userController.getMyInfo();
        assertEquals(userDTO, response.getBody());
        verify(userService).getMyInfo();
    }

    @Test
    void getUserRole_shouldReturnRole() {
        when(userService.getUserRole(1L)).thenReturn(userRoleDTO);
        ResponseEntity<UserRoleDTO> response = userController.getUserRole(1L);
        assertEquals(userRoleDTO, response.getBody());
        verify(userService).getUserRole(1L);
    }

    @Test
    void updateUserRole_shouldReturnUpdatedUser() {
        when(userService.updateUserRole(1L, "ADMIN")).thenReturn(userDTO);
        ResponseEntity<UserDTO> response = userController.updateUserRole(1L, "ADMIN");
        assertEquals(userDTO, response.getBody());
        verify(userService).updateUserRole(1L, "ADMIN");
    }
}