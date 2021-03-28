package se.expiry.filtch.application;

import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import se.expiry.filtch.domain.User;
import se.expiry.filtch.presentation.response.UserDTO;
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
            throw new RuntimeException("Customer don't exist");
        }
        if( passwordEncoder.matches(password, user.get().getPassword())){
            String token = jwtTokenUtil.createToken(user.get());
            return token;
        }
        else{
            throw new RuntimeException("Password dont match");
        }
    }

    @Override
    public UserDTO authorize(String token) {
        Claims claims = jwtTokenUtil.extractAllTokenClaims(token);
        String id = claims.getSubject();
        String email = (String) claims.get("Email");
        Optional<User> user = userRepository.findById(id);
        if(user.isEmpty()){
            //throw user not found.
        }

        UserDTO userDTO = new UserDTO(id, email, user.get().getRoles());

        return userDTO;
    }
}
