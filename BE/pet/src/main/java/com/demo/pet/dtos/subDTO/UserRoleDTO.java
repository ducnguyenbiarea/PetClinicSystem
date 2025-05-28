package com.demo.pet.dtos.subDTO;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserRoleDTO {
    private Long id;
    private String roles;
}
