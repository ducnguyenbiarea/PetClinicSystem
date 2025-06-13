package com.demo.pet.dtos;

import com.demo.pet.models.Services;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonPropertyOrder({
        "id",
        "service_name",
        "category",
        "description",
        "price"
})
public class ServicesDTO {
    Long id;

    @JsonProperty("service_name")
    String name;

    String category; // dùng String để chuyển enum sang tên

    String description;

    Double price;

    public static ServicesDTO fromEntity(Services services){
        return new ServicesDTO(
                services.getId(),
                services.getName(),
                services.getCategory().name(), // enum to string
                services.getDescription(),
                services.getPrice()
        );
    }
}
