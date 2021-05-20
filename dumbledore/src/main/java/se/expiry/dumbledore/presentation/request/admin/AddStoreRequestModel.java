package se.expiry.dumbledore.presentation.request.admin;

import lombok.Data;

import javax.validation.constraints.NotNull;

@Data
public class AddStoreRequestModel {
    @NotNull(message = "Store name cannot be null")
    private String storeName;

    public AddStoreRequestModel(){}
}
