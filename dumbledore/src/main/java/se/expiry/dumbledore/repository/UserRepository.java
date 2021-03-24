package se.expiry.dumbledore.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import se.expiry.dumbledore.domain.User;


import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String>, UserRepositoryCustom {

    Optional<User> findById(String name);
    Optional<User> findByEmail(String email);

}
