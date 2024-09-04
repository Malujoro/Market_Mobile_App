import 'package:flutter/material.dart';
import 'package:market_mobile/mixins/customize_mixins.dart';

class Product with CustomizeMixins{
  late String barCode;
  late String name;
  String description;
  late double price;

  Product({
    required this.barCode,
    required this.name,
    this.description = "",
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
    Map<String, dynamic> map = {
      "barCode": barCode,
      "name": name,
      "description": description,
      "price": price,
    };
    return map;
  }

  Widget productWidget(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            richTextCreator(context: context, label: "Código: ", text: barCode),
            richTextCreator(context: context, label: "Nome: ", text: name),
            richTextCreator(context: context, label: "Preço: ", text: "R\$${price.toStringAsFixed(2)}"),
            richTextCreator(context: context, label: "Descrição: ", text: description),
          ],
        ),
      ),
    );
  }
}
