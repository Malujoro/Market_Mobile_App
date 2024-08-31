import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class InterfaceHttpClient {
  Future get({
    required String url,
    required String token,
  });
  Future query({
    required String url,
    required String token,
    required Map<String, dynamic> map,
    required String type,
  });
  Future delete({
    required String url,
    required String token,
    required String barCode,
  });
}

class HttpClient implements InterfaceHttpClient {
  final client = http.Client();

  @override
  Future get({
    required String url,
    required String token,
  }) async {
    return await client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  @override
  Future query({
    required String url,
    required String token,
    required Map<String, dynamic> map,
    required String type,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.Request(type, Uri.parse(url));
    request.body = json.encode(map);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    return response.statusCode;
  }

  @override
  Future delete({
    required String url,
    required String token,
    required String barCode,
  }) async {
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var request = http.Request('DELETE', Uri.parse("$url/$barCode"));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response.statusCode;
  }
}
