import 'package:flutter/material.dart';
import 'package:market_mobile/http/exceptions.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/models/sale.dart';
import 'package:market_mobile/pages/login/plans_page.dart';
import 'package:market_mobile/repositories/sale_repository.dart';

enum SaleOrder { dateAsc }

class SaleStore with DialogueMixins {
  final InterfaceSaleRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Sale>> state = ValueNotifier<List<Sale>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>("");

  SaleStore({required this.repository});

  Future getSales(BuildContext context,
      [DateTime? start,
      DateTime? end,
      SaleOrder order = SaleOrder.dateAsc]) async {
    tryQuery(context, () async {
      late List<Sale> result;
      if (start != null && end != null) {
        result = await repository.getAllSales(
            start.toIso8601String(), end.toIso8601String());
      } else {
        result = await repository.getAllSales();
      }
      state.value = result;
      switch (order) {
        case SaleOrder.dateAsc:
          orderNameAsc();
      }
    });
  }

  Future postSale(BuildContext context, Sale sale) async {
    tryQuery(context, () async {
      await repository.postSale(sale);
    });
  }

  Future<void> deleteSale(BuildContext context, int id) async {
    tryQuery(context, () async {
      await repository.deleteSale(id);
    });
  }

  void orderNameAsc() {
    state.value.sort((a, b) => a.date.toString().compareTo(b.date.toString()));
  }

  void tryQuery(context, Future Function() func) async {
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
