import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_mobile/mixins/validator_mixins.dart';

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
// TODO: widget.register
  bool userEdited = false;

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
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // print("")
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
}
