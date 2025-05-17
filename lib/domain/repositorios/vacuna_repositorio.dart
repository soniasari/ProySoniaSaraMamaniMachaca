

import 'package:seguimiento_mascota/domain/entidades/vacuna.dart';

abstract class VacunaRepositorio {
  Future<List<Vacuna>> obtenerVacunasPorMascota(int idMascota);
  Future<void> agregarVacuna(Vacuna vacuna);
  Future<void> eliminarVacuna(int idVacuna);
  Future<void> actualizarVacuna(Vacuna vacuna);
}