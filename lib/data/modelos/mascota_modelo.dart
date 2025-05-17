import '../../domain/entidades/mascota.dart';

class MascotaModelo {
  final int idMascota;
  final String nombre;
  final String especie;
  final String raza;
  final String fechaNacimiento;
  final String foto;

  MascotaModelo({
    required this.idMascota,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.fechaNacimiento,
    required this.foto,
  });

  // Convertir de un objeto Mascota a MascotaModelo
  factory MascotaModelo.fromMascota(Mascota mascota) {
    return MascotaModelo(
      idMascota: mascota.id, // Asegúrate de tener un campo ID en la clase Mascota
      nombre: mascota.nombre,
      especie: mascota.especie,
      raza: mascota.raza,
      fechaNacimiento: mascota.fechaNacimiento.toIso8601String(),
      foto: mascota.foto,
    );
  }

  // Convertir de un Map (de la base de datos) a MascotaModelo
  factory MascotaModelo.fromMap(Map<String, dynamic> map) {
    return MascotaModelo(
      idMascota: map['id_mascota'],
      nombre: map['nombre'],
      especie: map['especie'],
      raza: map['raza'],
      fechaNacimiento: map['fecha_nacimiento'],
      foto: map['foto'],
    );
  }

  // Convertir de MascotaModelo a un objeto Mascota
  Mascota toMascota() {
    return Mascota(
      id: idMascota,
      nombre: nombre,
      especie: especie,
      raza: raza,
      fechaNacimiento: DateTime.parse(fechaNacimiento),
      foto: foto,
    );
  }

  // Convertir de MascotaModelo a un Map (para insertar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id_mascota': idMascota,
      'nombre': nombre,
      'especie': especie,
      'raza': raza,
      'fecha_nacimiento': fechaNacimiento,
      'foto': foto,
    };
  }
}