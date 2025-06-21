class Anejo {
  final int id;
  final int loteId;
  final String tipoBarrica;
  final String diaInicio;
  final String diaFinal;
  final int duracionMeses;
  final int inspeccionesRealizadas;
  final String resultadoInspeccion;

  Anejo({
    required this.id,
    required this.loteId,
    required this.tipoBarrica,
    required this.diaInicio,
    required this.diaFinal,
    required this.duracionMeses,
    required this.inspeccionesRealizadas,
    required this.resultadoInspeccion,
  });

  factory Anejo.fromJson(Map<String, dynamic> json) {
    return Anejo(
      id: json['id'],
      loteId: json['batchId'],
      tipoBarrica: json['barrelType'],
      diaInicio: json['startDate'],
      diaFinal: json['endDate'],
      duracionMeses: json['agingDurationMonths'],
      inspeccionesRealizadas: json['inspectionsPerformed'],
      resultadoInspeccion: json['inspectionResult'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barrelType': tipoBarrica,
      'startDate': diaInicio,
      'endDate': diaFinal,
      'agingDurationMonths': duracionMeses,
      'inspectionsPerformed': inspeccionesRealizadas,
      'inspectionResult': resultadoInspeccion,
    };
  }
}