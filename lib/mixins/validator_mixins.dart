import 'package:email_validator/email_validator.dart';

mixin ValidationsMixin {
  String? isNotEmpty(String? value, [String? message]) {
    if (value!.isEmpty) {
      return message ?? "Este campo é obrigatório";
    }
    return null;
  }

  String? isPositive(String? value, [String? message]) {
    if (value!.isNotEmpty && double.parse(value) <= 0) {
      return message ?? "O valor deve ser positivo";
    }
    return null;
  }

  String? minLength(String? value, int length, [String? message]) {
    if (value!.isNotEmpty && value.length < length) {
      return message ?? "Mínimo de $length caracteres";
    }
    return null;
  }

  String? emailValid(String? value, [String? message]) {
    if (value!.isNotEmpty && !EmailValidator.validate(value)) {
      return message ?? "Insira um email válido";
    }
    return null;
  }

  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();
      if (validation != null) return validation;
    }
    return null;
  }
}
