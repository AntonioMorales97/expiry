package se.expiry.dumbledore.dto;

import lombok.Data;

@Data
public class UserDTO {
    private String id;
    private String email;

    public UserDTO(){
    }
}
