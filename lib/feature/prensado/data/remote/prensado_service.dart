import 'package:eventwine/feature/prensado/data/remote/prensado_model.dart';

class PrensadoService {
  List<Prensado> obtenerPrensados() {
    return [
      Prensado(
        id: 1,
        loteId: 101,
        diaPrensado: '2025-04-25',
        volumenMosto: '500 litros',
        tipoPrensa: 'Prensa Neumática',
        presionAplicada: '2.5 bares',
      ),
      Prensado(
        id: 2,
        loteId: 102,
        diaPrensado: '2025-04-26',
        volumenMosto: '450 litros',
        tipoPrensa: 'Prensa Hidráulica',
        presionAplicada: '3.0 bares',
      ),
    ];
  }
}
