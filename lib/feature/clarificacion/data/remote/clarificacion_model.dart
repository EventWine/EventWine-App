class Clarificacion {
  final int id;
  final int loteId;
  final String productosUsados;
  final String metodoClarificacion;
  final String fechaFiltracion;
  final String diaInicio;
  final String diaFinal;
  final int nivelClaridad;

  Clarificacion({
    required this.id,
    required this.loteId,
    required this.productosUsados,
    required this.metodoClarificacion,
    required this.fechaFiltracion,
    required this.diaInicio,
    required this.diaFinal,
    required this.nivelClaridad,
  });

  factory Clarificacion.fromJson(Map<String, dynamic> json) {
    return Clarificacion(
      id: json['id'],
      loteId: json['batchId'],
      productosUsados: json['productsUsed'],
      metodoClarificacion: json['clarificationMethod'],
      fechaFiltracion: json['filtrationDate'],
      diaInicio: json['startDate'],
      diaFinal: json['endDate'],
      nivelClaridad: json['clarityLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productsUsed': productosUsados,
      'clarificationMethod': metodoClarificacion,
      'filtrationDate': fechaFiltracion,
      'startDate': diaInicio,
      'endDate': diaFinal,
      'clarityLevel': nivelClaridad,
    };
  }
}
