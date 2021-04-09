package se.expiry.filtch.application;

import se.expiry.filtch.presentation.response.AuthenticationResponseModel;
import se.expiry.filtch.presentation.response.UserDTO;

public interface AuthenticateService {
    public AuthenticationResponseModel authenticate(String email, String password);
    public UserDTO authorize(String token);
}
