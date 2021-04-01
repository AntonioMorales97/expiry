package se.expiry.filtch.presentation.response;

import lombok.Data;

@Data
public class ValidateResponseModel {
    String token;

    public ValidateResponseModel(String token){
        this.token = token;
    }
}
