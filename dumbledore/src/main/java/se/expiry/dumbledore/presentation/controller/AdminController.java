package se.expiry.dumbledore.presentation.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.application.AdminService;
import se.expiry.dumbledore.domain.Store;

import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.presentation.request.admin.UpdateUserRequestModel;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class AdminController {
    private static final String CREATE_DATA = "/create-data";
    private static final String ADD_STORE = "/add-store";
    private static final String USER = "/user";

    private final AdminService adminService;

    @PostMapping(CREATE_DATA)
    public void createTestData(@RequestBody List<String> storeNames) {
        adminService.createTestData(storeNames);
    }

    @PostMapping(ADD_STORE)
    public Store addStore(String storeName) {
        return adminService.addStore(storeName);
    }

    @PostMapping(USER)
    public User addUser(@RequestBody @Valid AddUserRequestModel newUser) {
        return adminService.addUser(newUser);
    }

    @GetMapping(USER)
    public User getUser(@RequestBody @NotNull(message = "Email cannot be null") String email) {
        return adminService.getUser(email);
    }

    @PutMapping(USER)
    public User updateUser(@RequestBody UpdateUserRequestModel user) {
        return adminService.updateUser(user);
    }


}