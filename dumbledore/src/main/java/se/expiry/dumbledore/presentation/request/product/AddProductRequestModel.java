package se.expiry.dumbledore.presentation.request.product;

import lombok.Data;

import javax.validation.constraints.NotNull;
@Data
public class AddProductRequestModel {

    @NotNull(message="Name cannot be empty!")
    private String name;

    @NotNull(message="Qrcode cannot be empty!")
    private String qrCode;

    @NotNull(message="Expiry date cannot be empty!")
    private String date;

    public AddProductRequestModel() {
    }
}
