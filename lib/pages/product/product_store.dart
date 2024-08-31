import 'package:flutter/material.dart';
import 'package:market_mobile/http/exceptions.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/repositories/repository.dart';

enum Order { ascAZ }

class ProductStore {
  final InterfaceProductRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Product>> state = ValueNotifier<List<Product>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>("");

  ProductStore({required this.repository});

  Future getProducts([Order order = Order.ascAZ]) async {
    isLoading.value = true;

    try {
      final result = await repository.getAllProducts();
      state.value = result;
      switch (order) {
        case Order.ascAZ:
          orderNameAsc();
      }
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future postProduct(Product product) async {
    isLoading.value = true;

    try {
      await repository.queryProduct(product, Query.post);
      state.value.add(product);
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future putProduct(Product product) async {
    isLoading.value = true;

    try {
      await repository.queryProduct(product, Query.put);
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  void orderNameAsc() {
    state.value
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
