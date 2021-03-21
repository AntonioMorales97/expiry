package se.expiry.dumbledore.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;

import java.util.List;

public interface UserRepository extends MongoRepository<User, String> {
}
