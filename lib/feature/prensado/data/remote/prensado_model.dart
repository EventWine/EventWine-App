class Prensado {
  final int id;
  final int loteId;
  final String diaPrensado;
  final double volumenMosto;
  final String tipoPrensa;
  final double presionAplicada;

  Prensado({
    required this.id,
    required this.loteId,
    required this.diaPrensado,
    required this.volumenMosto,
    required this.tipoPrensa,
    required this.presionAplicada,
  });

  factory Prensado.fromJson(Map<String, dynamic> json) {
    return Prensado(
      id: json['id'],
      loteId: json['batchId'],
      diaPrensado: json['pressingDate'],
      volumenMosto: (json['mustVolume'] as num).toDouble(),
      tipoPrensa: json['pressType'],
      presionAplicada: (json['appliedPressure'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pressingDate': diaPrensado,
      'mustVolume': volumenMosto,
      'pressType': tipoPrensa,
      'appliedPressure': presionAplicada,
    };
  }
}