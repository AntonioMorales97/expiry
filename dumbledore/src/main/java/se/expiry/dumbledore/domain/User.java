package se.expiry.dumbledore.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
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

    @DBRef
    private List<Role> roles;

    @DBRef
    private List<Store> stores;

    private Preference preference;

    public User(String firstName, String lastName, String email, String password, List<Role> roles, List<Store> stores, Preference preference) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.roles = roles;
        this.stores = stores;
        this.preference=preference;
    }
    public User(String firstName, String lastName, String email, String password, List<Role> roles, List<Store> stores) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.roles = roles;
        this.stores = stores;

    }

    public User(String firstName, String lastName, String email, String password, List<Role> roles) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.roles = roles;
        this.stores = new ArrayList<>();
    }

    public User(){}

    public User(String id){
        this.id=id;
    }

    public Map<String, Object> toMap(){
        Map<String, Object> objectMap = new HashMap<>();
        objectMap.put("email", this.email);
        objectMap.put("firstName", this.firstName);
        objectMap.put("lastName", this.lastName);
        objectMap.put("password", this.password);
        objectMap.put("roles", this.roles);
        objectMap.put("stores", this.stores);
        return objectMap;
    }
}
