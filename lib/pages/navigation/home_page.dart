import 'package:flutter/material.dart';
import 'package:market_mobile/pages/sale/sale_item_page.dart';

// TODO: Adicionar todas as funcionalidades da Home

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
              // TODO: Talvez implementar o GetProducts aqui, já que a lista de produtos será necessária para efetuar as vendas
              // Fazer um if state.value.isEmpty para carregar os produtos
              showSaleItemPage();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text("Começar"),
          ),
        ],
      ),
    );
  }

  void showSaleItemPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SaleItemPage()));
  }
}
