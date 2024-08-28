import 'package:flutter/material.dart';
import 'package:market_mobile/http/exceptions.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/repositories/repository.dart';

class ProductStore {
  final InterfaceProductRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Product>> state = ValueNotifier<List<Product>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>("");

  ProductStore({required this.repository});

  Future getProducts() async {
    isLoading.value = true;

    try {
      final result = await repository.getAllProducts();
      state.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch(e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }

}