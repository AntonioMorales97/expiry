package se.expiry.dumbledore.presentation.request.admin;

import lombok.Data;

import javax.validation.constraints.NotNull;

@Data
public class UpdateStoreRequestModel {

    @NotNull(message = "Store id must not be null")
    private String storeId;

    @NotNull(message = "New name must be given")
    private String newStoreName;

    public UpdateStoreRequestModel(){
    }
}
