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

class _SaleItemPageState extends State<SaleItemPage> with ValidationsMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController barCodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController partialPriceController = TextEditingController();

  bool userEdited = false;
  Product? selectedProduct;
  SaleProduct saleProduct = SaleProduct(
      productBarCode: "", productName: "", quantity: 0, partialPrice: 0);

  @override
  void initState() {
    super.initState();
    partialPriceController.text = "0";
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
                              for (int i = 0; i < 2; i++)
                                Card(child: Text("Olá mundo $i")),
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
                                nameController.clear();
                                selectedProduct = null;
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
                                      barCodeController.clear();
                                      nameController.clear();
                                      partialPriceController.text = "0";
                                      selectedProduct = null;
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

                            saleProduct.productBarCode = product.barCode;
                            saleProduct.productName = product.name;
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
                            // TODO: Implementar o cálculo do preço parcial do produto de maneira automática
                            // if notEmpty && != "0"
                            // int value = int.parse(quantityController.text)
                            // partialPriceController.text = value * products[index].price
                            userEdited = true;
                            if (value.isEmpty) {
                              partialPriceController.text = "0";
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
                              // TODO: Adicionar o produto no fim da lista de produtos da venda
                              // products.add(product);
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

      saleProduct.productBarCode = product[0].barCode;
      saleProduct.productName = product[0].name;

      if (quantityController.text.isNotEmpty) {
        updatePartialPrice(product[0].price, quantityController.text);
      }
    }
  }

  void updatePartialPrice(double price, String quantity) {
    if (quantity.isEmpty) {
      partialPriceController.text = "0";
    } else {
      double result = price * double.parse(quantity);
      partialPriceController.text = result.toStringAsFixed(2);
    }
  }
}
