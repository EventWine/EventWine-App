import 'dart:convert';
import 'package:eventwine/feature/prensado/data/remote/prensado_model.dart';
import 'package:eventwine/core/app_constants.dart';
import 'package:http/http.dart' as http;

class PrensadoService {
  // Changed return type to Future<List<Prensado>>
  Future<List<Prensado>> obtenerPrensadoPorBatchId(int batchId) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/batch/$batchId/pressing');
    final resp = await http.get(url, headers: {'Content-Type': 'application/json'});
    
    if (resp.statusCode == 200) {
      final dynamic body = jsonDecode(resp.body); // Use dynamic to handle both single object or list

      if (body is List) { // If the API returns a list of pressings
        return body.map((json) => Prensado.fromJson(json)).toList();
      } else if (body is Map<String, dynamic>) { // If the API returns a single pressing
        // If your API returns a single object even when asking for "all pressings for a batch",
        // you might need to decide if this should be a list with one item, or if the API
        // should always return a list. For now, we'll put it in a list.
        return [Prensado.fromJson(body)];
      }
    }
    // Return an empty list if there's no data or an error
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