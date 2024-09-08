import 'package:flutter/material.dart';
import 'package:market_mobile/mixins/customize_mixins.dart';

class Product with CustomizeMixins {
  String? idProduct;
  late String barCode;
  late String name;
  String description;
  late double price;
  int? stock;
  int? warningStock;

  Product({
    this.idProduct,
    required this.barCode,
    required this.name,
    this.description = "",
    required this.price,
    this.stock,
    this.warningStock,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      idProduct: map["idProduct"],
      barCode: map["barCode"],
      name: map["name"],
      description: map["description"],
      price: map["price"] * 1.0,
      stock: map["stock"],
      warningStock: map["warningStock"],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "barCode": barCode,
      "name": name,
      "description": description,
      "price": price,
      "stock": stock,
      "warningStock": warningStock,
    };
    return map;
  }

  Widget productWidget(BuildContext context, {TextStyle? style}) {
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
            richTextCreator(
              context: context,
              label: "Código: ",
              text: barCode,
              style: style,
            ),
            richTextCreator(
              context: context,
              label: "Nome: ",
              text: name,
              style: style,
            ),
            richTextCreator(
              context: context,
              label: "Preço: ",
              text: "R\$${price.toStringAsFixed(2)}",
              style: style,
            ),
            if (stock != null)
              richTextCreator(
                context: context,
                label: "Estoque: ",
                text: stock.toString(),
                style: style,
              ),
            if (warningStock != null)
              richTextCreator(
                context: context,
                label: "Crítico: ",
                text: warningStock.toString(),
                style: style,
              ),
            richTextCreator(
              context: context,
              label: "Descrição: ",
              text: description,
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
