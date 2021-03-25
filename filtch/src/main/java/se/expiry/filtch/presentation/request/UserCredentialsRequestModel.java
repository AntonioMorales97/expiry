package se.expiry.filtch.presentation.request;

import lombok.Data;

import javax.validation.constraints.NotNull;

@Data
public class UserCredentialsRequestModel {
    @NotNull(message = "Please enter Email")
    private String email;
    @NotNull(message = "Please enter password")
    private String password;


    public UserCredentialsRequestModel() {
    }
}
