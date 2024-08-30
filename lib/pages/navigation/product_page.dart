import 'package:flutter/material.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/pages/product/product_store.dart';

// TODO: Criar o deleteProduct (para excluir ele do banco)
// TODO: Fazer uma ordenação alfabética ("Padrão") pelo nome do produto
// TODO: Fazer o sistema de busca de produtos

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.store, required this.showProductItemPage});

  final ProductStore store;
  final Function({Product? product}) showProductItemPage;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late final ProductStore store;

  @override
  void initState() {
    store = widget.store;
    super.initState();
    store.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        store.isLoading,
        store.error,
        store.state,
      ]),
      builder: (context, child) {
        if (store.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (store.error.value.isNotEmpty) {
          return Center(
            child: Text(store.error.value),
          );
        }

        if (store.state.value.isEmpty) {
          return const Center(
            child: Text("Nenhum produto cadastrado"),
          );
        }

        return Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          print("Search");
                        },
                        icon: const Icon(Icons.search)),
                    labelText: "Pesquisar produto",
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
                      for (Product product in store.state.value)
                        GestureDetector(
                          onTap: () {
                            widget.showProductItemPage(product: product);
                          },
                          child: Card(
                            child: product.productWidget(richTextCreator),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget richTextCreator(String label, String text) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
              text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: text),
        ],
      ),
    );
  }
}
