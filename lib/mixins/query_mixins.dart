import 'package:market_mobile/http/exceptions.dart';

mixin QueryMixins {
  bool verifyQuery(int responseCode, {String? text}) {
    if (responseCode == 200) {
      return true;
    } else if (responseCode == 404) {
      throw NotFoundException("A URL informada não é válida");
    } else if (responseCode == 401) {
      throw ExpiredTokenException("Sessão expirada");
    } else if (responseCode == 403) {
      throw InvalidSessionException("A assinatura não está ativa");
    } else {
      throw Exception(text ?? "Erro $responseCode");
    }
  }
}
