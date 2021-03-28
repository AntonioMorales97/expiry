package se.expiry.dumbledore.presentation.request.admin;

import lombok.Data;
import se.expiry.dumbledore.util.FieldMatch;

@FieldMatch(first = "password", second = "rePassword", message = "Passwords do not match!")
@Data
public class UpdateUserRequestModel {

    private String email;
    private String newEmail;
    private String firstName;
    private String lastName;
    private String password;
    private String rePassword;

    public UpdateUserRequestModel() {
    }

}
