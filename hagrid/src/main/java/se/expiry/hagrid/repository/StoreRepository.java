package se.expiry.hagrid.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import se.expiry.hagrid.domain.Store;


public interface StoreRepository extends MongoRepository<Store, String>{

  
    public Store findByName(String name);
}