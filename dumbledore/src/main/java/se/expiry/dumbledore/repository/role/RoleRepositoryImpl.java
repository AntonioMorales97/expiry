package se.expiry.dumbledore.repository.role;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import se.expiry.dumbledore.domain.Role;

import java.util.List;

public class RoleRepositoryImpl implements RoleRepositoryCustom{

    private MongoTemplate mongoTemplate;

    public RoleRepositoryImpl(MongoTemplate mongoTemplate){
        this.mongoTemplate = mongoTemplate;
    }

    @Override
    public List<Role> getMatchingRolesForIds(List<String> roleIds) {
        Query query = new Query(Criteria.where("_id").in(roleIds));
        return mongoTemplate.find(query, Role.class);
    }
}
