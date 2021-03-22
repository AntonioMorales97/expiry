package se.expiry.dumbledore.presentation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.application.ProductService;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.presentation.request.product.DeleteProductRequestModel;

import java.util.List;

@RestController
public class ProductController {
    private static final String PRODUCTS = "/products";
    private static final String PRODUCT = "/product";

    @Autowired
    ProductService productService;

    @GetMapping(PRODUCTS + "/{id}")
    public List<Product> getProducts(@PathVariable String id) {
        return productService.getProducts(id);
    }

    @DeleteMapping(PRODUCT)
    public void deleteProduct(@RequestBody DeleteProductRequestModel deleteProductRequestModel) {
        productService.deleteProduct(deleteProductRequestModel.getStoreId(), deleteProductRequestModel.getProductId());
    }

    @PostMapping(PRODUCT)
    public String addProduct(String id) {
        //TODO: Implement
        return "Message sent!";
    }

    @PutMapping(PRODUCT)
    public void updateProduct() {
        //TODO: Implement
    }
}
