package se.expiry.dumbledore.presentation.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.application.StoreService;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.presentation.request.product.AddProductRequestModel;
import se.expiry.dumbledore.presentation.request.product.UpdateProductRequestModel;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/store")
public class StoreController {
    private static final String PRODUCTS = "/products";

    private final StoreService storeService;

    @GetMapping("/{storeId}" + PRODUCTS)
    public List<Product> getProducts(@PathVariable String storeId) {
        return storeService.getProducts(storeId);
    }

    @DeleteMapping("/{storeId}" + PRODUCTS + "/{productId}")
    public void deleteProduct(@PathVariable String storeId, @PathVariable String productId) {
        storeService.deleteProduct(storeId, productId);
    }

    @PostMapping("/{storeId}" + PRODUCTS)
    public Product addProduct(@PathVariable String storeId, @RequestBody AddProductRequestModel product) {
        return storeService.addProduct(storeId, product.getName(), product.getQrCode(), product.getDate());
    }

    @PutMapping("/{storeId}" + PRODUCTS + "/{productId}")
    public void updateProduct(@PathVariable String storeId, @RequestBody UpdateProductRequestModel product) {
       storeService.updateProduct(storeId, product);
    }
}
