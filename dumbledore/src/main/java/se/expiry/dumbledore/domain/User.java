package se.expiry.dumbledore.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Data
@Document
public class User {
    @Id
    private String id;

    private String firstName;

    private String lastName;

    @Indexed(unique = true)
    private String email;

    private String password;

    private List<Role> roles;

    public User(String firstName, String lastName, String email, String password, List<Role> roles) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.roles = roles;
    }

    public Map<String, Object> toMap(){
        Map<String, Object> objectMap = new HashMap<>();
        objectMap.put("email", this.email);
        objectMap.put("firstName", this.firstName);
        objectMap.put("lastName", this.lastName);
        objectMap.put("password", this.password);
        objectMap.put("roles", this.roles);
        return objectMap;
    }
}
