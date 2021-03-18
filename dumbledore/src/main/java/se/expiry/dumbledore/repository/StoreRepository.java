package se.expiry.dumbledore.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import se.expiry.dumbledore.domain.Store;


public interface StoreRepository extends MongoRepository<Store, String>{

    @Query(value = "{ 'name': ?0 }")
    public Store getStore(String name);
}