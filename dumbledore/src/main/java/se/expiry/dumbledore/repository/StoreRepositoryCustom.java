package se.expiry.dumbledore.repository;

import com.mongodb.client.result.UpdateResult;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.domain.Product;


import java.util.List;

public interface StoreRepositoryCustom {
    UpdateResult addUserToStores(User user, List<String> stores);
    public UpdateResult addTestData(String storeName, List<Product> products);
    
}
