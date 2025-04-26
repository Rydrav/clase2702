class Car {
  final String id;
  final String placa;
  final String conductor;
  final String empresa;
  final String? imagenUrl;
  bool isAssigned;

  Car({
    required this.id,
    required this.placa,
    required this.conductor,
    required this.empresa,
    this.imagenUrl,
    this.isAssigned = false,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] ?? '',
      placa: json['placa'] ?? '',
      conductor: json['conductor'] ?? '',
      empresa: json['empresa'] ?? 'XYZ',
      imagenUrl: json['imagenUrl'],
      isAssigned: json['isAssigned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placa': placa,
      'conductor': conductor,
      'empresa': empresa,
      'imagenUrl': imagenUrl,
      'isAssigned': isAssigned,
    };
  }
}
