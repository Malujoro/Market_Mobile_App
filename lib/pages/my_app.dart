import 'dart:convert';

import 'package:market_mobile/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/mixins/token_mixins.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/pages/navigation/home_page.dart';
import 'package:market_mobile/pages/navigation/insights_page.dart';
import 'package:market_mobile/pages/product/product_item_page.dart';
import 'package:market_mobile/pages/navigation/product_page.dart';
import 'package:market_mobile/repositories/sale_repository.dart';
import 'package:market_mobile/stores/product_store.dart';
import 'package:market_mobile/pages/navigation/user_page.dart';
import 'package:market_mobile/repositories/product_repository.dart';
import 'package:market_mobile/stores/sale_store.dart';
// const Color.fromARGB(255, 243, 236, 245)

// TODO: Criar ação no Appbar para escolher como ordenar produtos e/ou vendas

enum PageIndex { home, insights, product, user }

class MyApp extends StatefulWidget {
  const MyApp(this.jwt, this.payload, {super.key});

  factory MyApp.fromBase64(String jwt) => MyApp(
        jwt,
        json.decode(
          ascii.decode(
            base64.decode(
              base64.normalize(
                jwt.split(".")[1],
              ),
            ),
          ),
        ),
      );

  final String jwt;
  final Map payload;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with DialogueMixins, TokenMixins {
  _MyAppState();

  int currentPageIndex = 0;
  late List<int> dropdownIndex;

  late ProductStore productStore;
  late SaleStore saleStore;

  @override
  void initState() {
    super.initState();
    dropdownIndex = [0];

    productStore = ProductStore(
      repository: ProductRepository(
        client: HttpClient(),
        jwt: widget.jwt,
      ),
    );
    saleStore = SaleStore(
      repository: SaleRepository(
        client: HttpClient(),
        jwt: widget.jwt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: goBackDialogueAlter(
          context: context,
          title: "Efetuar logout?",
          content: "Você irá voltar para a tela de login",
          confirmFunc: () {
            tokenSet("");
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Logo"),
              actions: currentPageIndex == PageIndex.product.index
                  ? [
                      IconButton(
                          onPressed: () async {
                            productStore.getProducts(context);
                          },
                          icon: const Icon(Icons.refresh))
                    ]
                  : null,
            ),
            floatingActionButton: currentPageIndex != PageIndex.product.index ||
                    productStore.isLoading.value
                ? null
                : SizedBox(
                    width: 75,
                    height: 75,
                    child: FloatingActionButton(
                      onPressed: () {
                        showProductItemPage(context);
                      },
                      child: const Icon(Icons.add, size: 64),
                    ),
                  ),
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                if (!saleStore.isLoading.value &&
                    !productStore.isLoading.value) {
                  setState(() {
                    currentPageIndex = index;
                  });
                }
              },
              selectedIndex: currentPageIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home, size: 64),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart, size: 64),
                  label: "Insights",
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_bag_outlined, size: 64),
                  label: "Produtos",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline, size: 64),
                  label: "Perfil",
                ),
              ],
            ),
            body: Center(
              child: [
                HomePage(
                  productStore: productStore,
                  saleStore: saleStore,
                ),
                InsightsPage(
                    dropdownIndex: dropdownIndex, saleStore: saleStore),
                ProductPage(
                    store: productStore,
                    showProductItemPage: showProductItemPage),
                const UserPage(),
              ][currentPageIndex],
            ),
          ),
        ),
      ),
    );
  }

  void showProductItemPage(BuildContext context, {Product? product}) async {
    final Product? retProduct = await Navigator.push(
      context,
      MaterialPageRoute<Product>(
        builder: (context) => ProductItemPage(
          product: product,
        ),
      ),
    );
    if (retProduct != null && context.mounted) {
      if (product != null) {
        await productStore.putProduct(context, retProduct);
      } else {
        await productStore.postProduct(context, retProduct);
      }
      setState(() {
        productStore.getProducts(ProductOrder.ascAZ);
      });
    }
  }
}
