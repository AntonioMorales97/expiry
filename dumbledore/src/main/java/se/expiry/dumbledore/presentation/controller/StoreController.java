package se.expiry.dumbledore.presentation.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import se.expiry.dumbledore.application.StoreService;
import se.expiry.dumbledore.domain.Product;
import se.expiry.dumbledore.domain.Store;
import se.expiry.dumbledore.dto.UserDTO;
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
    @GetMapping(PRODUCTS)
    public List<Store> getProductsFromUserStore(){
        UserDTO user = (UserDTO)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return storeService.getUserStoreProducts(user.getId());

    }

    @DeleteMapping("/{storeId}" + PRODUCTS + "/{productId}")
    public void deleteProduct(@PathVariable String storeId, @PathVariable String productId) {
        UserDTO user = (UserDTO)SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        storeService.deleteProduct(storeId, productId, user.getId());
    }

    @PostMapping("/{storeId}" + PRODUCTS)
    public Product addProduct(@PathVariable String storeId, @RequestBody AddProductRequestModel product) {
        UserDTO user = (UserDTO)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return storeService.addProduct(storeId, product.getName(), product.getQrCode(), product.getDate(), user.getId());
    }

    @PutMapping("/{storeId}" + PRODUCTS)
    public void updateProduct(@PathVariable String storeId, @RequestBody UpdateProductRequestModel product) {
        UserDTO user = (UserDTO)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
       storeService.updateProduct(storeId, product,user.getId());
    }
}
