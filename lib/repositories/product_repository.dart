import 'dart:convert';

import 'package:market_mobile/assets/constants.dart';
import 'package:market_mobile/mixins/query_mixins.dart';
import 'package:market_mobile/http/http_client.dart';
import 'package:market_mobile/models/product.dart';

// TODO Arrumar url

enum Query { put, post }

abstract class InterfaceProductRepository {
  Future<List<Product>> getAllProducts();
  Future<void> queryProduct(Product product, Query type);
  Future<void> deleteProduct(String barCode);
}

class ProductRepository with QueryMixins implements InterfaceProductRepository {
  final InterfaceHttpClient client;
  final String jwt;

  ProductRepository({required this.client, required this.jwt});

  @override
  Future<List<Product>> getAllProducts() async {
    final response = await client.get(url: urlProduct, token: jwt);

    if (verifyQuery(
      response.statusCode,
      text: "Não foi possível carregar os produtos",
    )) {
      final List<Product> products = [];

      final body = jsonDecode(response.body);

      body.map(
        (item) {
          final Product product = Product.fromMap(item);
          products.add(product);
        },
      ).toList();
      return products;
    }
    return [];
  }

  @override
  Future<void> queryProduct(Product product, Query type) async {
    String query;
    List<String> errorText = [
      "Não foi possível salvar a alteração do produto",
      "Não foi possível salvar o produto"
    ];
    switch (type) {
      case Query.put:
        query = 'PUT';
      case Query.post:
        query = 'POST';
    }

    final response = await client.query(
      url: urlProduct,
      token: jwt,
      map: product.toMap(),
      type: query,
    );

    verifyQuery(response, text: errorText[(type).index]);
  }

  @override
  Future<void> deleteProduct(String barCode) async {
    final response = await client.delete(
      url: urlProduct,
      token: jwt,
      id: barCode,
    );

    verifyQuery(
      response,
      text: "Não é possível remover o produto! Ele está associado a uma venda",
    );
  }
}
