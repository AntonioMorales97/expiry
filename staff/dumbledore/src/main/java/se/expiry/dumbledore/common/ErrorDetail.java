package se.expiry.dumbledore.common;

import lombok.Data;

@Data
public class ErrorDetail {
    private String detail;
    private String path;
    private String queryParam;

    public ErrorDetail(String detail){
        this.detail = detail;
    };
}
