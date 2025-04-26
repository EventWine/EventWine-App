import 'package:eventwine/feature/embotellado/data/remote/embotellado_model.dart';

class EmbotelladoService {
  List<Embotellado> obtenerEmbotellados() {
    return [
      Embotellado(
        id: 1,
        loteId: 201,
        diaEmbotellado: '2024-04-01',
        tamanoBotella: 750,
        numeroBotellas: 1200,
        tipoEtiqueta: 'Clásica',
        tipoCorcho: 'Natural',
      ),
      Embotellado(
        id: 2,
        loteId: 202,
        diaEmbotellado: '2024-05-01',
        tamanoBotella: 500,
        numeroBotellas: 800,
        tipoEtiqueta: 'Moderna',
        tipoCorcho: 'Sintético',
      ),
    ];
  }
}
