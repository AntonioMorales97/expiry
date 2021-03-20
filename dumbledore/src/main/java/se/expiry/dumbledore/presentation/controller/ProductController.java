package se.expiry.dumbledore.presentation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.application.ProductService;
import se.expiry.dumbledore.domain.Product;

import java.util.List;

@RestController
public class ProductController {
    private static final String GET_PRODUCTS = "/get-products";
    private static final String REMOVE_PRODUCT = "/remove-product";
    private static final String ADD_PRODUCT = "/add-product";
    private static final String UPDATE_PRODUCT = "/update-product";

    @Autowired
    ProductService productService;

    @GetMapping(GET_PRODUCTS)
    public List<Product> getProducts() {
        return productService.getProducts();
    }

    @DeleteMapping(REMOVE_PRODUCT)
    public void deleteProduct() {
        //TODO: Implement
    }

    @PostMapping(ADD_PRODUCT)
    public String addProduct(String id) {
        //TODO: Implement
        return "Message sent!";
    }

    @PutMapping(UPDATE_PRODUCT)
    public void updateProduct() {
        //TODO: Implement
    }
}
