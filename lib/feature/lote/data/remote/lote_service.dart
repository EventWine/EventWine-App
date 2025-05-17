import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eventwine/core/app_constants.dart';
import 'lote_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoteService {
  Future<List<Lote>> obtenerLotesPorProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    final profileId = prefs.getString('profileId');

    if (profileId == null) {
      print('Error: profileId no encontrado en SharedPreferences');
      return [];
    }

    final url = Uri.parse('${AppConstants.baseURL}/batch/profile/$profileId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Lote.fromJson(json)).toList();
      } else {
        print('Error al obtener lotes: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error de conexión al obtener lotes: $e');
      return [];
    }
  }

  Future<Lote?> crearLote(Lote nuevoLote) async {
    final prefs = await SharedPreferences.getInstance();
    final profileId = prefs.getString('profileId');

    if (profileId == null) {
      print('Error: profileId no encontrado en SharedPreferences para crear lote');
      return null;
    }

    final url = Uri.parse('${AppConstants.baseURL}/batch/profile/$profileId');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(nuevoLote.toJson()),
      );

      if (response.statusCode == 201) {
        print('Lote creado exitosamente');
        return Lote.fromJson(jsonDecode(response.body));
      } else {
        print('Error al crear lote: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de conexión al crear lote: $e');
      return null;
    }
  }
}