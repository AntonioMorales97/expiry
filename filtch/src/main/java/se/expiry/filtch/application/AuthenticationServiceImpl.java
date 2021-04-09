package se.expiry.filtch.application;

import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import se.expiry.filtch.common.ExceptionDetail;
import se.expiry.filtch.common.ExpiryException;
import se.expiry.filtch.domain.User;
import se.expiry.filtch.presentation.response.AuthenticationResponseModel;
import se.expiry.filtch.presentation.response.UserDTO;
import se.expiry.filtch.repository.UserRepository;
import se.expiry.filtch.util.JwtTokenUtil;

@Service
@RequiredArgsConstructor
public class AuthenticationServiceImpl implements AuthenticateService{

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;
    private final JwtTokenUtil jwtTokenUtil;

    public AuthenticationResponseModel authenticate(String email, String password){
       User user = userRepository.findByEmail(email).orElseThrow(() -> new ExpiryException(new ExceptionDetail(404, "User does not exists")));

        if(!passwordEncoder.matches(password, user.getPassword())){
            throw new ExpiryException(new ExceptionDetail(403, "Invalid credentials"));
        }

       String token = jwtTokenUtil.createToken(user);

        return new AuthenticationResponseModel(user.getEmail(), user.getFirstName(), user.getLastName(), token);
    }

    @Override
    public UserDTO authorize(String token) {
        Claims claims = jwtTokenUtil.extractAllTokenClaims(token);
        String id = claims.getSubject();
        String email = (String) claims.get("Email");
        User user = userRepository.findById(id).orElseThrow(() -> new ExpiryException(new ExceptionDetail(404, "User does not exists")));

        UserDTO userDTO = new UserDTO(id, email, user.getRoles());

        return userDTO;
    }
}
