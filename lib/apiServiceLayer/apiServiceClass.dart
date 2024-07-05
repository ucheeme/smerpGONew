import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxController {
  final baseUrl = 'https://api.example.com';

  Future<Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url);
    return Response(response.statusCode, response.body);
  }

  Future<Response> post(String endpoint, dynamic body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(url, body: body);
    return Response(response.statusCode, response.body);
  }

  Future<Response> put(String endpoint, dynamic body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(url, body: body);
    return Response(response.statusCode, response.body);
  }

  Future<Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url);
    return Response(response.statusCode, response.body);
  }
}

class Response {
  final int statusCode;
  final dynamic body;

  Response(this.statusCode, this.body);
}
