class Mascota {
  final int id;
  final String nombre;
  final String especie;
  final String raza;
  final DateTime fechaNacimiento;
  final String foto;

  Mascota({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.fechaNacimiento,
    required this.foto,
  });

  Mascota copyWith({
    int? id,
    String? nombre,
    String? especie,
    String? raza,
    DateTime? fechaNacimiento,
    String? foto,
  }) {
    return Mascota(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      especie: especie ?? this.especie,
      raza: raza ?? this.raza,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      foto: foto ?? this.foto,
    );
  }
}