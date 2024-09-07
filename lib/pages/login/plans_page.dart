import 'package:flutter/material.dart';
import 'package:market_mobile/mixins/dialogue_mixins.dart';
import 'package:market_mobile/mixins/query_mixins.dart';
import 'package:market_mobile/mixins/token_mixins.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

const String url =
    "https://marketmobile-api.onrender.com/api/sub/create-checkout-session";

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage>
    with QueryMixins, DialogueMixins, TokenMixins {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // TODO ativar caso queira o pop up de saída da tela de plano
      // child: goBackDialogueAlter(
      //   context: context,
      //   title: "Já está indo?",
      //   content: "Deseja voltar para a tela de início?",
        // 
        // confirmFunc: () {
        //   Navigator.popUntil(
        //       context, ModalRoute.withName(Navigator.defaultRouteName));
        // },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Planos"),
            centerTitle: true,
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(40),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Plano padrão",
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Por apenas R\$X.XX por mês, você ganhará acesso às seguintes funcionalidades: ",
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\u2022 Gestão de vendas'),
                          Text('\u2022 Gestão de produtos'),
                          Text('\u2022 Controle de estoque'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          createSession(context);
                        },
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        child: const Text("Assine agora"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      // ),
    );
  }

  Future<void> openUrl(String link) async {
    Uri url = Uri.parse(link);

    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Não foi possível abrir o link: $link');
    }
  }

  Future<void> createSession(BuildContext context) async {
    try {
      String? jwt = await tokenGet();
      if (jwt != null && jwt.isNotEmpty) {
        final client = http.Client();

        var response = await client.post(
          Uri.parse(url),
          headers: {'Authorization': 'Bearer $jwt'},
        );

        if (verifyQuery(response.statusCode,
                text: "Não foi possível criar a sessão") &&
            response.body.isNotEmpty &&
            context.mounted) {
          openUrl(response.body);
        }
      }
    } catch (e) {
      if (context.mounted) {
        displayDialog(context, const Text("Erro"), Text(e.toString()));
      }
    }
  }
}
