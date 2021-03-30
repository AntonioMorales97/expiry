package se.expiry.dumbledore.repository.role;

import org.springframework.data.mongodb.repository.MongoRepository;
import se.expiry.dumbledore.domain.Role;

import java.util.Optional;

public interface RoleRepository extends MongoRepository<Role, String>, RoleRepositoryCustom {
    Optional<Role> findByName(String name);
}
