package se.expiry.dumbledore.repository;

import com.mongodb.client.result.UpdateResult;
import se.expiry.dumbledore.domain.User;

public interface UserRepositoryCustom {
   User changePassword(String id, String email, String hashedPassword);
   User updateUser(String email, User user);
}
