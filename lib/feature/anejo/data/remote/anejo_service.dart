import 'package:eventwine/feature/anejo/data/remote/anejo_model.dart';

class AnejoService {
  List<Anejo> obtenerAnejos() {
    return [
      Anejo(
        id: 1,
        loteId: 101,
        tipoBarrica: 'Roble Francés',
        diaInicio: '2023-01-01',
        diaFinal: '2024-01-01',
        duracionMeses: 12,
        inspeccionesRealizadas: 'Sí',
        resultadoInspeccion: 'Óptimo',
      ),
      Anejo(
        id: 2,
        loteId: 102,
        tipoBarrica: 'Roble Americano',
        diaInicio: '2023-02-01',
        diaFinal: '2024-02-01',
        duracionMeses: 12,
        inspeccionesRealizadas: 'Sí',
        resultadoInspeccion: 'Bueno',
      ),
      // Puedes agregar más ejemplos aquí
    ];
  }
}
