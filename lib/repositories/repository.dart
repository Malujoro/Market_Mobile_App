import 'dart:convert';

import 'package:market_mobile/http/exceptions.dart';
import 'package:market_mobile/http/http_client.dart';
import 'package:market_mobile/models/product.dart';

const String productUrl = "https://marketmobile-api.onrender.com/product";

enum Query { put, post }

abstract class InterfaceProductRepository {
  Future<List<Product>> getAllProducts();
  Future<void> queryProduct(Product product, Query type);
}

class ProductRepository implements InterfaceProductRepository {
  final InterfaceHttpClient client;
  final String jwt;

  ProductRepository({required this.client, required this.jwt});

  @override
  Future<List<Product>> getAllProducts() async {
    final response = await client.get(url: productUrl, token: jwt);

    if (response.statusCode == 200) {
      final List<Product> products = [];

      final body = jsonDecode(response.body);

      body.map(
        (item) {
          final Product product = Product.fromMap(item);
          products.add(product);
        },
      ).toList();
      return products;
    } else if (response.statusCode == 404) {
      throw NotFoundException("A URL informada não é válida");
    } else {
      throw Exception("Não foi possível carregar os produtos");
    }
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

    if (response == 200) {
      return;
    } else if (response == 404) {
      throw NotFoundException("A URL informada não é válida");
    } else {
      throw Exception("Não foi possível carregar os produtos");
    }
  }
}
