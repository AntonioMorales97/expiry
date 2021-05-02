import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/helpers/status_enum.dart';
import 'package:dolores/models/store.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ProductsState extends Equatable {
  final Status fetchingStatus;
  final Status addingStatus;
  final Status updatingStatus;
  final Status removeStatus;
  final Status refreshStatus;

  final List<Store> stores;
  final Store currentStore;

  final DoloresError error;

  ProductsState(
      {this.fetchingStatus = Status.Idle,
      this.addingStatus = Status.Idle,
      this.updatingStatus = Status.Idle,
      this.removeStatus = Status.Idle,
      this.refreshStatus = Status.Idle,
      this.stores,
      this.currentStore,
      this.error});

  ProductsState copyWith(
      {Status fetchingStatus,
      Status addingStatus,
      Status updatingStatus,
      Status removeStatus,
      Status refreshStatus,
      List<Store> stores,
      Store currentStore,
      DoloresError error}) {
    return ProductsState(
      fetchingStatus: fetchingStatus,
      addingStatus: addingStatus,
      updatingStatus: updatingStatus,
      removeStatus: removeStatus,
      refreshStatus: refreshStatus,
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
        removeStatus,
        refreshStatus,
        stores,
        currentStore,
        error
      ];

  @override
  String toString() {
    return 'ProductsState {fetchingStatus: $fetchingStatus, addingStatus: $addingStatus, updatingStatus: $updatingStatus, refreshStatus: $refreshStatus, currentStore: $currentStore, error: $error, stores: $stores}';
  }
}
