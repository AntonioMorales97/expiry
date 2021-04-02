package se.expiry.dumbledore.presentation.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.application.UserService;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.presentation.request.user.PasswordResetRequestModel;

import javax.validation.Valid;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {
    private static final String CHANGE_PASSWORD = "/change-password";

    private final UserService userService;

    @PutMapping(CHANGE_PASSWORD)
    public User createTestData(@RequestBody @Valid PasswordResetRequestModel passwordResetRequestModel) {
        return userService.changePassword(passwordResetRequestModel.getId(),
                passwordResetRequestModel.getEmail(),passwordResetRequestModel.getPassword());
    }

}
