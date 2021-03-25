package se.expiry.hagrid.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import se.expiry.dumbledore.domain.Store;

public interface StoreRepository extends MongoRepository<Store, String>{

  
    public Store findByName(String name);
}