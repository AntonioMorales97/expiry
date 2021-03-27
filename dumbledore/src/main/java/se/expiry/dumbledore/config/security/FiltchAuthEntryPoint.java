package se.expiry.dumbledore.config.security;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.util.JsonHelper;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class FiltchAuthEntryPoint implements AuthenticationEntryPoint {

    @Override
    public void commence(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AuthenticationException exc) throws IOException {
        ExceptionDetail exceptionDetail = new ExceptionDetail(HttpStatus.FORBIDDEN.value(), "Authentication needed.");
        httpServletResponse.setContentType(MediaType.APPLICATION_JSON_VALUE);

        int status = HttpStatus.FORBIDDEN.value();
        String jsonString;
        try {
            jsonString = JsonHelper.objectToJson(exceptionDetail);
        } catch (JsonProcessingException jsonExc){
            //TODO: log
            status = HttpStatus.INTERNAL_SERVER_ERROR.value();
            jsonString = "{\"status\":500,\"detail\":\"Server error\"}";
        }

        httpServletResponse.sendError(status, jsonString);
    }
}
