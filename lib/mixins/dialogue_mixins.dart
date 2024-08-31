import 'package:flutter/material.dart';

mixin DialogueMixins {
  void goBackDialogue(
      {required BuildContext context,
      required String title,
      required String content,
      String cancel = "Cancelar",
      String confirm = "Sim"}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 25),
          ),
          content: Text(
            content,
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                cancel,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                confirm,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}
