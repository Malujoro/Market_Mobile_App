import 'package:market_mobile/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/pages/home_page.dart';
import 'package:market_mobile/pages/insights_page.dart';
import 'package:market_mobile/pages/product_item_page.dart';
import 'package:market_mobile/pages/product_page.dart';
import 'package:market_mobile/pages/product_store.dart';
import 'package:market_mobile/repositories/repository.dart';

// const Color.fromARGB(255, 243, 236, 245)

// TODO: utilizar a função showProductItemPage no botão de adicionar produto e no toque de editar produto
// TODO: Talvez utilizar o deslizar para excluir um produto
// TODO: Criar toda a página de vendas
// TODO: Criar toda a página de usuário (com login)

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;

  final ProductStore store = ProductStore(
    repository: ProductRepository(
      client: HttpClient(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Logo"),
        ),
        floatingActionButton: currentPageIndex != 2
            ? null
            : SizedBox(
                width: 75,
                height: 75,
                child: FloatingActionButton(
                  onPressed: () {
                    print("Botão flutuante");
                  },
                  backgroundColor: const Color.fromARGB(255, 243, 236, 245),
                  foregroundColor: Colors.black,
                  child: const Icon(Icons.add, size: 64),
                ),
              ),
        backgroundColor: Colors.white,
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
          ProductPage(store: store),
          Container(
            color: const Color.fromARGB(255, 243, 236, 245),
          ),
        ][currentPageIndex],
      ),
    );
  }

  void showProductItemPage(Product? product) async {
    final Product? retProduct = await Navigator.push(
        context,
        MaterialPageRoute<Product>(
            builder: (context) => ProductItemPage(
                  product: product,
                )));
    if (retProduct != null) {
      if (product != null) {
        // TODO: Criar o putProduct (para atualizar ele no banco)
      } else {
        // TODO: Criar o postProduct (para adicionar ele no banco)
      }
    }
    setState(() {
      store.getProducts();
    });
  }
}
