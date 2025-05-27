package com.demo.pet.config.CustomForSercurityConfig;

import com.demo.pet.models.User;
import com.demo.pet.repositories.UserRepo;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepo userRepository;

    public CustomUserDetailsService(UserRepo userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        // Kiểm tra role và thêm prefix "ROLE_" nếu cần
        String roleName = user.getRoles().name();
        String authority = roleName.startsWith("ROLE_") ? roleName : "ROLE_" + roleName;

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassWord())
                .authorities(authority) // Sử dụng .authorities() thay vì .roles()
                .build();
    }
}
