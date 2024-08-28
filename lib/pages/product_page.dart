import 'package:flutter/material.dart';
import 'package:market_mobile/http/http_client.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/pages/product_item_page.dart';
import 'package:market_mobile/pages/product_store.dart';
import 'package:market_mobile/repositories/repository.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductStore store = ProductStore(
    repository: ProductRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
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
                      for (Product product in store.state.value)
                        product.productWidget(richTextCreator),
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

  void showProductPage(Product? product) async {
    final Product? retProduct = await Navigator.push(
        context,
        MaterialPageRoute<Product>(
            builder: (context) => ProductItemPage(
                  product: product,
                )));
    if (retProduct != null) {
      // TODO: Criar o putProduct (para atualizar ele no banco)
    } else {
      // TODO: Criar o postProduct (para adicionar ele no banco)
    }
    setState(() {
      // TODO: Criar CallBack para o MyApp conseguir usar a showProductPage também
      store.getProducts();
    });
  }
}

// TODO: Criar o deleteProduct (para excluir ele do banco)
