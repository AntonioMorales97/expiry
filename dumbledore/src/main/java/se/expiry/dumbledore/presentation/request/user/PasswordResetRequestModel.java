package se.expiry.dumbledore.presentation.request.user;

import lombok.Data;
import se.expiry.dumbledore.util.AtLeastOneNotNull;
import se.expiry.dumbledore.util.FieldMatch;

import javax.validation.constraints.NotNull;

@Data
@FieldMatch(first = "password", second = "rePassword", message = "Passwords do not match.")
public class PasswordResetRequestModel {
    @NotNull(message = "Please enter your email")
    private String email;
    @NotNull(message = "Please enter your old password")
    private String oldPassword;
    @NotNull(message = "Please enter password")
    private String password;

    @NotNull(message = "Please re-enter password")
    private String rePassword;

    public PasswordResetRequestModel() {
    }
}
