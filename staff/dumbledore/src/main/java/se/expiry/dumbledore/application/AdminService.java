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
    public User addUser(AddUserRequestModel newUser);
    public void createTestData(List<String> storeNames);
    public Store addStore(String storeName);
    public User getUser(String email);
    public User updateUser(UpdateUserRequestModel user);
    default Product generateRandomProduct() {
        return new Product(randomString(), randomQrCode(), randomDate());
    }

    private String randomString() {
        Random random = new Random();
        int aLimit = 97;
        int zLimit = 122;
        int targetStringLength = random.nextInt(10 - 5) + 1;
        return random.ints(aLimit, zLimit + 1)
                .limit(targetStringLength)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
    }

    private String randomQrCode() {
        Random random = new Random();
        int qrCode = random.nextInt(1000 - 100) + 1;
        return Integer.toString(qrCode);
    }

    private String randomDate() {
        Random random = new Random();
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        int startYear = 2021;
        int endYear = 2021;
        long start = Timestamp.valueOf(startYear + 1 + "-1-1 0:0:0").getTime();
        long end = Timestamp.valueOf(endYear + "-1-1 0:0:0").getTime();
        long ms = (long) ((end - start) * Math.random() + start);
        Date date = new Date(ms);
        return dateFormat.format(date);

    }
}
