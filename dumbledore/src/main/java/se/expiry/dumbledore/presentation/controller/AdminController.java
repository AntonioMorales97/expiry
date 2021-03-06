package se.expiry.dumbledore.presentation.controller;


import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.application.AdminService;
import se.expiry.dumbledore.domain.Store;

import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.admin.AddStoreRequestModel;
import se.expiry.dumbledore.presentation.request.admin.AddUserRequestModel;
import se.expiry.dumbledore.presentation.request.admin.UpdateStoreRequestModel;
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

    @DeleteMapping(STORE + "/{storeId}" + USER + "/{userId}")
    public void removeUserFromStore(@PathVariable String storeId, @PathVariable String userId){
        adminService.removeUserFromStore(storeId, userId);
    }

    @PutMapping(STORE + "/{storeId}" + USER + "/{userId}")
    public void addUserToStore(@PathVariable String storeId, @PathVariable String userId){
        adminService.addUserToStore(storeId, userId);
    }

    @GetMapping(USER)
    public List<User> getUsers(){
        return adminService.getUsers();
    }

    @GetMapping(STORE)
    public List<Store> getStores(){
        return adminService.getStores();
    }

    @DeleteMapping(STORE + "/{storeId}" + USER + "/{userId}")
    public void deleteStore(@PathVariable String storeId, @PathVariable String userId){
        adminService.deleteStore(storeId, userId);
    }

    @PutMapping(STORE)
    public Store updateStore(@RequestBody @Valid UpdateStoreRequestModel updateStoreRequestModel){
        return adminService.updateStore(updateStoreRequestModel.getStoreId(), updateStoreRequestModel.getNewStoreName());
    }

    @PostMapping(STORE)
    public Store addStore(@RequestBody @Valid AddStoreRequestModel newStore) {
        return adminService.addStore(newStore.getStoreName());
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
    public User updateUser(@PathVariable String userId, @RequestBody @Valid UpdateUserRequestModel updateUserReq) {
        return adminService.updateUser(userId, updateUserReq);
    }


}