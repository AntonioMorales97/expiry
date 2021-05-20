package se.expiry.dumbledore.presentation.request.admin;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.Data;
import se.expiry.dumbledore.util.FieldMatch;
import se.expiry.dumbledore.util.ToLowerCaseConverter;

import javax.validation.constraints.NotNull;
import java.util.List;

@FieldMatch(first = "password", second = "rePassword", message = "Passwords do not match!")
@Data
public class AddUserRequestModel {

    @NotNull(message = "First name cannot be null")
    private String firstName;

    @NotNull(message = "Last name cannot be null")
    private String lastName;

    @JsonDeserialize(converter = ToLowerCaseConverter.class)
    @NotNull(message = "Email cannot be null")
    private String email;

    @NotNull(message = "Please enter password")
    private String password;

    @NotNull(message = "Please re-enter password")
    private String rePassword;

    public List<String> storeIds;

    public List<String> roleIds;

    public AddUserRequestModel() {
    }
}
