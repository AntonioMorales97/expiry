package se.expiry.filtch.presentation.response;

import lombok.Data;
import se.expiry.filtch.domain.Role;

import java.util.List;

@Data
public class UserDTO {
    String id;
    String email;
    List<Role> roles;


    public UserDTO(String id, String email, List<Role> roles) {
        this.email = email;
        this.id = id;
        this.roles = roles;

    }
}
