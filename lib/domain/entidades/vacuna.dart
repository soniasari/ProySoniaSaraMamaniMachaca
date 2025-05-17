class Vacuna {
  final int? idVacuna;
  final int idMascota;
  final String nombreVacuna;
  final DateTime fechaVacuna;
  final DateTime? proximaVacuna;

  Vacuna({
    this.idVacuna,
    required this.idMascota,
    required this.nombreVacuna,
    required this.fechaVacuna,
    this.proximaVacuna,
  });
}