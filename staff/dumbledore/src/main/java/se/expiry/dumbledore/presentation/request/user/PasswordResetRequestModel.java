package se.expiry.dumbledore.presentation.request.user;

import lombok.Data;
import se.expiry.dumbledore.util.AtleastOneNotNull;
import se.expiry.dumbledore.util.FieldMatch;

import javax.validation.constraints.NotNull;
@Data
@AtleastOneNotNull(first = "email", second = "id", message = "Requires atleast one of the two fields: firstname or id")
@FieldMatch(first = "password", second = "rePassword", message = "Passwords do not match!")
public class PasswordResetRequestModel {

    private String id;

    private String email;
    @NotNull(message = "Please enter password")
    private String password;

    @NotNull(message = "Please re-enter password")
    private String rePassword;

    public PasswordResetRequestModel() {
    }
}
