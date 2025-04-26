import 'fermentacion_model.dart';

class FermentacionService {
  List<Fermentacion> obtenerFermentaciones() {
    return [
      Fermentacion(
        id: 1,
        loteId: 101,
        fechaInicio: '2024-04-01',
        fechaFinal: '2024-04-15',
        temperaturaMedia: 22.5,
        densidadInicial: 1.090,
        phInicial: 3.4,
        densidadFinal: 0.995,
        phFinal: 3.2,
        azucarResidual: 5.0,
      ),
      Fermentacion(
        id: 2,
        loteId: 102,
        fechaInicio: '2024-04-03',
        fechaFinal: '2024-04-18',
        temperaturaMedia: 21.0,
        densidadInicial: 1.085,
        phInicial: 3.5,
        densidadFinal: 0.998,
        phFinal: 3.3,
        azucarResidual: 4.5,
      ),
      // Puedes agregar más fermentaciones si quieres
    ];
  }
}
