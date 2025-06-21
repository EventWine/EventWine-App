import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eventwine/feature/embotellado/data/remote/embotellado_model.dart';
import 'package:eventwine/core/app_constants.dart'; // Asegúrate de que esta ruta sea correcta

class EmbotelladoService {
  Future<List<Embotellado>> obtenerEmbotelladosPorBatchId(int batchId) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/batch/$batchId/bottling');
    try {
      final resp = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (resp.statusCode == 200) {
        final dynamic body = jsonDecode(resp.body);

        if (body is List) {
          return body.map((json) => Embotellado.fromJson(json)).toList();
        }
        else if (body is Map<String, dynamic>) {
          return [Embotellado.fromJson(body)];
        }
      }
      print('Error al obtener embotellados por Batch ID. Status: ${resp.statusCode}, Body: ${resp.body}');
      return [];
    } catch (e) {
      print('Excepción al obtener embotellados por Batch ID: $e');
      return [];
    }
  }

  Future<Embotellado?> crearEmbotellado(int batchId, Embotellado embotellado) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/$batchId/bottling');
    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(embotellado.toJson()),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return Embotellado.fromJson(jsonDecode(resp.body));
      } else {
        print('Error al crear embotellado: ${resp.statusCode} - ${resp.body}');
        return null;
      }
    } catch (e) {
      print('Error en la solicitud de creación de embotellado: $e');
      return null;
    }
  }
}