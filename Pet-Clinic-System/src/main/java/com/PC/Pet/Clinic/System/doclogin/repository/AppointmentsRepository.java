package com.PC.Pet.Clinic.System.doclogin.repository;
import com.PC.Pet.Clinic.System.doclogin.entity.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AppointmentsRepository extends JpaRepository<Appointment, Long>{

}
