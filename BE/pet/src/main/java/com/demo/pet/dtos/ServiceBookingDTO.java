package com.demo.pet.dtos;

import com.demo.pet.models.ServiceBooking;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonPropertyOrder({
        "id",
        "start_date",
        "end_date",
        "notes",
        "user_id",
        "service_id"
})
public class ServiceBookingDTO {
    Long id;

    @JsonProperty("start_date")
    LocalDate startDate;

    @JsonProperty("end_date")
    LocalDate endDate;

    String notes;

    @JsonProperty("user_id")
    Long userId;

    @JsonProperty("service_id")
    Long serviceId;

    public static ServiceBookingDTO fromEntity(ServiceBooking serviceBooking) {
        return new ServiceBookingDTO(
                serviceBooking.getId(),
                serviceBooking.getStartDate(),
                serviceBooking.getEndDate(),
                serviceBooking.getNotes(),
                serviceBooking.getUser().getId(),
                serviceBooking.getServices().getId()
        );
    }
}
