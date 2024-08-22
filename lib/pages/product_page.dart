import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search),
                labelText: "Pesquisar produto",
                filled: true,
                fillColor: const Color.fromARGB(255, 243, 236, 245),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 243, 236, 245),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: [
                  for (int i = 0; i < 100; i++) Text("${i + 1} [Olá Mundo]")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
