import 'package:flutter/material.dart';

// TODO: Adicionar as funcionalidades do insight

List<String> list = [
  "Últimas 24h",
  "Última semana",
  "Último mês",
  "Último ano",
];

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
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
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: [
                    for (String text in list)
                      DropdownMenuItem(value: text, child: Text(text))
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
            margin: const EdgeInsets.only(left: 35, right: 35, bottom: 35, top: 15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 236, 245),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: [
                for (int i = 0; i < 100; i++) Text("${i + 1} [Olá Mundo]")
              ],
            ),
          ),
        ),
      ],
    );
  }
}
