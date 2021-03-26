package se.expiry.filtch.presentation.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import se.expiry.filtch.application.AuthenticateService;
import se.expiry.filtch.presentation.request.UserCredentialsRequestModel;
import se.expiry.filtch.presentation.response.UserDTO;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;


@RestController
@Validated
@CrossOrigin
@RequiredArgsConstructor
public class AuthController {
    private static final String AUTHENTICATION = "/validate-token";
    private static final String VALIDATECREDENTIALS ="/validate-credentials";
    private static final String BEARER ="Bearer ";

    private final AuthenticateService authenticateService;

    @PostMapping(VALIDATECREDENTIALS)
    public String validateCredentials(@RequestBody @Valid UserCredentialsRequestModel userCredentials){
        return authenticateService.authenticateCredentials(userCredentials.getEmail(), userCredentials.getPassword());
    }
    @GetMapping(AUTHENTICATION)
    public UserDTO authorizeToken(@RequestHeader HttpHeaders headers){
        String token = headers.getFirst(HttpHeaders.AUTHORIZATION).substring(BEARER.length());
        
        return authenticateService.authorize(token);

    }
}
