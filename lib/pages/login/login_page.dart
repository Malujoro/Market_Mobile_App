import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:market_mobile/mixins/token_mixins.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';
import 'package:http/http.dart' as http;
import 'package:market_mobile/pages/my_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidationsMixin, TokenMixins {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // final storage = const FlutterSecureStorage();

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  bool userEdited = false;
  bool register = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginAuto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([isLoading]),
          builder: (context, child) {
            if (isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            tokenSet("");
            return Center(
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
                          () => minLength(value, 2),
                          // () => emailValid(value),
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
                      Visibility(
                        visible: register,
                        child: TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          validator: (value) => combine([
                            () => isNotEmpty(value),
                            () => minLength(value, 2),
                          ]),
                          onChanged: (value) {
                            userEdited = true;
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Nome de usuário",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: !passwordVisible,
                        controller: passwordController,
                        validator: (value) => combine([
                          () => isNotEmpty(value),
                          // () => minLength(value, 8),
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (register) {
                                setState(() {
                                  register = false;
                                });
                                return;
                              }

                              if (formKey.currentState!.validate()) {
                                var jwt = await attemptLogin(
                                    emailController.text,
                                    passwordController.text);

                                if (jwt != null) {
                                  tokenSet(jwt);
                                  // storage.write(key: 'jwt', value: jwt);
                                  goToMyApp(jwt);
                                } else {
                                  displayDialog(
                                    context,
                                    const Text("Tentativa de Login"),
                                    const Text(
                                        "Erro! Usuário ou senha inválidos"),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 50)),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: () async {
                              if (!register) {
                                setState(() {
                                  register = true;
                                });
                                return;
                              }

                              if (formKey.currentState!.validate()) {
                                int code = await attemptRegister(
                                    emailController.text,
                                    usernameController.text,
                                    passwordController.text);
                                if (code == 200) {
                                  displayDialog(
                                      context,
                                      const Text("Sucesso"),
                                      const Text(
                                          "Usuário registrado! Efetue o login"));
                                } else if (code == 400) {
                                  displayDialog(
                                      context,
                                      const Text(
                                          "Email já cadastrado"),
                                      const Text(
                                          "Utilize outro email ou efetue login se já possuir uma conta"));
                                } else {
                                  displayDialog(
                                      context,
                                      const Text("Erro"),
                                      const Text(
                                          "Ocorreu um erro desconhecido"));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 50)),
                            child: const Text(
                              "Registrar-se",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void goToMyApp(String jwt) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyApp.fromBase64(jwt)));
  }

  Future<void> loginAuto() async {
    var jwt = await tokenGet();
    // var jwt = await storage.read(key: 'jwt');

    if (jwt != null && jwt.isNotEmpty) {
      bool expired = JwtDecoder.isExpired(jwt);
      if (!expired) {
        goToMyApp(jwt);
      }
    }
  }

  Future<String?> attemptLogin(
    String email,
    String password,
  ) async {

    isLoading.value = true;
    Map<String, String> headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://marketmobile-api.onrender.com/auth/login'),
    );
    request.body = json.encode({
      "email": email.toLowerCase(),
      "password": password,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    isLoading.value = false;

    if (response.statusCode == 200) {
      Map<String, dynamic> mapa =
          jsonDecode(await response.stream.bytesToString());
      String token = mapa["token"].toString();
      return token;
    }
    return null;
  }

  Future<int> attemptRegister(
    String email,
    String username,
    String password,
  ) async {
    isLoading.value = true;
    Map<String, String> headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://marketmobile-api.onrender.com/auth/register'),
    );
    request.body = json.encode({
      "email": email.toLowerCase(),
      "username": username,
      "password": password,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    isLoading.value = false;

    return response.statusCode;
  }

  void displayDialog(BuildContext context, Widget title, Widget text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: text,
      ),
    );
  }
}
