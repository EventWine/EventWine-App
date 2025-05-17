class Lote {
  final int id;
  final String codigoVinedo;
  final String variedadUva;
  final String fechaVendimia;
  final int cantidadUva; // Cambiamos a int
  final String origenVinedo;
  final String fechaInicio;
  final String status;
  final String profileId;

  Lote({
    required this.id,
    required this.codigoVinedo,
    required this.variedadUva,
    required this.fechaVendimia,
    required this.cantidadUva,
    required this.origenVinedo,
    required this.fechaInicio,
    required this.status,
    required this.profileId,
  });

  factory Lote.fromJson(Map<String, dynamic> json) {
    return Lote(
      id: json['id'],
      profileId: json['profileId'],
      codigoVinedo: json['vineyardCode'],
      variedadUva: json['grapeVariety'],
      fechaVendimia: json['harvestDate'],
      cantidadUva: json['grapeQuantity'] as int,
      origenVinedo: json['vineyardOrigin'],
      fechaInicio: json['processStartDate'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vineyardCode': codigoVinedo,
      'grapeVariety': variedadUva,
      'harvestDate': fechaVendimia,
      'grapeQuantity': cantidadUva.toString(),
      'vineyardOrigin': origenVinedo,
      'processStartDate': fechaInicio,
      'resource': 'batch',
    };
  }
}