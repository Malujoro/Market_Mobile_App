import 'package:flutter/material.dart';

class Product {
  String? barCode;
  late String name;
  String? description;
  late double price;

  Product({
    this.barCode,
    required this.name,
    this.description,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      barCode: map["barCode"],
      name: map["name"],
      description: map["description"],
      price: map["price"] * 1.0,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapa = {
      "barCode" : barCode,
      "name" : name,
      "description" : description,
      "price" : price,
    };
    return mapa;
  }

  Widget productWidget(Function richTextCreator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          richTextCreator("Código: ", "$barCode"),
          richTextCreator("Nome: ", name),
          richTextCreator("Preço: ", "R\$${price.toStringAsFixed(2)}"),
          richTextCreator("Descrição: ", "$description"),
        ],
      ),
    );
  }
}
