// Exceção que será lançada caso a URL da API não seja válida
class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}