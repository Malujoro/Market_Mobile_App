import 'dart:convert';

import 'package:http/http.dart';
import 'package:market_mobile/assets/constants.dart';
import 'package:market_mobile/mixins/query_mixins.dart';
import 'package:market_mobile/http/http_client.dart';
import 'package:market_mobile/models/sale.dart';

abstract class InterfaceSaleRepository {
  Future<List<Sale>> getAllSales([String? start, String? end]);
  Future<void> postSale(Sale sale);
  Future<void> deleteSale(int id);
}

class SaleRepository with QueryMixins implements InterfaceSaleRepository {
  final InterfaceHttpClient client;
  final String jwt;

  SaleRepository({required this.client, required this.jwt});

  @override
  Future<List<Sale>> getAllSales([String? start, String? end]) async {
    Response response;
    if (start != null && end != null) {
      response = await client.get(
          url: "$urlSale/between?startDate=$start&endDate=$end", token: jwt);
    } else {
      response = await client.get(url: urlSale, token: jwt);
    }

    if (verifyQuery(
      response.statusCode,
      text: "Não foi possível carregar as vendas",
    )) {
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
      url: urlSale,
      token: jwt,
      map: sale.toMap(),
      type: 'POST',
    );

    verifyQuery(response, text: "Não foi possível salvar a venda");
  }

  @override
  Future<void> deleteSale(int id) async {
    final response = await client.delete(
      url: urlSale,
      token: jwt,
      id: id.toString(),
    );

    verifyQuery(response, text: "Não foi possível excluir a venda");
  }
}
