package se.expiry.dumbledore.repository;

import com.mongodb.client.result.UpdateResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.domain.Product;

import java.util.List;


public class StoreRepositoryImpl implements  StoreRepositoryCustom{

    @Autowired
    protected MongoTemplate mongoTemplate;

    @Override
    public UpdateResult addUserToStores(User user, List<String> storeNames) {
        Query query = new Query(Criteria.where("name").in(storeNames));
        Update update = new Update();
        update.push("users").value(user);
        return mongoTemplate.updateMulti(query, update, Store.class);
    }
    @Override
    public UpdateResult addProductsToStore(String storeName, List<Product> products){
        Query query = new Query(Criteria.where("name").is(storeName));
        Update update = new Update();        
        update.push("products").each(products);
        update.setOnInsert("name", storeName);
        return mongoTemplate.upsert(query, update, Store.class);
    }

   
}
