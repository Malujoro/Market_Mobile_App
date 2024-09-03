import 'dart:convert';

import 'package:market_mobile/mixins/query_mixins.dart';
import 'package:market_mobile/http/http_client.dart';
import 'package:market_mobile/models/sale.dart';

const String url = "https://marketmobile-api.onrender.com/sale";

// TODO: Implementar o GetSalesBetween (pros Insights)

abstract class InterfaceSaleRepository {
  Future<List<Sale>> getAllSales();
  Future<void> postSale(Sale sale);
  // Future<List<Sale>> getSalesBetween(DateTime start, DateTime end);
  Future<void> deleteSale(int id);
}

class SaleRepository with QueryMixins implements InterfaceSaleRepository {
  final InterfaceHttpClient client;
  final String jwt;

  SaleRepository({required this.client, required this.jwt});

  @override
  Future<List<Sale>> getAllSales() async {
    final response = await client.get(url: url, token: jwt);

    if (verifyQuery(response.statusCode)) {
      final List<Sale> sales = [];

      final body = jsonDecode(response.body);

      body.map(
        (item) {
          final Sale sale = Sale.fromMap(item);
          sales.add(sale);
        },
      ).toList();
      return sales;
    }
    return [];
  }

  @override
  Future<void> postSale(Sale sale) async {
    final response = await client.query(
      url: url,
      token: jwt,
      map: sale.toMap(),
      type: 'POST',
    );

    verifyQuery(response);
  }

  @override
  Future<void> deleteSale(int id) async {
    final response = await client.delete(
      url: url,
      token: jwt,
      id: id.toString(),
    );

    verifyQuery(response);
  }
}
