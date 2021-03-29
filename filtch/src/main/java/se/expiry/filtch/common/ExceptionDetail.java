package se.expiry.filtch.common;

import lombok.Data;

import java.util.List;

@Data
public class ExceptionDetail {
    private Integer status;
    private String detail;


    public ExceptionDetail (Integer status, String detail){
        this.status = status;
        this.detail = detail;
    }

}