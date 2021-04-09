package se.expiry.filtch.presentation.response;

import lombok.Data;

@Data
public class AuthenticationResponseModel {
    private String email;
    private String firstName;
    private String lastName;
    private String token;

    public AuthenticationResponseModel(String email, String firstName, String lastName, String token){
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.token = token;
    }
}
