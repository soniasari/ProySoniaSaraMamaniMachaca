import '../../domain/entidades/vacuna.dart';
import '../../domain/repositorios/vacuna_repositorio.dart';
import '../db/base_datos.dart';
import '../modelos/vacuna_modelo.dart';

class VacunaRepositorioImpl implements VacunaRepositorio {
  @override
  Future<void> agregarVacuna(Vacuna vacuna) async {
    final db = await BaseDatos.obtenerDB();

    // Convertir la Vacuna (entidad) a VacunaModelo (para la base de datos)
    await db.insert('vacunas', VacunaModelo(
      idVacuna: vacuna.idVacuna,
      idMascota: vacuna.idMascota,
      nombreVacuna: vacuna.nombreVacuna,
      fechaVacuna: vacuna.fechaVacuna,
      proximaVacuna: vacuna.proximaVacuna,
    ).toMap());
  }

  @override
  Future<void> eliminarVacuna(int idVacuna) async {
    final db = await BaseDatos.obtenerDB();
    await db.delete('vacunas', where: 'id_vacuna = ?', whereArgs: [idVacuna]);
  }

  @override
  Future<List<VacunaModelo>> obtenerVacunasPorMascota(int idMascota) async {
    final db = await BaseDatos.obtenerDB();
    final res = await db.query('vacunas', where: 'id_mascota = ?', whereArgs: [idMascota]);

    // Convertir los resultados de la base de datos (VacunaModelo) a la entidad (Vacuna)
    return res.map((e) => VacunaModelo.fromMap(e)).toList();


  }

  //@override
@override
  Future<void> actualizarVacuna(Vacuna vacuna) async {
    final db = await BaseDatos.obtenerDB();

    // Convertir la entidad Vacuna a VacunaModelo para la base de datos
    await db.update(
      'vacunas',
      VacunaModelo(
        idVacuna: vacuna.idVacuna,
        idMascota: vacuna.idMascota,
        nombreVacuna: vacuna.nombreVacuna,
        fechaVacuna: vacuna.fechaVacuna,
        proximaVacuna: vacuna.proximaVacuna,
      ).toMap(),
      where: 'id_vacuna = ?',
      whereArgs: [vacuna.idVacuna], // Condición de actualización
    );
  }
}