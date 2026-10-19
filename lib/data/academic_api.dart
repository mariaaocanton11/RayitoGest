import 'dart:convert';
import 'package:http/http.dart' as http;

/// API proporcionada para el examen académico.
/// La API usa HTTP y Basic Auth: solo utilizar con fines del curso.
class AcademicApi {
  static const _base = 'http://143.198.118.203:8100/ejemplos/';
  static const _username = 'test';
  static const _password = 'test2023';

  Map<String, String> get _headers => {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        'Content-Type': 'application/json',
      };

  Future<dynamic> get(String path) async {
    final response = await http
        .get(Uri.parse('$_base$path'), headers: _headers)
        .timeout(const Duration(seconds: 20));
    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await http
        .post(Uri.parse('$_base$path'),
            headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 20));
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    final text = utf8.decode(response.bodyBytes);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error HTTP ${response.statusCode}: $text');
    }
    if (text.trim().isEmpty) return null;
    return jsonDecode(text);
  }
}
