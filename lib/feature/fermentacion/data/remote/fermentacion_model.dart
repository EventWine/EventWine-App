class Fermentacion {
  final int id;
  final int loteId;
  final String fechaInicio;
  final String fechaFinal;
  final double temperaturaMedia;
  final double densidadInicial;
  final double phInicial;
  final double densidadFinal;
  final double phFinal;
  final double azucarResidual;

  Fermentacion({
    required this.id,
    required this.loteId,
    required this.fechaInicio,
    required this.fechaFinal,
    required this.temperaturaMedia,
    required this.densidadInicial,
    required this.phInicial,
    required this.densidadFinal,
    required this.phFinal,
    required this.azucarResidual,
  });
}
