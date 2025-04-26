package com.PC.Pet.Clinic.System.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.PC.Pet.Clinic.System.entity.Pet;

@Repository
public interface PetRepository extends JpaRepository<Pet, Long> {
	
}
