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
      duracionMeses: json['agingDurationMonths'], // Matches API key
      inspeccionesRealizadas: json['inspectionsPerformed'], // Expects int
      resultadoInspeccion: json['inspectionResult'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barrelType': tipoBarrica,
      'startDate': diaInicio,
      'endDate': diaFinal,
      'agingDurationMonths': duracionMeses, // Matches API key
      'inspectionsPerformed': inspeccionesRealizadas, // Sends int
      'inspectionResult': resultadoInspeccion,
    };
  }
}