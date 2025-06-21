class Embotellado {
  final int id;
  final int loteId;
  final String diaEmbotellado;
  final String tamanoBotella;
  final int numeroBotellas;
  final String tipoEtiqueta;
  final String tipoCorcho;

  Embotellado({
    required this.id,
    required this.loteId,
    required this.diaEmbotellado,
    required this.tamanoBotella,
    required this.numeroBotellas,
    required this.tipoEtiqueta,
    required this.tipoCorcho,
  });

  factory Embotellado.fromJson(Map<String, dynamic> json) {
    return Embotellado(
      id: json['id'],
      loteId: json['batchId'],
      diaEmbotellado: json['bottlingDate'],
      tamanoBotella: json['bottleSizeMl'],
      numeroBotellas: json['numberOfBottles'],
      tipoEtiqueta: json['labelType'],
      tipoCorcho: json['corkType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bottlingDate': diaEmbotellado,
      'bottleSizeMl': tamanoBotella,
      'numberOfBottles': numeroBotellas,
      'labelType': tipoEtiqueta,
      'corkType': tipoCorcho,
    };
  }
}