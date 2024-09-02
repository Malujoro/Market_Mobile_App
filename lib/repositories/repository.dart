import 'dart:convert';

import 'package:market_mobile/http/exceptions.dart';
import 'package:market_mobile/http/http_client.dart';
import 'package:market_mobile/models/product.dart';

const String productUrl = "https://marketmobile-api.onrender.com/product";

enum Query { put, post }

abstract class InterfaceProductRepository {
  Future<List<Product>> getAllProducts();
  Future<void> queryProduct(Product product, Query type);
  Future<void> deleteProduct(String barCode);
  bool verifyQuery(int responseCode);
}

class ProductRepository implements InterfaceProductRepository {
  final InterfaceHttpClient client;
  final String jwt;

  ProductRepository({required this.client, required this.jwt});

  @override
  Future<List<Product>> getAllProducts() async {
    final response = await client.get(url: productUrl, token: jwt);

    if (verifyQuery(response.statusCode)) {
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
    switch (type) {
      case Query.put:
        query = 'PUT';
      case Query.post:
        query = 'POST';
    }

    final response = await client.query(
      url: productUrl,
      token: jwt,
      map: product.toMap(),
      type: query,
    );

    verifyQuery(response);
  }

  @override
  Future<void> deleteProduct(String barCode) async {
    final response = await client.delete(
      url: productUrl,
      token: jwt,
      barCode: barCode,
    );

    verifyQuery(response);
  }

  @override
  bool verifyQuery(int responseCode) {
    if (responseCode == 200) {
      return true;
    } else if (responseCode == 404) {
      throw NotFoundException("A URL informada não é válida");
    } else if (responseCode == 401) {
      throw NotFoundException("Sessão expirada");
    } else {
      throw Exception("Não foi possível carregar os produtos");
    }
  }
}