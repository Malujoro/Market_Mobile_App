import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/stores/product_store.dart';

class ProductPage extends StatefulWidget {
  const ProductPage(
      {super.key, required this.store, required this.showProductItemPage});

  final ProductStore store;
  final Function(BuildContext context, {Product? product}) showProductItemPage;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with DialogueMixins {
  late final ProductStore store;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    store = widget.store;
    if (store.state.value.isEmpty) {
      store.getProducts(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        store.isLoading,
        store.state,
      ]),
      builder: (context, child) {
        if (store.isLoading.value) {
          return const CircularProgressIndicator();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {});
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                  // TODO Retirando o filtro de caracteres especiais
                  // FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"))
                ],
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  labelText: "Pesquisar produto",
                ),
              ),
            ),
            Flexible(
              child: RefreshIndicator(
                displacement: 5,
                onRefresh: () {
                  return store.getProducts(context);
                },
                child: Container(
                  alignment:
                      store.state.value.isEmpty ? Alignment.center : null,
                  height: 530,
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 236, 245),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: store.state.value.isEmpty
                        ? const [
                            Text(
                              "Nenhum produto cadastrado",
                              textAlign: TextAlign.center,
                            )
                          ]
                        : [
                            for (Product product in store.state.value)
                              if (searchController.text.isEmpty ||
                                  product.name.toLowerCase().contains(
                                      searchController.text.toLowerCase()))
                                GestureDetector(
                                  onTap: () {
                                    widget.showProductItemPage(context,
                                        product: product);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                          extentRatio: 0.3,
                                          motion: const DrawerMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed:
                                                  (BuildContext context) {
                                                showDialogDeleteProduct(
                                                    product);
                                              },
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: "Excluir",
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(16),
                                                bottomRight:
                                                    Radius.circular(16),
                                              ),
                                            )
                                          ]),
                                      child: product.productWidget(context),
                                    ),
                                  ),
                                ),
                          ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDialogDeleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext builder) {
        return AlertDialog(
          title: const Text("Excluir produto?"),
          content: const Text(
              "Você deseja excluir o produto? é uma ação irreversível"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(builder).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(builder).pop();
                deleteProduct(product);
              },
              child: const Text("Sim"),
            ),
          ],
        );
      },
    );
  }

  void deleteProduct(Product product) async {
    await store.deleteProduct(context, product.barCode);
    if (store.error.value.isEmpty) {
      store.state.value.remove(product);
    }
  }
}
