package se.expiry.dumbledore.config.security;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.util.JsonHelper;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AccessDeniedHandlerJson implements AccessDeniedHandler {

    @Override
    public void handle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AccessDeniedException e) throws IOException {
        ExceptionDetail exceptionDetail = new ExceptionDetail(HttpStatus.UNAUTHORIZED.value(), "Unauthorized.");
        httpServletResponse.setContentType(MediaType.APPLICATION_JSON_VALUE);

        int status = HttpStatus.UNAUTHORIZED.value();
        String jsonString;
        try {
            jsonString = JsonHelper.objectToJson(exceptionDetail);
        } catch (JsonProcessingException jsonExc) {
            //TODO: log
            status = HttpStatus.INTERNAL_SERVER_ERROR.value();
            jsonString = "{\"status\":500,\"detail\":\"Server error\"}";
        }

        httpServletResponse.sendError(status, jsonString);
    }

}
