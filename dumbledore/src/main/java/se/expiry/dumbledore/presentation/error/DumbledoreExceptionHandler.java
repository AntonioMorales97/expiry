package se.expiry.dumbledore.presentation.error;

import org.springframework.http.HttpStatus;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import se.expiry.dumbledore.common.ErrorDetail;
import se.expiry.dumbledore.common.ExceptionDetail;
import se.expiry.dumbledore.common.ExpiryException;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

@ControllerAdvice
@ResponseBody
public class DumbledoreExceptionHandler {

    @ExceptionHandler(ExpiryException.class)
    ExceptionDetail handleExpiryException(HttpServletResponse response, ExpiryException expiryException){
        ExceptionDetail exceptionDetail = expiryException.getExceptionDetail();
        response.setStatus(exceptionDetail.getStatus());
        return exceptionDetail;
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    ExceptionDetail handleConstraintException(MethodArgumentNotValidException  exc){
        ExceptionDetail exceptionDetail = new ExceptionDetail(HttpStatus.BAD_REQUEST.value(), "Invalid parameters");
        List<ErrorDetail> errors = new ArrayList<>();
        exceptionDetail.setErrors(errors);

        for(FieldError fieldError : exc.getBindingResult().getFieldErrors()){
            ErrorDetail errorDetail = new ErrorDetail(fieldError.getDefaultMessage());
            errorDetail.setQueryParam(fieldError.getField());
            errors.add(errorDetail);
        }

        for(ObjectError globalError : exc.getBindingResult().getGlobalErrors()){
            ErrorDetail errorDetail = new ErrorDetail(globalError.getDefaultMessage());
            errorDetail.setQueryParam(globalError.getObjectName());
            errors.add(errorDetail);
        }

        if(errors.size() == 1){
            exceptionDetail.setDetail(errors.get(0).getDetail());
        }

        return exceptionDetail;
    }
}
