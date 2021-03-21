package se.expiry.dumbledore.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import se.expiry.dumbledore.domain.Store;

import java.util.Optional;

public interface StoreRepository extends MongoRepository<Store, String>, StoreRepositoryCustom{

    Optional<Store> findByName(String name);
}