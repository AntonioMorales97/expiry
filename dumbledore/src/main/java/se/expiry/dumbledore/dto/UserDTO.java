package se.expiry.dumbledore.dto;

import lombok.Data;
import se.expiry.dumbledore.domain.Role;


import java.util.List;

@Data
public class UserDTO {
    private String id;
    private String email;
    private List<Role> roles;

    public UserDTO(){
    }
}
