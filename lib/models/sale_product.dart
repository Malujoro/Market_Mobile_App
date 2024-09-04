import 'package:flutter/material.dart';
import 'package:market_mobile/mixins/customize_mixins.dart';

class SaleProduct with CustomizeMixins {
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

  Widget saleProductWidget(BuildContext context) {
    TextStyle style =
        const TextStyle(color: Colors.black, fontSize: 14, height: 1.4);
    return Card(
      margin: const EdgeInsets.only(bottom: 0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                richTextCreator(
                    context: context,
                    label: "Código: ",
                    text: productBarCode,
                    style: style),
                richTextCreator(
                    context: context,
                    label: "Nome: ",
                    text: productName,
                    style: style),
              ],
            ),
            const SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                richTextCreator(
                    context: context,
                    label: "Quantidade: ",
                    text: quantity.toString(),
                    style: style),
                richTextCreator(
                    context: context,
                    label: "Preço parcial: ",
                    text: "R\$${partialPrice.toStringAsFixed(2)}",
                    style: style),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
