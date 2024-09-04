import 'package:flutter/material.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/pages/sale/sale_item_page.dart';
import 'package:market_mobile/stores/product_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.productStore});

  final ProductStore productStore;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ProductStore productStore;

  @override
  void initState() {
    super.initState();
    productStore = widget.productStore;
    if (productStore.state.value.isEmpty) {
      productStore.getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          productStore.isLoading,
          productStore.error,
          productStore.state,
          // TODO: Adicionar os de Sale também
        ]),
        builder: (context, child) {
          if (productStore.isLoading.value) {
            return const CircularProgressIndicator();
          }
      
          if (productStore.error.value.isNotEmpty) {
            return Text(productStore.error.value);
          }
      
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Realizar Venda",
                  style: TextStyle(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  productStore.state.value.isEmpty
                      ? "Cadastre alguns produtos antes de começar"
                      : "Conecte o leitor de código de barras e inicie a leitura dos produtos cadastrados",
                  style: const TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: productStore.state.value.isEmpty
                      ? null
                      : () {
                          showSaleItemPage(productStore.state.value);
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text("Começar"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showSaleItemPage(List<Product> products) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SaleItemPage(products: products)));
  }
}
