package se.expiry.dumbledore.presentation.request.product;

import lombok.Data;

import javax.validation.constraints.NotNull;
@Data
public class UpdateProductRequestModel {
    private String name;
    private String qrCode;
    private String date;

    @NotNull(message="productId cannot be empty!")
    private String productId;
    @NotNull(message="storeId cannot be empty!")
    private String storeId;
    public UpdateProductRequestModel() {
    }
}
