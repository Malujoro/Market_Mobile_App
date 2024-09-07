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

  Widget saleProductWidget(BuildContext context, Function removeProduct, {TextStyle? style}) {
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
            Expanded(
              flex: 1,
              child: Text(
                productName,
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                "R\$${partialPrice.toStringAsFixed(2)}",
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                removeProduct();
              },
              icon: const Icon(
                Icons.highlight_remove,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
