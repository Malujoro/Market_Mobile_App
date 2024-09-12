import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';
import 'package:market_mobile/models/sale.dart';
import 'package:market_mobile/models/sale_product.dart';

enum Discount { none, percentual, real }

List<String> discountList = [
  "Nenhum",
  "Porcentagem",
  "Reais",
];

class SaleItemPage extends StatefulWidget {
  const SaleItemPage({
    super.key,
    required this.sale,
    this.showOnly = false,
  });

  final Sale sale;
  final bool showOnly;

  @override
  State<SaleItemPage> createState() => _SaleItemPageState();
}

class _SaleItemPageState extends State<SaleItemPage>
    with ValidationsMixin, DialogueMixins {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController discountController = TextEditingController();

  late Sale sale;
  String dropdownValue = discountList.first;
  int dropdownIndex = 0;
  late bool showOnly;

  @override
  void initState() {
    super.initState();
    sale = widget.sale;
    showOnly = widget.showOnly;

    if (showOnly && sale.discount != null) {
      discountController.text = sale.discount!.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("Total: R\$${sale.totalPrice.toStringAsFixed(2)}"),
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
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
                      child: SizedBox(
                        height: 350,
                        // margin: const EdgeInsets.all(8),
                        child: Card(
                          color: const Color.fromARGB(255, 243, 236, 245),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              for (SaleProduct saleProduct in sale.saleProducts)
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: saleProduct.saleProductWidget(context),
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
                        Visibility(
                          visible: !showOnly,
                          child: const Text(
                            "Selecione o desconto desejado: ",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: !showOnly,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: DropdownButton(
                                  borderRadius: BorderRadius.circular(16),
                                  alignment: AlignmentDirectional.center,
                                  value: dropdownValue,
                                  padding: const EdgeInsets.all(5),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        dropdownValue = value;
                                        dropdownIndex =
                                            discountList.indexOf(dropdownValue);
                                        discountController.clear();
                                        updateDiscount("");
                                      });
                                    }
                                  },
                                  items: [
                                    for (int i = 0;
                                        i < Discount.values.length;
                                        i++)
                                      DropdownMenuItem(
                                        value: discountList[i],
                                        alignment: AlignmentDirectional.center,
                                        child: Text(discountList[i]),
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              padding: const EdgeInsets.all(16.0),
                              child: TextFormField(
                                enabled: dropdownIndex != Discount.none.index &&
                                    !showOnly,
                                controller: discountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                validator: (value) => combine([
                                  () => isPositive(value),
                                  dropdownIndex == Discount.real.index
                                      ? () => lessEqualThan(
                                            value,
                                            sale.totalPrice,
                                            "O desconto deve ser menor ou igual a R\$${sale.totalPrice.toStringAsFixed(2)}",
                                          )
                                      : () => lessEqualThan(
                                            value,
                                            100,
                                            "O desconto deve ser menor ou igual a 100%",
                                          )
                                ]),
                                onChanged: (value) {
                                  setState(() {
                                    bool isPercentual = dropdownIndex ==
                                        Discount.percentual.index;
                                    updateDiscount(
                                      value,
                                      percentual: isPercentual,
                                    );
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+(\.\d*)?')),
                                ],
                                decoration: InputDecoration(
                                  errorMaxLines: 2,
                                  labelText: "Desconto",
                                  prefix:
                                      dropdownIndex == Discount.real.index ||
                                              showOnly
                                          ? const Text("R\$ ")
                                          : null,
                                  suffix:
                                      dropdownIndex == Discount.percentual.index
                                          ? const Text(" %")
                                          : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 243, 236, 245),
                                  ),
                                  child: const Text("Voltar"),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Visibility(
                                visible: !showOnly,
                                child: Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      touchFinalSale(context);
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 243, 236, 245),
                                    ),
                                    child: const Text("Finalizar venda"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }

  void updateDiscount(String value, {bool percentual = false}) {
    if (value.isEmpty) {
      sale.calculateDiscount(0, reset: true);
    } else {
      sale.calculateDiscount(double.parse(value), percentual: percentual);
    }
  }

  void touchFinalSale(BuildContext context) {
    if (formKey.currentState!.validate()) {
      goBackDialogue(
          context: context,
          title: "Finalizar venda?",
          content: "Preço final: R\$${sale.totalPrice.toStringAsFixed(2)}",
          confirmFunc: () {
            Navigator.pop(context, sale);
          });
    }
  }
}
