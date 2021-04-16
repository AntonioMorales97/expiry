package se.expiry.dumbledore.presentation.error;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;

import javax.servlet.http.HttpServletResponse;

@ControllerAdvice
@ResponseBody
public class ExceptionHandlers {

    @ExceptionHandler(ExpiryException.class)
    ExceptionDetail handleExpiryException(HttpServletResponse response, ExpiryException expiryException){
        ExceptionDetail exceptionDetail = expiryException.getExceptionDetail();
        response.setStatus(exceptionDetail.getStatus());
        return exceptionDetail;
    }
    //TODO Constraint from Password equals constraint HANDLING !
}
