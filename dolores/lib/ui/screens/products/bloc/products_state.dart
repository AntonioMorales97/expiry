import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/models/store.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Status {
  Loading,
  Idle,
  Success,
  Fail,
}

@immutable
class ProductsState extends Equatable {
  final Status fetchingStatus;
  final Status addingStatus;
  final Status updatingStatus;

  final List<Store> stores;
  final Store currentStore;

  final DoloresError error;

  ProductsState(
      {this.fetchingStatus = Status.Idle,
      this.addingStatus = Status.Idle,
      this.updatingStatus = Status.Idle,
      this.stores,
      this.currentStore,
      this.error});

  ProductsState copyWith(
      {Status fetchingStatus,
      Status addingStatus,
      Status updatingStatus,
      List<Store> stores,
      Store currentStore,
      DoloresError error}) {
    return ProductsState(
      fetchingStatus: fetchingStatus ?? this.fetchingStatus,
      addingStatus: addingStatus ?? this.addingStatus,
      updatingStatus: updatingStatus ?? this.updatingStatus,
      stores: stores ?? this.stores,
      currentStore: currentStore ?? this.currentStore,
      error: error,
    );
  }

  @override
  List<Object> get props => [
        fetchingStatus,
        addingStatus,
        updatingStatus,
        stores,
        currentStore,
        error
      ];

  @override
  String toString() {
    return 'ProductsState {fetchingStatus: $fetchingStatus, addingStatus: $addingStatus, updatingStatus: $updatingStatus, currentStore: $currentStore, error: $error, stores: $stores';
  }
}
