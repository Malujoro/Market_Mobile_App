import 'dart:convert';

import 'package:market_mobile/http/exceptions.dart';
import 'package:market_mobile/http/http_client.dart';
import 'package:market_mobile/models/product.dart';

const String productUrl = "https://marketmobile-api.onrender.com/product";

abstract class InterfaceProductRepository {
  Future<List<Product>> getAllProducts();
}

class ProductRepository implements InterfaceProductRepository {
  final InterfaceHttpClient client;

  ProductRepository({required this.client});

  @override
  Future<List<Product>> getAllProducts() async {
    final response =
        await client.get(url: productUrl);

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
}