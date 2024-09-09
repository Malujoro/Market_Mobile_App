import 'package:flutter/material.dart';
import 'package:market_mobile/mixins/customize_mixins.dart';
import 'package:market_mobile/mixins/hour_mixins.dart';
import 'package:market_mobile/models/sale_product.dart';

class Sale with CustomizeMixins, HourMixins {
  List<SaleProduct> saleProducts = [];
  double totalPrice = 0;
  late DateTime date;
  double? discount;

  Sale();

  factory Sale.fromMap(Map<String, dynamic> map) {
    Sale sale = Sale();
    sale.saleProducts = [
      for (Map<String, dynamic> mapAux in map["saleProducts"])
        SaleProduct.fromMap(mapAux)
    ];
    sale.totalPrice = map["totalPrice"];
    sale.date = DateTime.parse(map["date"]);
    sale.discount = map["discount"];
    return sale;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "saleProducts": [
        for (SaleProduct saleProduct in saleProducts) saleProduct.toMap()
      ],
      "totalPrice": totalPrice,
      "discount": discount,
    };
    return map;
  }

  Widget productWidget(BuildContext context, {TextStyle? style}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            richTextCreator(
              context: context,
              label: "Preço total: ",
              text: "R\$${totalPrice.toStringAsFixed(2)}",
              style: style,
            ),
            if (discount != null)
              richTextCreator(
                context: context,
                label: "Desconto: R\$",
                text: discount!.toStringAsFixed(2),
                style: style,
              ),
            richTextCreator(
              context: context,
              label: "Data: ",
              text: timeToString(date.subtract(const Duration(hours: 3))),
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalPrice() {
    totalPrice = 0;
    for (SaleProduct saleProduct in saleProducts) {
      totalPrice += saleProduct.partialPrice * saleProduct.quantity;
    }
    return totalPrice;
  }

  void calculateDiscount(double value,
      {bool percentual = false, bool reset = false}) {
    calculateTotalPrice();

    if (reset) {
      discount = null;
      return;
    }

    if (percentual) {
      discount = value / 100 * totalPrice;
    } else {
      discount = value;
    }

    if (discount! <= totalPrice) {
      totalPrice -= discount!;
    } else {
      discount = null;
    }
  }
}
