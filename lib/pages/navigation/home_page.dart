import 'package:flutter/material.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/models/sale.dart';
import 'package:market_mobile/pages/sale/sale_item_page.dart';
import 'package:market_mobile/stores/product_store.dart';
import 'package:market_mobile/stores/sale_store.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key, required this.productStore, required this.saleStore});

  final ProductStore productStore;
  final SaleStore saleStore;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with DialogueMixins {
  late final ProductStore productStore;
  late final SaleStore saleStore;

  @override
  void initState() {
    super.initState();

    saleStore = widget.saleStore;

    productStore = widget.productStore;
    if (productStore.state.value.isEmpty) {
      productStore.getProducts(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          productStore.isLoading,
          productStore.state,
          saleStore.isLoading,
        ]),
        builder: (context, child) {
          if (productStore.isLoading.value || saleStore.isLoading.value) {
            return const CircularProgressIndicator();
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
                          showSaleItemPage(context, productStore.state.value);
                        },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text("Começar"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showSaleItemPage(BuildContext context, List<Product> products) async {
    final Sale? retSale = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaleItemPage(products: products),
      ),
    );
    if (retSale != null && context.mounted) {
      await saleStore.postSale(context, retSale);
    }
  }
}
