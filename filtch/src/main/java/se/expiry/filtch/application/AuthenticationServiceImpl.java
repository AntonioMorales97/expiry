package se.expiry.filtch.application;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import se.expiry.filtch.domain.User;
import se.expiry.filtch.repository.UserRepository;
import se.expiry.filtch.util.JwtTokenUtil;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthenticationServiceImpl implements AuthenticateService{

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;
    private final JwtTokenUtil jwtTokenUtil;

    public String authenticateCredentials(String email, String password){

        Optional<User> user = userRepository.findByEmail(email);
        if(user.isEmpty()){
            System.out.println("hej");
        }
        if( passwordEncoder.matches(password, user.get().getPassword())){
            String token = jwtTokenUtil.createToken(user.get());
            return token;
        }
        return null;
    }

    @Override
    public String authorize(String token) {
        String id = jwtTokenUtil.getTokenUserId(token);
        return id;
    }
}
