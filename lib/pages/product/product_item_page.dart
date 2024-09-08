import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';
import 'package:market_mobile/models/product.dart';

class ProductItemPage extends StatefulWidget {
  const ProductItemPage({super.key, this.product});

  final Product? product;
  @override
  State<ProductItemPage> createState() => _ProductItemPageState();
}

class _ProductItemPageState extends State<ProductItemPage>
    with ValidationsMixin, DialogueMixins {
  late Product editedProduct;
  bool stock = false;
  bool warningStock = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController warningStockController = TextEditingController();

  bool userEdited = false;
  @override
  void initState() {
    super.initState();
    if (widget.product == null) {
      editedProduct = Product(name: "", price: 0, barCode: '');
    } else {
      editedProduct = widget.product!;

      nameController.text = editedProduct.name;
      priceController.text = editedProduct.price.toString();
      barCodeController.text = editedProduct.barCode;
      descriptionController.text = editedProduct.description;

      stock = editedProduct.stock != null;
      if (stock) {
        stockController.text = editedProduct.stock.toString();
      } else {
        resetStock(stockController: true);
      }

      warningStock = editedProduct.warningStock != null;
      if (warningStock) {
        warningStockController.text = editedProduct.warningStock.toString();
      } else {
        resetWarningStock(warningStockController: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: goBackDialogueAlter(
          context: context,
          title: "Descartar Alterações?",
          content: "Se sair as alterações serão perdidas!",
          condition: userEdited,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                  editedProduct.name.isEmpty ? "Produto" : editedProduct.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        readOnly: widget.product != null,
                        enabled: widget.product == null,
                        controller: barCodeController,
                        keyboardType: TextInputType.number,
                        validator: (value) => combine([
                          () => isNotEmpty(value),
                          () => minLength(value, 12,
                              "O código de barras deve ter 12 dígitos"),
                        ]),
                        onChanged: (value) {
                          setState(() {
                            userEdited = true;
                          });
                          editedProduct.barCode = value;
                        },
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(12),
                        ],
                        decoration: const InputDecoration(
                          labelText: "Código de barras",
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) => combine([
                          () => isNotEmpty(value),
                          () => minLength(value, 2),
                        ]),
                        onChanged: (value) {
                          setState(() {
                            userEdited = true;
                          });
                          setState(() {
                            editedProduct.name = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-z A-Z 0-9]"))
                        ],
                        decoration: const InputDecoration(
                          labelText: "Nome do Produto",
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => combine([
                          () => isNotEmpty(value),
                          () => isPositive(value),
                        ]),
                        onChanged: (value) {
                          setState(() {
                            userEdited = true;
                          });
                          if (value.isEmpty) {
                            editedProduct.price = 0;
                          } else {
                            editedProduct.price = double.parse(value);
                          }
                        },
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+(\.\d*)?')),
                        ],
                        decoration: const InputDecoration(
                          labelText: "Preço",
                          prefix: Text("R\$ "),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        minLines: 1,
                        maxLines: 3,
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        validator: (value) => minLength(
                          value,
                          2,
                          "O código de barras deve ter 12 dígitos",
                        ),
                        onChanged: (value) {
                          setState(() {
                            userEdited = true;
                          });
                          editedProduct.description = value;
                        },
                        onFieldSubmitted: (value) {
                          touchSave(context);
                        },
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-z A-Z 0-9]"))
                        ],
                        decoration: const InputDecoration(
                          labelText: "Descrição",
                        ),
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: TextFormField(
                          enabled: stock,
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          validator: (value) => combine([
                            () => isNotNegative(value),
                          ]),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              resetStock(all: true);
                            } else {
                              editedProduct.stock =
                                  int.parse(stockController.text);
                            }
                          },
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: "Controle de estoque",
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: stock,
                        onChanged: (bool? value) {
                          userEdited = true;
                          setState(
                            () {
                              stock = value!;
                              if (!stock) {
                                resetStock(all: true);
                                resetWarningStock(all: true);
                              }
                            },
                          );
                        },
                      ),
                      if (stock) const SizedBox(height: 16),
                      Visibility(
                        visible: stock,
                        child: CheckboxListTile(
                          title: TextFormField(
                            enabled: warningStock,
                            controller: warningStockController,
                            keyboardType: TextInputType.number,
                            validator: (value) => combine([
                              () => isNotNegative(value),
                            ]),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                resetWarningStock(all: true);
                              } else {
                                editedProduct.warningStock =
                                    int.parse(warningStockController.text);
                              }
                            },
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: "Valor crítico",
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: warningStock,
                          onChanged: (bool? value) {
                            userEdited = true;
                            setState(
                              () {
                                warningStock = value!;
                                if (!warningStock) {
                                  resetWarningStock(all: true);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          touchSave(context);
                        },
                        child: const Text(
                          "Salvar produto",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void touchSave(BuildContext context) {
    if (!stock) {
      resetStock(all: true);
      if (!warningStock) {
        resetWarningStock(all: true);
      }
    }
    if (formKey.currentState!.validate()) {
      Navigator.pop(context, editedProduct);
    }
  }

  void resetStock({
    bool all = false,
    bool stockController = false,
    bool stockEdited = false,
  }) {
    if (stockController || all) {
      this.stockController.clear();
    }

    if (stockEdited || all) {
      editedProduct.stock = null;
    }
  }

  void resetWarningStock({
    bool all = false,
    bool warningStockController = false,
    bool warningStockEdited = false,
  }) {
    if (warningStockController || all) {
      this.warningStockController.clear();
    }

    if (warningStockEdited || all) {
      editedProduct.warningStock = null;
    }
  }
}
