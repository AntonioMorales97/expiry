package se.expiry.filtch.presentation.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import se.expiry.filtch.application.AuthenticateService;
import se.expiry.filtch.presentation.request.UserCredentialsRequestModel;
import se.expiry.filtch.presentation.response.UserDTO;
import se.expiry.filtch.presentation.response.AuthenticationResponseModel;

import javax.validation.Valid;

@RestController
@Validated
@CrossOrigin
@RequiredArgsConstructor
public class AuthController {
    private static final String AUTHORIZE = "/authorize";
    private static final String AUTHENTICATE ="/authenticate";
    private static final String BEARER_PREFIX ="Bearer ";

    private final AuthenticateService authenticateService;

    @PostMapping(AUTHENTICATE)
    public AuthenticationResponseModel validateCredentials(@RequestBody @Valid UserCredentialsRequestModel userCredentials){
        return authenticateService.authenticate(userCredentials.getEmail(), userCredentials.getPassword());
    }

    @GetMapping(AUTHORIZE)
    public UserDTO authorizeToken(@RequestHeader HttpHeaders headers){
        String token = headers.getFirst(HttpHeaders.AUTHORIZATION).substring(BEARER_PREFIX.length());
        
        return authenticateService.authorize(token);

    }
}
