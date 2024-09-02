// Exceção que será lançada caso a URL da API não seja válida
class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}

class ExpiredToken implements Exception {
  final String message;

  ExpiredToken(this.message);
}