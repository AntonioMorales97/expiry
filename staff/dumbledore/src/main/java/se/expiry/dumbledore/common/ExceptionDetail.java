package se.expiry.dumbledore.common;

import lombok.Data;

import java.util.List;

@Data
public class ExceptionDetail {
    private Integer status;
    private String detail;
    private List<ErrorDetail> errors;

    public ExceptionDetail (Integer status, String detail){
        this.status = status;
        this.detail = detail;
    }

    public ExceptionDetail (Integer status, String detail, List<ErrorDetail> errors){
        this.status = status;
        this.detail = detail;
        this.errors = errors;
    }
}
