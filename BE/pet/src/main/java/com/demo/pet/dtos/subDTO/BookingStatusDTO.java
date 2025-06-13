package com.demo.pet.dtos.subDTO;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class BookingStatusDTO {
    private Long id;
    private String status;
}
