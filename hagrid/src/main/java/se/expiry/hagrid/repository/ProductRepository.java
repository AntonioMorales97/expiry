package se.expiry.hagrid.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import se.expiry.hagrid.domain.Product;

public interface ProductRepository extends MongoRepository<Product, String>{

    public Product findByDate(String date);
}