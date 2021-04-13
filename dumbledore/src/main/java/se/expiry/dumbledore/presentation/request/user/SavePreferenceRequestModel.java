package se.expiry.dumbledore.presentation.request.user;

import lombok.Data;
import se.expiry.dumbledore.util.AtLeastOneNotNull;
import se.expiry.dumbledore.util.FieldMatch;

import javax.validation.constraints.NotNull;
@Data
public class SavePreferenceRequestModel {

    @NotNull(message = "Please enter sort method")
    private int sort;
    @NotNull(message = "Please enter Reverse")
    private boolean reverse;



    public SavePreferenceRequestModel() {
    }
}



