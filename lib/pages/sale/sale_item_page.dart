import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';
import 'package:market_mobile/models/product.dart';
import 'package:market_mobile/models/sale_product.dart';

class SaleItemPage extends StatefulWidget {
  const SaleItemPage({super.key, required this.products});

  final List<Product> products;

  @override
  State<SaleItemPage> createState() => _SaleItemPageState();
}

// TODO adicionar a confirmação de voltar atrás
// TODO adicionar o botão de finalizar venda (com um diálogo de confirmação) - PostSale
// TODO Deixar os SaleProducts removíveis (deslizar também)

class _SaleItemPageState extends State<SaleItemPage> with ValidationsMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController barCodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController partialPriceController = TextEditingController();

  bool userEdited = false;
  Product? selectedProduct;

  List<SaleProduct> saleProducts = [];

  @override
  void initState() {
    super.initState();
    reset(partialPrice: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Venda"),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 25, left: 8, right: 8, top: 8),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        height: 350,
                        margin: const EdgeInsets.all(16),
                        child: Card(
                          color: const Color.fromARGB(255, 243, 236, 245),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (SaleProduct saleProduct in saleProducts)
                                saleProduct.saleProductWidget(richTextCreator)
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
                              keyboardType: TextInputType.number,
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
                                reset(
                                    name: true,
                                    selectedProduct: true,
                                    partialPrice: true);
                                userEdited = true;
                              },
                              onFieldSubmitted: (value) {
                                updateName(value);
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                              ],
                              decoration: InputDecoration(
                                prefixIcon: IconButton(
                                    onPressed: () {
                                      updateName(barCodeController.text);
                                    },
                                    icon: const Icon(Icons.search)),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      reset(
                                          barCode: true,
                                          name: true,
                                          selectedProduct: true,
                                          partialPrice: true);
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
                          itemBuilder: (BuildContext context, Product product) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.barCode,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          },
                          onSelected: (Product product) {
                            barCodeController.text = product.barCode;
                            nameController.text = product.name;
                            selectedProduct = product;
                            updatePartialPrice(
                                product.price, quantityController.text);
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
                          enabled: false,
                          readOnly: true,
                          controller: nameController,
                          decoration: const InputDecoration(labelText: "Nome"),
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
                            userEdited = true;
                            if (value.isEmpty) {
                              reset(partialPrice: true);
                            } else if (selectedProduct != null) {
                              updatePartialPrice(selectedProduct!.price, value);
                            }
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: "Quantidade",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          enabled: false,
                          readOnly: true,
                          controller: partialPriceController,
                          decoration: const InputDecoration(
                            labelText: "Preço parcial",
                            prefix: Text("R\$ "),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              SaleProduct saleProduct = SaleProduct(
                                  productBarCode: selectedProduct!.barCode,
                                  productName: selectedProduct!.name,
                                  quantity: int.parse(quantityController.text),
                                  partialPrice: double.parse(
                                      partialPriceController.text));
                              setState(() {
                                saleProducts.add(saleProduct);
                              });
                              reset(all: true);
                            }
                          },
                          child: const Text("Adicionar produto"),
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
    );
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

  void updateName(String barCode) {
    List<Product> product = selectProduct(barCode);
    if (product.isNotEmpty) {
      selectedProduct = product[0];
      nameController.text = selectedProduct!.name;

      if (quantityController.text.isNotEmpty) {
        updatePartialPrice(product[0].price, quantityController.text);
      }
    }
  }

  void updatePartialPrice(double price, String quantity) {
    if (quantity.isEmpty) {
      reset(partialPrice: true);
    } else {
      double result = price * double.parse(quantity);
      partialPriceController.text = result.toStringAsFixed(2);
    }
  }

  void reset(
      {bool all = false,
      bool barCode = false,
      bool name = false,
      bool quantity = false,
      bool partialPrice = false,
      bool selectedProduct = false}) {
    if (barCode || all) {
      barCodeController.clear();
    }
    if (name || all) {
      nameController.clear();
    }
    if (quantity || all) {
      quantityController.clear();
    }
    if (partialPrice || all) {
      partialPriceController.text = "0";
    }
    if (selectedProduct || all) {
      this.selectedProduct = null;
    }
  }

  Widget richTextCreator(String label, String text) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.4),
        children: [
          TextSpan(
              text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: text),
        ],
      ),
    );
  }
}
