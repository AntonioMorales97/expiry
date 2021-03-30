package se.expiry.dumbledore.repository.user;

import se.expiry.dumbledore.domain.User;

public interface UserRepositoryCustom {
   User changePassword(String id, String email, String hashedPassword);
   User updateUser(String id, User user);
}