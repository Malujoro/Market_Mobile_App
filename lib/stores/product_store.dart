import 'package:flutter/material.dart';
import 'package:market_mobile/http/exceptions.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/pages/login/plans_page.dart';
import 'package:market_mobile/repositories/product_repository.dart';

enum ProductOrder { ascAZ }

class ProductStore with DialogueMixins {
  final InterfaceProductRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Product>> state = ValueNotifier<List<Product>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>("");

  ProductStore({required this.repository});

  Future getProducts(context, [ProductOrder order = ProductOrder.ascAZ]) async {
    await tryQuery(context, () async {
      final result = await repository.getAllProducts();
      state.value = result;
      switch (order) {
        case ProductOrder.ascAZ:
          orderNameAsc();
      }
    });
  }

  Future postProduct(context, Product product) async {
    await tryQuery(context, () async {
      await repository.queryProduct(product, Query.post);
      state.value.add(product);
    });
  }

  Future putProduct(context, Product product) async {
    await tryQuery(context, () async {
      await repository.queryProduct(product, Query.put);
    });
  }

  Future<void> deleteProduct(context, String barCode) async {
    await tryQuery(context, () async {
      await repository.deleteProduct(barCode);
    });
  }

  void orderNameAsc() {
    state.value
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<void> tryQuery(context, Future Function() func) async {
    isLoading.value = true;

    try {
      await func();
    } on NotFoundException catch (e) {
      error.value = e.message;
    } on InvalidSessionException catch (e) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PlansPage(),
          ),
        );
        displayDialog(
          context,
          const Text("Erro!"),
          Text(
            e.toString(),
          ),
        );
      }
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }
}
