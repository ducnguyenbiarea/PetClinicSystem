package com.PC.Pet.Clinic.System.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.management.AttributeNotFoundException;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.PC.Pet.Clinic.System.entity.Pet;
import com.PC.Pet.Clinic.System.repository.PetRepository;

@CrossOrigin(origins = "http://localhost:4200")
@RestController
@RequestMapping("/api/v1")
public class PetController {
	
	private PetRepository petRepository;

	public PetController(PetRepository petRepository) {
		super();
		this.petRepository = petRepository;
	}
	
	@PostMapping("/pet")
	public Pet createPet(@RequestBody Pet pet) {
		return petRepository.save(pet);
	}
	
	@GetMapping("/pets")
	public List<Pet>getAllPet(){
		return petRepository.findAll();
	}
	
	@DeleteMapping("/pets/{id}")
	public ResponseEntity<Map<String, Boolean>>deletePet(@PathVariable long id) throws AttributeNotFoundException{
		Pet pet = petRepository.findById(id).orElseThrow(() -> new AttributeNotFoundException("Khong tim thay thu cung voi id!" +id));
		petRepository.delete(pet);
		Map<String, Boolean> response = new HashMap<String, Boolean>();
		response.put("Deleted", Boolean.TRUE);
		return ResponseEntity.ok(response);
	}
	
	@PutMapping("/pets/{id}")
	public ResponseEntity<Pet> updatePetById(@PathVariable long id, @RequestBody Pet petDetails) throws AttributeNotFoundException{
		Pet pet = petRepository.findById(id).orElseThrow(() -> new AttributeNotFoundException("Khong tim thay thu cung voi id!" +id));
		pet.setId(petDetails.getId());
		pet.setAge(petDetails.getAge());
		pet.setName(petDetails.getName());
		pet.setStatus(petDetails.getStatus());
		pet.setService(petDetails.getService());
		pet.setFees(petDetails.getFees());
		
		Pet savedPet = petRepository.save(pet);
		
		return ResponseEntity.ok(savedPet);

	}
}
