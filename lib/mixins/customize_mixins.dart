import 'package:flutter/material.dart';

mixin CustomizeMixins {
  Widget richTextCreator({required BuildContext context, required String label, required String text, TextStyle? style}) {
    return RichText(
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
              text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: text),
        ],
      ),
    );
  }
}