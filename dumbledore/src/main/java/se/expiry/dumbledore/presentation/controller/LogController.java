package se.expiry.dumbledore.presentation.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import se.expiry.dumbledore.application.LogService;
import se.expiry.dumbledore.presentation.request.log.ErrorLogRequestModel;

import javax.validation.Valid;
import java.util.HashMap;

@RestController
@RequestMapping("/log")
public class LogController {
    public static final String ERROR_LOG = "/error-log";

    private LogService logService;

    public LogController(LogService logService){
        this.logService = logService;
    }

    //TODO: Impl rate limit
    @PostMapping(ERROR_LOG)
    public ResponseEntity<HashMap<String, String>> errorLog(@Valid @RequestBody ErrorLogRequestModel request){
        System.out.println(System.currentTimeMillis());
        logService.addErrorLog(request.getEmail(), request.getError(), request.getStackTrace(), request.getDateTime(), request.getPlatformType());
        return getResponse("LOGGED");
    }


    private ResponseEntity<HashMap<String, String>> getResponse(String message){
        HashMap<String, String> body = new HashMap<>();
        body.put("message", message);
        return new ResponseEntity<>(body, HttpStatus.OK);
    }

}
