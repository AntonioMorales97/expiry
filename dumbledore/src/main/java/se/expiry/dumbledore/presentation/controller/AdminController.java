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
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {
    private static final String CREATE_DATA = "/create-data";
    private static final String STORE = "/store";
    private static final String USER = "/user";

    private final AdminService adminService;

    @DeleteMapping(STORE + "/{storeId}/user/{userId}")
    public void removeUserFromStore(@PathVariable String storeId, @PathVariable String userId){
        //TODO: Implement
    }

    @PutMapping(STORE + "/{storeId}/user/{userId}")
    public void addUserToStore(@PathVariable String storeId, @PathVariable String userId){
        adminService.addUserToStore(storeId, userId);
    }

    //TODO: Remove
    @PostMapping(CREATE_DATA)
    public void createTestData(@RequestBody List<String> storeNames) {
        adminService.createTestData(storeNames);
    }

    @GetMapping("/stores")
    public List<Store> getStores(){
        return adminService.getStores();
    }

    @PostMapping(STORE)
    public Store addStore(@RequestBody String newStoreName) {
        return adminService.addStore(newStoreName);
    }

    @PostMapping(USER)
    public User addUser(@RequestBody @Valid AddUserRequestModel newUser) {
        return adminService.addUser(newUser);
    }

    @GetMapping(USER + "/{userId}")
    public User getUserById(@PathVariable String userId) {
        return adminService.getUser(userId);
    }

    @PutMapping(USER + "/{userId}")
    public User updateUser(@PathVariable String userId, @RequestBody UpdateUserRequestModel updateUserReq) {
        return adminService.updateUser(userId, updateUserReq);
    }


}