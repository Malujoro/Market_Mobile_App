import 'package:flutter/material.dart';
import 'package:market_mobile/models/sale.dart';
import 'package:market_mobile/models/sale_product.dart';
import 'package:market_mobile/stores/sale_store.dart';

// TODO: Adicionar as funcionalidades do insight

enum Day { day, week, month, year, all }

List<String> dayList = [
  "Últimas 24h",
  "Última semana",
  "Último mês",
  "Último ano",
  "Todas as vendas",
];

class InsightsPage extends StatefulWidget {
  const InsightsPage(
      {super.key, required this.saleStore, this.dropdownIndex = const [0]});

  final SaleStore saleStore;
  final List<int> dropdownIndex;

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  late final SaleStore saleStore;
  late String dropdownValue;
  late int dropdownIndex;

  @override
  void initState() {
    super.initState();
    saleStore = widget.saleStore;
    dropdownIndex = widget.dropdownIndex[0];
    dropdownValue = dayList[dropdownIndex];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        saleStore.isLoading,
        saleStore.error,
        saleStore.state,
      ]),
      builder: (context, child) {
        if (saleStore.isLoading.value) {
          return const CircularProgressIndicator();
        }

        if (saleStore.error.value.isNotEmpty) {
          return Text(saleStore.error.value);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                      borderRadius: BorderRadius.circular(16),
                      value: dropdownValue,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            dropdownValue = value;
                          });
                        }
                      },
                      items: [
                        for (int i = 0; i < Day.values.length; i++)
                          DropdownMenuItem(
                              value: dayList[i], child: Text(dayList[i]))
                      ]),
                  const SizedBox(width: 60),
                  GestureDetector(
                    onTap: () {
                      print("Calendário Tocado");
                    },
                    child: const Icon(
                      Icons.calendar_today,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 35, right: 35, bottom: 35, top: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 236, 245),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: showSales(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> showSales() {
    List<Widget> widgets = [];
    dropdownIndex = dayList.indexOf(dropdownValue);
    widget.dropdownIndex[0] = dropdownIndex;

    if (dropdownIndex == Day.day.index) {
      saleStore.state.value = [];
    } else if (dropdownIndex == Day.week.index) {
      saleStore.state.value = [];
    } else if (dropdownIndex == Day.month.index) {
      saleStore.state.value = [];
    } else if (dropdownIndex == Day.year.index) {
      saleStore.state.value = [];
    } else if (dropdownIndex == Day.all.index) {
      saleStore.getSales();
    } else {
      saleStore.state.value = [];
    }

    if (saleStore.state.value.isEmpty) {
      widgets.add(
        const Text(
          "Nenhuma venda nesta data",
          textAlign: TextAlign.center,
        ),
      );
    } else {
      for (Sale sale in saleStore.state.value) {
        widgets.add(sale.productWidget(context));
      }
    }

    return widgets;
  }
}
