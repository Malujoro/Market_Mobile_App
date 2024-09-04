import 'package:flutter/material.dart';
import 'package:market_mobile/mixins/customize_mixins.dart';
import 'package:market_mobile/mixins/hour_mixins.dart';
import 'package:market_mobile/models/sale_product.dart';

class Sale with CustomizeMixins, HourMixins {
  List<SaleProduct> saleProducts = [];
  double totalPrice = 0;
  late DateTime date;

  Sale();

  factory Sale.fromMap(Map<String, dynamic> map) {
    Sale sale = Sale();
    sale.saleProducts = [
      for (Map<String, dynamic> mapAux in map["saleProducts"])
        SaleProduct.fromMap(mapAux)
    ];
    sale.totalPrice = map["totalPrice"];
    sale.date = DateTime.parse(map["date"]);
    return sale;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "saleProducts": [
        for (SaleProduct saleProduct in saleProducts) saleProduct.toMap()
      ],
      "totalPrice": totalPrice,
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
            // richTextCreator("ID: ", id),
            richTextCreator(
                context: context,
                label: "Preço total: ",
                text: "R\$${totalPrice.toStringAsFixed(2)}"),
            richTextCreator(
                context: context,
                label: "Data: ",
                text: timeToString(date.subtract(const Duration(hours: 3)))),
          ],
        ),
      ),
    );
  }

  double calculateTotalPrice() {
    totalPrice = 0;
    for (SaleProduct saleProduct in saleProducts) {
      totalPrice += saleProduct.partialPrice;
    }
    return totalPrice;
  }
}
