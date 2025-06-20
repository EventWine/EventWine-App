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

  factory Fermentacion.fromJson(Map<String, dynamic> json) {
    return Fermentacion(
      id: json['id'],
      loteId: json['batchId'],
      fechaInicio: json['startDate'],
      fechaFinal: json['endDate'],
      temperaturaMedia: _toDouble(json['averageTemperature']),
      densidadInicial: _toDouble(json['initialDensity']),
      phInicial: _toDouble(json['initialPh']),
      densidadFinal: _toDouble(json['finalDensity']),
      phFinal: _toDouble(json['finalPh']),
      azucarResidual: _toDouble(json['residualSugar']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': fechaInicio,
      'endDate': fechaFinal,
      'averageTemperature': temperaturaMedia,
      'initialDensity': densidadInicial,
      'initialPh': phInicial,
      'finalDensity': densidadFinal,
      'finalPh': phFinal,
      'residualSugar': azucarResidual,
    };
  }

  // Helper para convertir int/double/String a double
  static double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
