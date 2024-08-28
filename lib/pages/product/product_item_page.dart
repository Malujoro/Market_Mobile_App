import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';
import 'package:market_mobile/models/product.dart';

class ProductItemPage extends StatefulWidget {
  const ProductItemPage({super.key, this.product});

  final Product? product;
  // widget.product
  @override
  State<ProductItemPage> createState() => _ProductItemPageState();
}

// TODO: Criar toda a página para adicionar / editar um produto existente

class _ProductItemPageState extends State<ProductItemPage>
    with ValidationsMixin {
  late Product editedProduct;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool userEdited = false;
  @override
  void initState() {
    super.initState();
    if (widget.product == null) {
      editedProduct = Product(name: "", price: 0);
    } else {
      editedProduct = widget.product!;
    }
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
          final bool shouldPop = await requestPop();
          if (shouldPop) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: widget.product == null
                ? const Text("Produto",
                    style: TextStyle(fontWeight: FontWeight.bold))
                : Text(editedProduct.name),
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
                      controller: barCodeController,
                      keyboardType: TextInputType.text,
                      validator: (value) => minLength(
                        value,
                        12,
                        "O código de barras deve ter 12 dígitos",
                      ),
                      onChanged: (value) {
                        userEdited = true;
                        editedProduct.barCode = value;
                      },
                      inputFormatters: [
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
                        userEdited = true;
                        editedProduct.name = value;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
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
                        userEdited = true;
                        if (value.isEmpty) {
                          editedProduct.price = 0;
                        } else {
                          editedProduct.price = double.parse(value);
                        }
                      },
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
                        userEdited = true;
                        editedProduct.description = value;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // print("")
                        }
                      },
                      child: const Text(
                        "Salvar produto",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    // Text("Teste"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> requestPop() {
    if (userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Descartar Alterações?",
              style: TextStyle(fontSize: 25),
            ),
            content: const Text(
              "Se sair as alterações serão perdidas!",
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancelar",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Sim",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
