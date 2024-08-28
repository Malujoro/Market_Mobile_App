import 'package:flutter/material.dart';
import 'package:market_mobile/models/product.dart';

class ProductItemPage extends StatefulWidget {
  const ProductItemPage({super.key, this.product});

  final Product? product;
  // widget.product
  @override
  State<ProductItemPage> createState() => _ProductItemPageState();
}

class _ProductItemPageState extends State<ProductItemPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Row(
        children: [
          // TODO: Criar toda a página para adicionar / editar um produto existente
          // TODO: Blindar código e nome com máximo de caracteres respectivos
          // TODO: Blindar Preço para ser positivo
          TextFormField(),
        ],
      ),
    ));
  }
}
