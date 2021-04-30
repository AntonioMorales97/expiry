import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProductsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductsEvent {}

class ChangeStore extends ProductsEvent {
  final String storeId;

  ChangeStore(this.storeId);
}

class AddProduct extends ProductsEvent {
  final String newQrCode;
  final String newName;
  final String newDate;

  AddProduct(
      {@required this.newQrCode,
      @required this.newDate,
      @required this.newName});
}

class RemoveProduct extends ProductsEvent {
  final String productId;
  RemoveProduct({@required this.productId});
}

class UpdateProduct extends ProductsEvent {
  final String productId;
  final String newQrCode;
  final String newName;
  final String newDate;

  UpdateProduct(
      {@required this.productId,
      @required this.newQrCode,
      @required this.newDate,
      @required this.newName});
}
