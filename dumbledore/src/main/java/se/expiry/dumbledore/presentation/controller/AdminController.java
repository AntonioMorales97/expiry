package se.expiry.dumbledore.presentation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.application.AdminService;
import se.expiry.dumbledore.application.ProductService;

import java.util.List;

@RestController
public class AdminController {
    private static final String CREATE_DATA = "/create-data";
    private static final String ADD_STORE = "/add-store";

    @Autowired
    AdminService adminService;

    @PostMapping(CREATE_DATA)
    public List<Store> createTestData(@RequestBody List<String> storeNames) {
       return adminService.createTestData(storeNames);
    }
    @PostMapping(ADD_STORE)
    public Store addStore(String storeName) {
       return adminService.addStore(storeName);
    }
}