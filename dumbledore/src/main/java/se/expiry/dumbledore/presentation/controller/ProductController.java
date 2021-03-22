package se.expiry.dumbledore.presentation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.application.ProductService;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.presentation.request.product.AddProductRequestModel;
import se.expiry.dumbledore.presentation.request.product.DeleteProductRequestModel;
import se.expiry.dumbledore.presentation.request.product.UpdateProductRequestModel;

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
    public Product addProduct(@RequestBody AddProductRequestModel product) {
        return productService.addProduct(product.getStoreId(), product.getName(), product.getQrCode(), product.getDate());
    }

    @PutMapping(PRODUCT)
    public void updateProduct(@RequestBody UpdateProductRequestModel product) {
       productService.updateProduct(product);
    }
}
