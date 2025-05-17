import 'package:seguimiento_mascota/domain/entidades/vacuna.dart';

class VacunaModelo extends Vacuna {
  VacunaModelo({
    super.idVacuna,
    required super.idMascota,
    required super.nombreVacuna,
    required super.fechaVacuna,
    super.proximaVacuna, // <- Quitamos 'required' para que sea opcional
  });

  // Convertir el modelo en un mapa para insertarlo en la base de datos
  Map<String, dynamic> toMap() => {
        'id_vacuna': idVacuna,
        'id_mascota': idMascota,
        'nombre_vacuna': nombreVacuna,
        'fecha_vacuna': fechaVacuna.toIso8601String(),
        'proxima_vacuna': proximaVacuna?.toIso8601String(),
      };

  // Convertir el mapa de la base de datos en un modelo de Vacuna
  factory VacunaModelo.fromMap(Map<String, dynamic> map) => VacunaModelo(
        idVacuna: map['id_vacuna'],
        idMascota: map['id_mascota'],
        nombreVacuna: map['nombre_vacuna'],
        fechaVacuna: DateTime.parse(map['fecha_vacuna']),
        proximaVacuna: map['proxima_vacuna'] != null
            ? DateTime.parse(map['proxima_vacuna'])
            : null,
      );
}