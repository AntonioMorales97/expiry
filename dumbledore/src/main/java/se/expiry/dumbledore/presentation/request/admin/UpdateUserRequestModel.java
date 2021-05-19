package se.expiry.dumbledore.presentation.request.admin;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.Data;
import se.expiry.dumbledore.util.FieldMatch;
import se.expiry.dumbledore.util.ToLowerCaseConverter;

import java.util.List;

@FieldMatch(first = "password", second = "rePassword", message = "Passwords do not match!")
@Data
public class UpdateUserRequestModel {

    private String email;

    @JsonDeserialize(converter = ToLowerCaseConverter.class)
    private String newEmail;
    private String firstName;
    private String lastName;
    private String password;
    private String rePassword;
    private List<String> roleIds;

    public UpdateUserRequestModel() {
    }

}
