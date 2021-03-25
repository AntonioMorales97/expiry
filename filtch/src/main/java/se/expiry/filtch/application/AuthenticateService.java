package se.expiry.filtch.application;

public interface AuthenticateService {
    public String authenticateCredentials(String email, String password);
    public String authorize(String token);
}
