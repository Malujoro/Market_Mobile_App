import 'package:flutter/material.dart';

class SaleProduct {
  late String productBarCode;
  late String productName;
  late int quantity;
  late double partialPrice;

  SaleProduct({
    required this.productBarCode,
    required this.productName,
    required this.quantity,
    required this.partialPrice,
  });

  factory SaleProduct.fromMap(Map<String, dynamic> map) {
    return SaleProduct(
      productBarCode: map["productBarCode"],
      productName: map["productName"],
      quantity: map["quantity"],
      partialPrice: map["partialPrice"] * 1.0,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "productBarCode": productBarCode,
      "quantity": quantity,
      "partialPrice": partialPrice,
    };
    return map;
  }

  Widget saleProductWidget(Function richTextCreator) {
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
            richTextCreator("Código: ", productBarCode),
            richTextCreator("Nome: ", productName),
            richTextCreator("Quantidade: ", quantity),
            richTextCreator(
                "Preço parcial: ", "R\$${partialPrice.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
