import 'dart:convert';

import 'package:market_mobile/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/pages/navigation/home_page.dart';
import 'package:market_mobile/pages/navigation/insights_page.dart';
import 'package:market_mobile/pages/product/product_item_page.dart';
import 'package:market_mobile/pages/navigation/product_page.dart';
import 'package:market_mobile/pages/product/product_store.dart';
import 'package:market_mobile/pages/profile/user_page.dart';
import 'package:market_mobile/repositories/repository.dart';

// const Color.fromARGB(255, 243, 236, 245)

// TODO: Talvez utilizar o deslizar para excluir um produto
// TODO: Criar toda a página de vendas

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

class _MyAppState extends State<MyApp> {
  _MyAppState();

  int currentPageIndex = 0;

  late ProductStore store;

  @override
  void initState() {
    super.initState();
    store = ProductStore(
      repository: ProductRepository(
        client: HttpClient(),
        jwt: widget.jwt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Logo"),
        ),
        floatingActionButton: currentPageIndex != 2 || store.isLoading.value
            ? null
            : SizedBox(
                width: 75,
                height: 75,
                child: FloatingActionButton(
                  onPressed: () {
                    showProductItemPage();
                  },
                  child: const Icon(Icons.add, size: 64),
                ),
              ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
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
        body: [
          const HomePage(),
          const InsightsPage(),
          ProductPage(store: store, showProductItemPage: showProductItemPage),
          const UserPage(),
        ][currentPageIndex],
      ),
    );
  }

  void showProductItemPage({Product? product}) async {
    final Product? retProduct = await Navigator.push(
      context,
      MaterialPageRoute<Product>(
        builder: (context) => ProductItemPage(
          product: product,
        ),
      ),
    );
    if (retProduct != null) {
      if (product != null) {
        await store.putProduct(retProduct);
      } else {
        await store.postProduct(retProduct);
      }
    }
    setState(() {
      store.getProducts();
    });
  }
}
