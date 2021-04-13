package se.expiry.dumbledore.presentation.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.application.UserService;
import se.expiry.dumbledore.domain.Preference;
import se.expiry.dumbledore.domain.User;
import se.expiry.dumbledore.dto.UserDTO;
import se.expiry.dumbledore.presentation.request.user.PasswordResetRequestModel;
import se.expiry.dumbledore.presentation.request.user.SavePreferenceRequestModel;

import javax.validation.Valid;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {
    private static final String CHANGE_PASSWORD = "/change-password";
    private static final String PREFERENCE = "/preference";

    private final UserService userService;

    @PutMapping(CHANGE_PASSWORD)
    public User createTestData(@RequestBody @Valid PasswordResetRequestModel passwordResetRequestModel) {
        return userService.changePassword(passwordResetRequestModel.getId(),
                passwordResetRequestModel.getEmail(), passwordResetRequestModel.getPassword());
    }
    @GetMapping(PREFERENCE)
    public Preference getUserPreferences(){
        UserDTO user = (UserDTO) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        return userService.getPreferences(user.getId());
    }
    @PostMapping(PREFERENCE)
    public void saveUserPreferences(@RequestBody SavePreferenceRequestModel preference){
        UserDTO user = (UserDTO) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        userService.savePreference(user.getId(), preference.getSort(), preference.isReverse());
    }

}
