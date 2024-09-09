import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/models/sale.dart';
import 'package:market_mobile/models/sale_product.dart';
import 'package:market_mobile/pages/sale/sale_item_page.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key, required this.products});

  final List<Product> products;

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage>
    with ValidationsMixin, DialogueMixins {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController barCodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  bool userEdited = false;
  bool showKeyboard = false;
  Product? selectedProduct;

  List<SaleProduct> saleProducts = [];

  @override
  void initState() {
    super.initState();
    reset(all: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: goBackDialogueAlter(
          context: context,
          title: "Descartar venda?",
          content: "Se sair as informações da venda serão perdidas!",
          condition: userEdited,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Venda"),
              centerTitle: true,
            ),
            body: Center(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 75, left: 8, right: 8, top: 8),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: 450,
                            // margin: const EdgeInsets.all(8),
                            child: Card(
                              color: const Color.fromARGB(255, 243, 236, 245),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Nome",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Quant.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Preço",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(width: 63),
                                      ],
                                    ),
                                  ),
                                  for (SaleProduct saleProduct in saleProducts)
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: saleProduct.saleProductWidget(
                                        context,
                                        removeProduct: () {
                                          removeProduct(saleProduct);
                                        },
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TypeAheadField(
                              controller: barCodeController,
                              builder: (context, barCodeController, focusNode) {
                                return TextFormField(
                                  focusNode: focusNode,
                                  controller: barCodeController,
                                  keyboardType: showKeyboard
                                      ? TextInputType.number
                                      : TextInputType.none,
                                  validator: (value) => combine([
                                    () => isNotEmpty(value),
                                    () => minLength(value, 12,
                                        "O código de barras deve ter 12 dígitos"),
                                    () {
                                      List<Product> result =
                                          selectProduct(barCodeController.text);

                                      if (result.isEmpty) {
                                        return "Insira um código de barras que seja válido";
                                      }
                                      return null;
                                    }
                                  ]),
                                  onChanged: (value) {
                                    if (value.length == 12) {
                                      touchAddProduct();
                                    }

                                    reset(
                                      selectedProduct: true,
                                    );
                                    setState(() {
                                      userEdited = true;
                                    });
                                  },
                                  onFieldSubmitted: (value) {
                                    reset(quantity: true);
                                    focusNode.requestFocus();
                                  },
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(12),
                                  ],
                                  decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showKeyboard = !showKeyboard;
                                          });

                                          focusNode.unfocus();
                                          Future.delayed(const Duration(
                                                  milliseconds: 100))
                                              .then((value) {
                                            focusNode.requestFocus();
                                          });
                                        },
                                        icon: const Icon(Icons.search)),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          reset(
                                            barCode: true,
                                            selectedProduct: true,
                                          );
                                        },
                                        icon: const Icon(Icons.cancel)),
                                    labelText: "Código de barras",
                                  ),
                                );
                              },
                              suggestionsCallback: (String value) {
                                if (value.isEmpty) {
                                  return widget.products;
                                }
                                return selectAllProducts(value);
                              },
                              itemBuilder:
                                  (BuildContext context, Product product) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product.barCode,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                              onSelected: (Product product) {
                                userEdited = true;
                                barCodeController.text = product.barCode;
                                selectedProduct = product;
                                touchAddProduct();
                                reset(quantity: true);
                              },
                              emptyBuilder: (context) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Não há produto com esse código",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              validator: (value) => combine([
                                () => isNotEmpty(value),
                                () => isPositive(value),
                              ]),
                              onChanged: (value) {
                                setState(() {
                                  userEdited = true;
                                });
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                labelText: "Quantidade",
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: touchAddProduct,
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 243, 236, 245),
                                  ),
                                  child: const Text("Adicionar produto"),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                TextButton(
                                  onPressed: saleProducts.isEmpty
                                      ? null
                                      : () {
                                          touchDoSale(context);
                                        },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 243, 236, 245),
                                  ),
                                  child: const Text("Finalizar venda"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void touchDoSale(BuildContext context) {
    if (saleProducts.isNotEmpty) {
      Sale sale = Sale();
      sale.saleProducts = saleProducts;
      sale.calculateTotalPrice();

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SaleItemPage(sale: sale)));
    }
  }

  void touchAddProduct() {
    bool exist = false;
    if (formKey.currentState!.validate()) {
      selectedProduct = selectProduct(barCodeController.text)[0];

      if (selectedProduct != null) {
        for (SaleProduct saleProduct in saleProducts) {
          if (saleProduct.productBarCode == selectedProduct!.barCode) {
            setState(() {
              saleProduct.quantity += int.parse(quantityController.text);
            });
            exist = true;
            break;
          }
        }
        if (!exist) {
          SaleProduct saleProduct = SaleProduct(
              productBarCode: selectedProduct!.barCode,
              productName: selectedProduct!.name,
              quantity: int.parse(quantityController.text),
              partialPrice: selectedProduct!.price);
          setState(() {
            saleProducts.add(saleProduct);
          });
        }
        reset(all: true);
      }
    }
  }

  List<Product> selectAllProducts(String barCode) {
    List<Product> productsOption = widget.products.where(
      (Product product) {
        return product.barCode.contains(barCode);
      },
    ).toList();
    return productsOption;
  }

  List<Product> selectProduct(String barCode) {
    List<Product> productsOption = widget.products.where(
      (Product product) {
        return product.barCode == (barCode);
      },
    ).toList();
    return productsOption;
  }

  void reset(
      {bool all = false,
      bool barCode = false,
      bool quantity = false,
      bool selectedProduct = false}) {
    if (barCode || all) {
      barCodeController.clear();
    }
    if (quantity || all) {
      quantityController.text = "1";
    }
    if (selectedProduct || all) {
      this.selectedProduct = null;
    }
  }

  void removeProduct(SaleProduct saleProduct) {
    setState(() {
      saleProducts.remove(saleProduct);
    });
  }
}
