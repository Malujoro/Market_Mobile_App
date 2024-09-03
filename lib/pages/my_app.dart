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
import 'package:market_mobile/stores/product_store.dart';
import 'package:market_mobile/pages/navigation/user_page.dart';
import 'package:market_mobile/repositories/product_repository.dart';
// const Color.fromARGB(255, 243, 236, 245)

// TODO: Talvez criar uma ação no Appbar para escolher como ordenar produtos e/ou vendas
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

class _MyAppState extends State<MyApp> with DialogueMixins, TokenMixins {
  _MyAppState();

  int currentPageIndex = 0;

  late ProductStore productStore;

  @override
  void initState() {
    super.initState();
    productStore = ProductStore(
      repository: ProductRepository(
        client: HttpClient(),
        jwt: widget.jwt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          goBackDialogue(
            context: context,
            title: "Efetuar logout?",
            content: "Você irá voltar para a tela de login",
            confirmFunc: () {
              tokenSet("");
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Logo"),
          ),
          floatingActionButton:
              currentPageIndex != 2 || productStore.isLoading.value
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
          body: Center(
            child: [
              HomePage(
                productStore: productStore,
              ),
              const InsightsPage(),
              ProductPage(
                  store: productStore,
                  showProductItemPage: showProductItemPage),
              const UserPage(),
            ][currentPageIndex],
          ),
        ),
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
        await productStore.putProduct(retProduct);
      } else {
        await productStore.postProduct(retProduct);
      }
    }
    setState(() {
      productStore.getProducts(Order.ascAZ);
    });
  }
}
