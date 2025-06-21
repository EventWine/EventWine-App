import 'dart:convert';
import 'package:eventwine/feature/prensado/data/remote/prensado_model.dart';
import 'package:eventwine/core/app_constants.dart';
import 'package:http/http.dart' as http;

class PrensadoService {
  Future<List<Prensado>> obtenerPrensadoPorBatchId(int batchId) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/batch/$batchId/pressing');
    final resp = await http.get(url, headers: {'Content-Type': 'application/json'});
    
    if (resp.statusCode == 200) {
      final dynamic body = jsonDecode(resp.body);

      if (body is List) {
        return body.map((json) => Prensado.fromJson(json)).toList();
      } else if (body is Map<String, dynamic>) {
        return [Prensado.fromJson(body)];
      }
    }
    return [];
  }

  Future<Prensado?> crearPrensado(int batchId, Prensado p) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/$batchId/pressing');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return Prensado.fromJson(jsonDecode(resp.body));
    }
    return null;
  }
}