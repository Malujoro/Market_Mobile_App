import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';
import 'package:http/http.dart' as http;

enum Role { user, admin }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ValidationsMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  bool userEdited = false;
  bool register = false;

  @override
  Widget build(BuildContext context) {
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
                  // () => emailValid(value),
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
                      var result = await attemptLogin(
                          emailController.text, passwordController.text);
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
                      var result = await attemptRegister(
                          emailController.text, passwordController.text);
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
  }

  Future<Map<String, String>?> attemptLogin(String email, String password,
      [Role role = Role.user]) async {
    isLoading.value = true;
    Map<String, String> headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://marketmobile-api.onrender.com/auth/login'),
    );
    request.body = json.encode({
      "email": email,
      "password": password,
    });
    request.headers.addAll(headers);
    isLoading.value = false;

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map<String, String> teste =
          jsonDecode(await response.stream.bytesToString());
      print(teste);
      print(teste["token"]);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future attemptRegister(String email, String password,
      [Role role = Role.user]) async {
    isLoading.value = true;
    var response = await http.post(
        Uri.parse("https://marketmobile-api.onrender.com/auth/register"),
        body: {
          "email": email,
          "password": password,
          "role": role.toString(),
        });
    isLoading.value = false;
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    }
    return null;
  }
}
