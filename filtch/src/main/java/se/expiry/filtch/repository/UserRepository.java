package se.expiry.filtch.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import se.expiry.filtch.domain.User;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByEmail(String email);

    Optional<User> findById(String id);
}
