package se.expiry.dumbledore.presentation.request.admin;

import lombok.Data;
import se.expiry.dumbledore.util.FieldMatch;

import javax.validation.constraints.NotNull;
import java.util.List;
import se.expiry.dumbledore.util.AtleastOneNotNull;

@AtleastOneNotNull(first = "email", second = "id", message = "Requires atleast one of the two fields: firstname or id")
@FieldMatch(first = "password", second = "rePassword", message = "Passwords do not match!")
@Data
public class UpdateUserRequestModel {
        
    
    private String id;
    private String email;

    private String firstName;
    private String lastName;

    private String password;
    private String rePassword;




    public UpdateUserRequestModel() {
    }
}
