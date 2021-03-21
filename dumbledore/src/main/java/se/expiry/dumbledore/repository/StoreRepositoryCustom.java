package se.expiry.dumbledore.repository;

import com.mongodb.client.result.UpdateResult;
import se.expiry.dumbledore.domain.User;

import java.util.List;

public interface StoreRepositoryCustom {
    UpdateResult addUserToStores(User user, List<String> stores);
}
