package com.demo.pet.config;

import com.demo.pet.config.CustomForSercurityConfig.*;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor // Lombok để inject dependencies
@EnableMethodSecurity
public class SecurityConfig{
    private final CustomUserDetailsService userDetailsService;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Tắt CSRF cho API (có thể bật lại nếu cần)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/static/**", "/public/**").permitAll()
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/api/services/**").authenticated()
                        .requestMatchers("/api/pets/**").authenticated()
                        .requestMatchers("/api/cages/**").authenticated()
                        .requestMatchers("/api/records/**").authenticated()
                        .requestMatchers("/api/users/**").authenticated()
                        .requestMatchers("/api/bookings/**").authenticated()
                        .anyRequest().authenticated()
                )
                .cors(Customizer.withDefaults()) // <-- Cho phép xử lý CORS
                .userDetailsService(userDetailsService) // Sử dụng custom UserDetailsService
                .formLogin(form -> form
                        .loginPage("/api/auth/login") // Custom login endpoint
                        .successHandler(new JsonAuthenticationSuccessHandler()) // Trả về JSON khi login thành công
                        .failureHandler(new JsonAuthenticationFailureHandler())
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/api/auth/logout")
                        .logoutSuccessHandler(new CustomLogoutSuccessHandler())
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                )
                .exceptionHandling(exception -> exception
                        .accessDeniedHandler(new CustomAccessDeniedHandler())
                        .authenticationEntryPoint(new CustomAuthenticationEntryPoint())
                );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(10);
    }
}