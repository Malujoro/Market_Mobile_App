import 'package:flutter/material.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/mixins/hour_mixins.dart';
import 'package:market_mobile/models/sale.dart';
import 'package:market_mobile/pages/sale/sale_item_page.dart';
import 'package:market_mobile/stores/sale_store.dart';

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

class _InsightsPageState extends State<InsightsPage>
    with HourMixins, DialogueMixins {
  late final SaleStore saleStore;
  late String dropdownValue;
  late int dropdownIndex;

  DateTime? start;
  DateTime? end;

  @override
  void initState() {
    super.initState();
    saleStore = widget.saleStore;
    dropdownIndex = widget.dropdownIndex[0];
    dropdownValue = dayList[dropdownIndex];
    loadSales(context, loadData: saleStore.state.value.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        saleStore.isLoading,
        saleStore.state,
      ]),
      builder: (context, child) {
        if (saleStore.isLoading.value) {
          return const CircularProgressIndicator();
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
                            start = null;
                            end = null;
                          });
                          loadSales(context);
                        }
                      },
                      items: [
                        for (int i = 0; i < Day.values.length; i++)
                          DropdownMenuItem(
                              value: dayList[i], child: Text(dayList[i]))
                      ]),
                  const SizedBox(width: 60),
                  GestureDetector(
                    onTap: () async {
                      DateTimeRange? result = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000), // the earliest allowable
                        lastDate: DateTime(2999), // the latest allowable
                        currentDate: DateTime.now(),
                        errorFormatText: "dia/mês/ano",
                        keyboardType: TextInputType.text,
                      );
                      if (result != null && context.mounted) {
                        start = result.start;
                        end = result.end;
                        saleStore.getSales(context, start, end);
                      }
                    },
                    child: const Icon(
                      Icons.calendar_today,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: start != null && end != null,
              child: Text(
                start == null || end == null
                    ? ""
                    : "Vendas de ${timeToString(start!, hour: false)} até ${timeToString(end!, hour: false)}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Flexible(
              child: RefreshIndicator(
                displacement: 5,
                onRefresh: () {
                  return loadSales(context);
                },
                child: Container(
                  alignment:
                      saleStore.state.value.isEmpty ? Alignment.center : null,
                  height: 530,
                  margin: const EdgeInsets.only(
                      left: 35, right: 35, bottom: 35, top: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 236, 245),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: saleStore.state.value.isEmpty
                        ? const [
                            Text(
                              "Nenhuma venda nesta data",
                              textAlign: TextAlign.center,
                            )
                          ]
                        : [
                            for (Sale sale in saleStore.state.value)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SaleItemPage(
                                                sale: sale,
                                                showOnly: true,
                                              )));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: sale.productWidget(context)),
                              )
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

  Future<void> loadSales(BuildContext context, {bool loadData = true}) async {
    dropdownIndex = dayList.indexOf(dropdownValue);
    widget.dropdownIndex[0] = dropdownIndex;

    if (dropdownIndex == Day.all.index) {
      saleStore.getSales(context);
      return;
    }

    end = DateTime.now().add(
      const Duration(hours: 3),
    );

    if (dropdownIndex == Day.day.index) {
      start = end!.subtract(
        const Duration(days: 1),
      );
    } else if (dropdownIndex == Day.week.index) {
      start = end!.subtract(
        const Duration(days: 7),
      );
    } else if (dropdownIndex == Day.month.index) {
      start = DateTime(
        end!.year,
        end!.month - 1,
        end!.day,
        end!.hour,
        end!.minute,
        end!.second,
        end!.millisecond,
        end!.microsecond,
      );
    } else if (dropdownIndex == Day.year.index) {
      start = DateTime(
        end!.year - 1,
        end!.month,
        end!.day,
        end!.hour,
        end!.minute,
        end!.second,
        end!.millisecond,
        end!.microsecond,
      );
    }
    if (loadData) {
      saleStore.getSales(context, start, end);
    }
  }
}
