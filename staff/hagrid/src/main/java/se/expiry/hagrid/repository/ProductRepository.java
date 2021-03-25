package se.expiry.hagrid.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import se.expiry.dumbledore.domain.Product;

public interface ProductRepository extends MongoRepository<Product, String>{

    public Product findByDate(String date);
}