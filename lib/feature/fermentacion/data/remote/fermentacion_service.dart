import 'dart:convert';
import 'package:eventwine/core/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:eventwine/feature/fermentacion/data/remote/fermentacion_model.dart';

class FermentacionService {
  Future<List<Fermentacion>> obtenerFermentacionesPorBatchId(int batchId) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/batch/$batchId/fermentation');

    try {
      print('➡️ Solicitando fermentaciones desde: $url');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('📦 Status code: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded.map((json) => Fermentacion.fromJson(json)).toList();
        } else if (decoded is Map<String, dynamic>) {
          // Cuando solo se devuelve un objeto fermentación
          return [Fermentacion.fromJson(decoded)];
        } else {
          print('❗ Formato de respuesta inesperado: $decoded');
          return [];
        }
      } else {
        print('❌ Error al obtener fermentaciones: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('🚨 Error de conexión al obtener fermentaciones: $e');
      return [];
    }
  }

  Future<Fermentacion?> crearFermentacion(int batchId, Fermentacion nuevaFermentacion) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/$batchId/fermentation');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(nuevaFermentacion.toJson()),
      );

      if (response.statusCode == 201) {
        print('✅ Fermentación creada exitosamente');
        return Fermentacion.fromJson(jsonDecode(response.body));
      } else {
        print('❌ Error al crear fermentación: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('🚨 Error de conexión al crear fermentación: $e');
      return null;
    }
  }
}
