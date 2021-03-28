package se.expiry.dumbledore.repository.role;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import se.expiry.dumbledore.domain.Role;

@Repository
public interface RoleRepository extends MongoRepository<Role, String>, RoleRepositoryCustom {

    public Role findByName(String name);
}
