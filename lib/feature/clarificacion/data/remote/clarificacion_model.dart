class Clarificacion {
  final int id;
  final int loteId;
  final String productosUsados;
  final String metodoClarificacion;
  final String fechaFiltracion;
  final String nivelClaridad;
  final String diaInicio;
  final String diaFinal;

  Clarificacion({
    required this.id,
    required this.loteId,
    required this.productosUsados,
    required this.metodoClarificacion,
    required this.fechaFiltracion,
    required this.nivelClaridad,
    required this.diaInicio,
    required this.diaFinal,
  });
}