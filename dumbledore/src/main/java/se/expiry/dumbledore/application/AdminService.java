package se.expiry.dumbledore.application;

import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.presentation.request.admin.UpdateUserRequestModel;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

public interface AdminService {
    User addUser(AddUserRequestModel newUser);

    void createTestData(List<String> storeNames);

    Store addStore(String storeName);

    User getUser(String email);

    User updateUser(UpdateUserRequestModel user);

    Product generateRandomProduct();
}
