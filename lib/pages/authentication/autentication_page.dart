import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';
import 'package:http/http.dart' as http;

enum Role { user, admin }

class AutenticationPage extends StatefulWidget {
  const AutenticationPage({super.key, this.register = false});

  final bool register;

  // widget.product
  @override
  State<AutenticationPage> createState() => _AutenticationPageState();
}

class _AutenticationPageState extends State<AutenticationPage>
    with ValidationsMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  bool userEdited = false;
  late String url;

  @override
  void initState() {
    super.initState();
    if (widget.register) {
      url = "https://marketmobile-api.onrender.com/auth/register";
    } else {
      url = "https://marketmobile-api.onrender.com/auth/login";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.register == true ? "Registrar usuário" : "Efetuar login",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => combine([
                      () => isNotEmpty(value),
                      () => emailValid(value),
                      // () => minLength(value, 2),
                    ]),
                    onChanged: (value) {
                      userEdited = true;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: !passwordVisible,
                    controller: passwordController,
                    validator: (value) => combine([
                      () => isNotEmpty(value),
                      () => minLength(value, 8),
                    ]),
                    onChanged: (value) {
                      userEdited = true;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Senha",
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible == true
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        )),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var result;
                        if (widget.register == true) {
                          result = await attemptRegister(
                              emailController.text, passwordController.text);
                        } else {
                          result = await attemptLogin(
                              emailController.text, passwordController.text);
                        }
                      }
                    },
                    child: Text(
                      widget.register == true
                          ? "Registrar usuário"
                          : "Efetuar login",
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  // Text("Teste"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future attemptLogin(String email, String password,
      [Role role = Role.user]) async {
    var response = await http.post(Uri.parse(url), body: {
      "email": email,
      "password": password,
    });
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    }
    // TODO: Erro 403 se não conseguir logar (usuário ou senha inválido)
    return null;
  }

  Future attemptRegister(String email, String password,
      [Role role = Role.user]) async {
    var response = await http.post(Uri.parse(url), body: {
      "email": email,
      "password": password,
      "role": role.toString(),
    });
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    }
    // TODO: Erro 400 se não conseguir registrar
    return null;
  }
}
