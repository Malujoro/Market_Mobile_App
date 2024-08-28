import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Realizar Venda",
              style: TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Conecte o leitor de código de barras e inicie a leitura dos produtos cadastrados",
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print("Começar Pressionado");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text("Começar"),
            ),
          ],
        ),
      ),
    );
  }
}
