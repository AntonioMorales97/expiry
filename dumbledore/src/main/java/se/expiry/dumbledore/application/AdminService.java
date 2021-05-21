package se.expiry.dumbledore.application;

import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.presentation.request.admin.UpdateUserRequestModel;

import java.util.List;

public interface AdminService {
    User addUser(AddUserRequestModel newUser);

    Store addStore(String storeName);

    User getUser(String id);

    List<User> getUsers();

    User updateUser(String id, UpdateUserRequestModel user);

    void addUserToStore(String storeId, String userId);

    List<Store> getStores();

    void removeUserFromStore(String storeId, String userId);

    Store updateStore(String storeId, String newName);

    void deleteStore(String storeId, String userId);
}
