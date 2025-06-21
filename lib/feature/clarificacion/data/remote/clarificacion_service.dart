import 'dart:convert';
import 'package:eventwine/feature/clarificacion/data/remote/clarificacion_model.dart';
import 'package:eventwine/core/app_constants.dart';
import 'package:http/http.dart' as http;

class ClarificacionService {
  Future<List<Clarificacion>> obtenerClarificacionesPorBatchId(int batchId) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/batch/$batchId/clarification');
    print('➡️ Solicitando clarificaciones desde: $url');

    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      print('📦 Status code: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          return jsonData.map((e) => Clarificacion.fromJson(e)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          return [Clarificacion.fromJson(jsonData)];
        }
      }

      print('❗ Error al obtener clarificaciones');
      return [];
    } catch (e) {
      print('❌ Error de conexión al obtener clarificaciones: $e');
      return [];
    }
  }

  Future<Clarificacion?> crearClarificacion(int batchId, Clarificacion nuevaClarificacion) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/$batchId/clarification');
    print('📤 Enviando nueva clarificación a: $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(nuevaClarificacion.toJson()),
      );

      print('📦 Status code: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Clarificacion.fromJson(jsonDecode(response.body));
      } else {
        print('❗ Error al crear clarificación: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error de conexión al crear clarificación: $e');
      return null;
    }
  }
}
