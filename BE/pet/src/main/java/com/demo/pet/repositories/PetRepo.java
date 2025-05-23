package com.demo.pet.repositories;

import com.demo.pet.models.Pet;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PetRepo extends JpaRepository<Pet, Long> {
}
