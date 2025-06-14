package com.demo.pet.repositories;

import com.demo.pet.models.Services;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ServiceRepo extends JpaRepository<Services, Long> {
    @Override
    List<Services> findAll();
}
