import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market_mobile/models/sale_product.dart';

class Sale {
  List<SaleProduct> saleProducts = [];
  double totalPrice = 0;
  DateTime date = DateTime.now();

  Sale();

  factory Sale.fromMap(Map<String, dynamic> map) {
    Sale sale = Sale();
    sale.saleProducts = map["saleProducts"];
    sale.totalPrice = map["totalPrice"];
    sale.date = map["date"];
    return sale;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "saleProducts": saleProducts,
      "totalPrice": totalPrice,
    };
    return map;
  }

  Widget productWidget(Function richTextCreator) {
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
                "Preço total: ", "R\$${totalPrice.toStringAsFixed(2)}"),
            richTextCreator(
                "Data: ", DateFormat('yyyy-MM-dd - kk:mm').format(date)),
          ],
        ),
      ),
    );
  }
}
