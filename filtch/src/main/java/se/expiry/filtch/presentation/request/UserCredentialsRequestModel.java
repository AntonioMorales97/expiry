package se.expiry.filtch.presentation.request;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.Data;
import se.expiry.filtch.util.ToLowerCaseConverter;

import javax.validation.constraints.NotNull;

@Data
public class UserCredentialsRequestModel {

    @JsonDeserialize(converter = ToLowerCaseConverter.class)
    @NotNull(message = "Please enter Email")
    private String email;
    @NotNull(message = "Please enter password")
    private String password;


    public UserCredentialsRequestModel() {
    }
}
