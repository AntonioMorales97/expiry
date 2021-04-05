package se.expiry.dumbledore.repository.user;

import com.mongodb.client.result.UpdateResult;
import se.expiry.dumbledore.domain.User;

public interface UserRepositoryCustom {
   User changePassword(String id, String email, String hashedPassword);
   User updateUser(String id, User user);
   UpdateResult removeStoreFromUser(String userId, String storeId);
}
