import 'package:market_mobile/http/exceptions.dart';

mixin QueryMixins {
  bool verifyQuery(int responseCode) {
    if (responseCode == 200) {
      return true;
    } else if (responseCode == 404) {
      throw NotFoundException("A URL informada não é válida");
    } else if (responseCode == 401) {
      throw ExpiredToken("Sessão expirada");
    } else {
      throw Exception("Não foi possível carregar os produtos");
    }
  }
}