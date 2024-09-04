import 'package:flutter/material.dart';

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
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  String dropdownValue = dayList.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
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
            margin:
                const EdgeInsets.only(left: 35, right: 35, bottom: 35, top: 15),
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
  }

  List<Widget> showSales() {
    List<Widget> widgets = [];
    int index = dayList.indexOf(dropdownValue);
    late String text;

    if (index == Day.day.index) {
      text = "24 Horas";
    } else if (index == Day.week.index) {
      text = "7 Dias";
    } else if (index == Day.month.index) {
      text = "1 Mês";
    } else if (index == Day.year.index) {
      text = "1 Ano";
    } else if (index == Day.all.index) {
      text = "Todo o tempo";
    } else {
      text = "Valor inválido";
    }

    for (int i = 0; i < 100; i++) {
      widgets.add(Text("${i + 1} [$text]"));
    }

    return widgets;
  }
}
