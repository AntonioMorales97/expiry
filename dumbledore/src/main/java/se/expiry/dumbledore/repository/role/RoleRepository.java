package se.expiry.dumbledore.repository.role;

import org.springframework.data.mongodb.repository.MongoRepository;
import se.expiry.dumbledore.domain.Role;

public interface RoleRepository extends MongoRepository<Role, String>, RoleRepositoryCustom {
    Role findByName(String name);
}
