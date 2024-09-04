import 'package:flutter/material.dart';
import 'package:market_mobile/http/exceptions.dart';
import 'package:market_mobile/models/sale.dart';
import 'package:market_mobile/repositories/sale_repository.dart';

enum SaleOrder { dateAsc }

class SaleStore {
  final InterfaceSaleRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Sale>> state = ValueNotifier<List<Sale>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>("");
  
  SaleStore({required this.repository});

  Future getSales([SaleOrder order = SaleOrder.dateAsc]) async {
    isLoading.value = true;

    try {
      final result = await repository.getAllSales();
      state.value = result;
      switch (order) {
        case SaleOrder.dateAsc:
          orderNameAsc();
      }
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future postSale(Sale sale) async {
    isLoading.value = true;

    try {
      await repository.postSale(sale);
      // state.value.add(sale);
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> deleteSale(int id) async {
    isLoading.value = true;

    try {
      await repository.deleteSale(id);
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  void orderNameAsc() {
    state.value
        .sort((a, b) => a.date.toString().compareTo(b.date.toString()));
  }
}
