import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eventwine/feature/anejo/data/remote/anejo_model.dart';
import 'package:eventwine/core/app_constants.dart';

class AnejoService {
  Future<List<Anejo>> obtenerAnejosPorBatchId(int batchId) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/batch/$batchId/aging');
    try {
      final resp = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (resp.statusCode == 200) {
        final dynamic body = jsonDecode(resp.body);

        if (body is List) {
          return body.map((json) => Anejo.fromJson(json)).toList();
        } else if (body is Map<String, dynamic>) {
          return [Anejo.fromJson(body)];
        }
      }
      return [];
    } catch (e) {
      print('Error al obtener añejos por Batch ID: $e');
      return [];
    }
  }

  Future<Anejo?> crearAnejo(int batchId, Anejo anejo) async {
    final url = Uri.parse('${AppConstants.baseURL}/winemakingProcess/$batchId/aging');
    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(anejo.toJson()),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return Anejo.fromJson(jsonDecode(resp.body));
      } else {
        print('Error al crear añejamiento: ${resp.statusCode} - ${resp.body}');
        return null;
      }
    } catch (e) {
      print('Error en la solicitud de creación de añejamiento: $e');
      return null;
    }
  }
}