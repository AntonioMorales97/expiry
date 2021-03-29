package se.expiry.filtch.presentation.error;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import se.expiry.filtch.common.ExceptionDetail;
import se.expiry.filtch.common.ExpiryException;

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
}