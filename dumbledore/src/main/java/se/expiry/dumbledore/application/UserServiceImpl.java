package se.expiry.dumbledore.application;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.repository.UserRepository;

@Service
@Transactional
@RequiredArgsConstructor
public class UserServiceImpl implements UserService{

    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;

    @Override
    public User changePassword(String id, String email, String password) {
        String hashedPassword = passwordEncoder.encode(password);
       return userRepo.changePassword( id ,email ,hashedPassword);
    }
}
