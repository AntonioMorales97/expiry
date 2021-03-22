package se.expiry.dumbledore.presentation.request.product;

import lombok.Data;

import javax.validation.constraints.NotNull;

@Data
public class DeleteProductRequestModel {
    @NotNull(message = "Store ID must given")
    private String storeId;

    @NotNull(message = "Product ID must given")
    private String productId;

    public DeleteProductRequestModel() {
    }
}
