import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/locator.dart';
import 'package:dolores/services/product_service.dart';
import 'package:dolores/ui/screens/products/bloc/products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductService _productService = locator<ProductService>();

  ProductsBloc() : super(ProductsState(fetchingStatus: Status.Loading)) {
    add(FetchProducts());
  }

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async* {
    if (event is FetchProducts) {
      yield* _mapFetchProductsToState(event);
    } else if (event is ChangeStore) {
      yield* _mapChangeStoreToState(event);
    } else if (event is AddProduct) {
      yield* _mapAddProductToState(event);
    } else if (event is UpdateProduct) {
      yield* _mapUpdateProductToState(event);
    } else if (event is RemoveProduct) {
      yield* _mapRemoveProductToState(event);
    }
  }

  Stream<ProductsState> _mapFetchProductsToState(FetchProducts event) async* {
    yield state.copyWith(fetchingStatus: Status.Loading);
    try {
      final stores = await _productService.getStores();
      final currentStore = _productService.currentStore;
      yield state.copyWith(
          stores: stores,
          currentStore: currentStore,
          fetchingStatus: Status.Idle);
    } on DoloresError catch (error) {
      yield state.copyWith(fetchingStatus: Status.Idle, error: error);
    } catch (error) {
      throw error;
    }
  }

  Stream<ProductsState> _mapChangeStoreToState(ChangeStore event) async* {
    yield state.copyWith(fetchingStatus: Status.Loading);
    try {
      final currentStore = _productService.setStore(event.storeId);
      yield state.copyWith(
          currentStore: currentStore, fetchingStatus: Status.Idle);
    } on DoloresError catch (error) {
      yield state.copyWith(fetchingStatus: Status.Idle, error: error);
    } catch (error) {
      throw error;
    }
  }

  Stream<ProductsState> _mapAddProductToState(AddProduct event) async* {
    yield state.copyWith(addingStatus: Status.Loading);
    try {
      final currentStore = await _productService.addProduct(
          event.newQrCode, event.newName, event.newDate);

      yield state.copyWith(
          currentStore: currentStore, addingStatus: Status.Success);
    } on DoloresError catch (error) {
      yield state.copyWith(addingStatus: Status.Idle, error: error);
    } catch (error) {
      throw error;
    }
  }

  Stream<ProductsState> _mapUpdateProductToState(UpdateProduct event) async* {
    yield state.copyWith(updatingStatus: Status.Loading);
    try {
      final updatedStore = await _productService.modifyProduct(
        event.productId,
        event.newQrCode,
        event.newName,
        event.newDate,
      );

      yield state.copyWith(
          currentStore: updatedStore, updatingStatus: Status.Success);
    } on DoloresError catch (error) {
      yield state.copyWith(updatingStatus: Status.Idle, error: error);
    } catch (error) {
      throw error;
    }
  }

  Stream<ProductsState> _mapRemoveProductToState(RemoveProduct event) async* {
    yield state.copyWith(removeStatus: Status.Loading);
    try {
      final newStore = await _productService.removeProduct(
        event.productId,
      );

      yield state.copyWith(
          currentStore: newStore, removeStatus: Status.Success);
    } on DoloresError catch (error) {
      yield state.copyWith(removeStatus: Status.Idle, error: error);
    } catch (error) {
      throw error;
    }
  }
}
