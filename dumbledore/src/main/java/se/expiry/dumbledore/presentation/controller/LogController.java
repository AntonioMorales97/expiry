package se.expiry.dumbledore.presentation.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import se.expiry.dumbledore.application.LogService;
import se.expiry.dumbledore.presentation.request.log.AnonymousLogRequestModel;

import javax.validation.Valid;
import java.util.HashMap;

@RestController
@RequestMapping("/log")
public class LogController {
    public static final String USER_ERROR = "/user-error";
    public static final String ANONYMOUS_ERROR = "/anonymous-error";

    private LogService logService;

    public LogController(LogService logService){
        this.logService = logService;
    }

    @PostMapping(USER_ERROR)
    public ResponseEntity<HashMap<String, String>> userError(){
        return getResponse("LOGGED");
    }


    @PostMapping(ANONYMOUS_ERROR)
    public ResponseEntity<HashMap<String, String>> anonymousError(@Valid @RequestBody AnonymousLogRequestModel request){
        System.out.println(System.currentTimeMillis());
        logService.addAnonymousLog(request.getEmail(), request.getLog(), request.getTimestamp());
        return getResponse("LOGGED");
    }


    private ResponseEntity<HashMap<String, String>> getResponse(String message){
        HashMap<String, String> body = new HashMap<>();
        body.put("message", message);
        return new ResponseEntity<>(body, HttpStatus.OK);
    }

}
