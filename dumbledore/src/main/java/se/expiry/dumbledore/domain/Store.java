package se.expiry.dumbledore.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data
@Document(collection = "store")
public class Store {

    @Id
    private String id;

    @Indexed(unique = true)
    private String name;

    private List<Product> products;


    private List<String> users;

    public Store(String name, List<Product> products, List<String> users){
        this.name = name;
        this.products = products == null ? new ArrayList<>() : products;
        this.users = users == null ? new ArrayList<>() : users;
    }

    public Store(String id){
        this.id = id;
    }

    public Store(){}
}
