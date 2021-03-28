package se.expiry.dumbledore.repository;

import lombok.RequiredArgsConstructor;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import se.expiry.dumbledore.domain.User;

import java.util.Map;
import java.util.Objects;

@RequiredArgsConstructor
public class UserRepositoryImpl implements  UserRepositoryCustom{

    private final MongoTemplate mongoTemplate;

    @Override
    public User changePassword(String id, String email, String hashedPassword) {
        Query query;
        if(id != null) {
            query = new Query(Criteria.where("_id").is(id));
        }
        else{
            query = new Query(Criteria.where("email").is(email));
        }
        Update update = new Update();
        update.set("password",hashedPassword);
        return mongoTemplate.findAndModify(query, update, User.class);
    }

    @Override
    public User updateUser(String id, User user) {
        Map<String, Object> objectMap = user.toMap();
        objectMap.values().removeIf(Objects::isNull);
        Update update = new Update();
        objectMap.forEach(update::set);
        Query query = new Query(Criteria.where("_id").is(id));
        return mongoTemplate.findAndModify(query, update, User.class);
    }


}
