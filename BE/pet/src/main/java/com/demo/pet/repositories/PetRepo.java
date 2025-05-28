package com.demo.pet.repositories;

import com.demo.pet.models.Pet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PetRepo extends JpaRepository<Pet, Long> {
    List<Pet> findByUserId(Long userId);
}
