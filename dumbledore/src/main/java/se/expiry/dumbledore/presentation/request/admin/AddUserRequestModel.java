package se.expiry.dumbledore.presentation.request.admin;

import lombok.Data;
import se.expiry.dumbledore.util.FieldMatch;

import javax.validation.constraints.NotNull;
import java.util.List;

@FieldMatch(first = "password", second = "rePassword", message = "Passwords do not match!")
@Data
public class AddUserRequestModel {

    @NotNull(message = "First name cannot be null")
    private String firstName;

    @NotNull(message = "Last name cannot be null")
    private String lastName;

    @NotNull(message = "Email cannot be null")
    private String email;

    @NotNull(message = "Please enter password")
    private String password;

    @NotNull(message = "Please re-enter password")
    private String rePassword;

    public List<String> stores;

    public AddUserRequestModel() {
    }
}
