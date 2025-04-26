import 'package:eventwine/feature/clarificacion/data/remote/clarificacion_model.dart';

class ClarificacionService {
  List<Clarificacion> obtenerClarificaciones() {
    return [
      Clarificacion(
        id: 1,
        loteId: 101,
        productosUsados: 'Bentonita, Gel de Sílice',
        metodoClarificacion: 'Filtración a baja presión',
        fechaFiltracion: '2024-04-25',
        nivelClaridad: 'Alta',
        diaInicio: '2024-04-20',
        diaFinal: '2024-04-25',
      ),
      Clarificacion(
        id: 2,
        loteId: 102,
        productosUsados: 'Carbón Activado',
        metodoClarificacion: 'Decantación natural',
        fechaFiltracion: '2024-04-28',
        nivelClaridad: 'Media',
        diaInicio: '2024-04-23',
        diaFinal: '2024-04-28',
      ),
      Clarificacion(
        id: 3,
        loteId: 103,
        productosUsados: 'Bentonita',
        metodoClarificacion: 'Filtración por membrana',
        fechaFiltracion: '2024-04-30',
        nivelClaridad: 'Muy alta',
        diaInicio: '2024-04-26',
        diaFinal: '2024-04-30',
      ),
    ];
  }
}