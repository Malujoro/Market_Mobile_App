// Exceção que será lançada caso a URL da API não seja válida
class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  @override
  String toString() {
    return message;
  }
}

class ExpiredTokenException implements Exception {
  final String message;

  ExpiredTokenException(this.message);

  @override
  String toString() {
    return message;
  }
}

class InvalidSessionException implements Exception {
  final String message;

  InvalidSessionException(this.message);

  @override
  String toString() {
    return message;
  }
}
