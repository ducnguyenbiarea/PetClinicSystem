package com.demo.pet.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class Cors implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**") // Allow all endpoints
                .allowedOrigins(
                    "http://localhost:3000",   // Flutter web default
                    "http://localhost:5173",   // Vite default
                    "http://localhost:8080",   // Backend port
                    "http://localhost:8081",   // Alternative port
                    "http://localhost:4200",   // Angular default
                    "http://127.0.0.1:3000",   // Alternative localhost
                    "http://127.0.0.1:5173",   // Alternative localhost
                    "http://127.0.0.1:8080"    // Alternative localhost
                )
                .allowedMethods("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true); // Allow sending cookies (important for session-based auth)
    }
}
