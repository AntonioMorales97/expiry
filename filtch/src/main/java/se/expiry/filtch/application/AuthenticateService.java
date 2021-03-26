package se.expiry.filtch.application;

import se.expiry.filtch.presentation.response.UserDTO;

public interface AuthenticateService {
    public String authenticateCredentials(String email, String password);
    public UserDTO authorize(String token);
}
