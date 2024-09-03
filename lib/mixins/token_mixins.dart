import 'package:flutter_secure_storage/flutter_secure_storage.dart';

mixin TokenMixins {
  final storage = const FlutterSecureStorage();
  String key = "jwt";

  void tokenSet(String jwt) {
    storage.write(key: key, value: jwt);
  }

  Future<String?> tokenGet() async {
    var jwt = await storage.read(key: key);
    return jwt;
  }
}
