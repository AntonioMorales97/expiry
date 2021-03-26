package se.expiry.filtch.presentation.response;

import lombok.Data;

@Data
public class UserDTO {
    String id;
    String email;


    public UserDTO(String id, String email) {
        this.email = email;
        this.id = id;
    }
}
