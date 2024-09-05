import 'package:flutter/material.dart';

mixin DialogueMixins {
  void displayDialog(BuildContext context, Widget title, Widget text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: text,
      ),
    );
  }

  void goBackDialogue(
      {required BuildContext context,
      required String title,
      required String content,
      String cancel = "Cancelar",
      String confirm = "Sim",
      Function? confirmFunc,
      var returnItem}) {
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
                Navigator.pop(context, returnItem);
                if (confirmFunc != null) {
                  confirmFunc();
                }
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

  PopScope goBackDialogueAlter(
      {required BuildContext context,
      required String title,
      required String content,
      required Widget child,
      bool condition = true,
      Function? confirmFunc}) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (condition) {
          goBackDialogue(
            context: context,
            title: title,
            content: content,
            confirmFunc: confirmFunc,
          );
        } else {
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }
}
