package se.expiry.dumbledore.application;

import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.presentation.request.admin.UpdateUserRequestModel;

import java.util.List;

public interface AdminService {
    User addUser(AddUserRequestModel newUser);

    void createTestData(List<String> storeNames);

    Store addStore(String storeName);

    User getUser(String id);

    User updateUser(String id, UpdateUserRequestModel user);

    Product generateRandomProduct();

    void addUserToStore(String storeId, String userId);

    List<Store> getStores();
}
