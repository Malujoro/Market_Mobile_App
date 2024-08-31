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
      editedProduct = Product(name: "", price: 0, barCode: '');
    } else {
      editedProduct = widget.product!;

      nameController.text = editedProduct.name;
      priceController.text = editedProduct.price.toString();
      barCodeController.text = editedProduct.barCode;
      descriptionController.text = editedProduct.description;
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
          if (userEdited) {
            goBackDialogue(
              context: context,
              title: "Descartar Alterações?",
              content: "Se sair as alterações serão perdidas!",
            );
          } else {
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
                      readOnly: widget.product != null,
                      controller: barCodeController,
                      keyboardType: TextInputType.number,
                      validator: (value) => combine([
                        () => isNotEmpty(value),
                        () => minLength(value, 12,
                            "O código de barras deve ter 12 dígitos"),
                      ]),
                      onChanged: (value) {
                        userEdited = true;
                        editedProduct.barCode = value;
                      },
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
                        userEdited = true;
                        setState(() {
                          editedProduct.name = value;
                        });
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
                          Navigator.pop(context, editedProduct);
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
}
