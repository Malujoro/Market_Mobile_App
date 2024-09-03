import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';

class SaleItemPage extends StatefulWidget {
  const SaleItemPage({super.key});

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      height: 300,
                      margin: const EdgeInsets.all(16),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (int i = 0; i < 30; i++)
                            Card(child: Text("Olá mundo $i")),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: barCodeController,
                    keyboardType: TextInputType.number,
                    validator: (value) => combine([
                      () => isNotEmpty(value),
                      () => minLength(
                          value, 12, "O código de barras deve ter 12 dígitos"),
                    ]),
                    onChanged: (value) {
                      userEdited = true;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    decoration: InputDecoration(
                      // contentPadding: const EdgeInsets.only(16),
                      prefixIcon: IconButton(
                        onPressed: () {
                          // TODO: Implementar o preenchimento do nome do produto de maneira automática
                          // if barCode inválido, acusar erro
                          // else
                          // nameController.text = products[index].name
                        },
                        icon: const Icon(Icons.search),
                      ),
                      labelText: "Código de barras",
                    ),
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
                      // TODO: Implementar o cálculo do preço parcial do produto de maneira automática
                      // if notEmpty && != "0"
                      // int value = int.parse(quantityController.text)
                      // partialPriceController.text = value * products[index].price
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
            ),
          ),
        ),
      ),
    );
  }
}
