package com.demo.pet.repositories;

import com.demo.pet.models.Cage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CageRepo extends JpaRepository<Cage, Long> {
    Optional<Cage> findByPetId(Long petId);
}
