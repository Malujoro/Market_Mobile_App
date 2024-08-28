import 'package:flutter/material.dart';
import 'package:market_mobile/pages/authentication/autentication_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          authenticationButtonCreate(context, "Efetuar Login"),
          const SizedBox(height: 30),
          authenticationButtonCreate(context, "Registrar-se", true),
        ],
      ),
    );
  }

  Widget authenticationButtonCreate(BuildContext context, String label,
      [bool register = false]) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AutenticationPage(register: register),
            ));
      },
      style: ElevatedButton.styleFrom(fixedSize: const Size(200, 70)),
      child: Text(
        label,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
