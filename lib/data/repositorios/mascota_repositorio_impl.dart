import '../../domain/entidades/mascota.dart';
import '../../domain/repositorios/mascota_repositorio.dart';
import '../db/base_datos.dart';
import '../modelos/mascota_modelo.dart';

class MascotaRepositorioImpl implements MascotaRepositorio {
  @override
  Future<void> agregarMascota(Mascota mascota) async {
    final db = await BaseDatos.obtenerDB();

    // Convertir la mascota a un modelo que se pueda insertar en la base de datos.
    final mascotaModelo = MascotaModelo.fromMascota(mascota);
    
    // Insertar en la base de datos
    await db.insert('mascotas', mascotaModelo.toMap());
  }

  @override
  Future<void> eliminarMascota(int idMascota) async {
    final db = await BaseDatos.obtenerDB();

    // Eliminar la mascota de la base de datos usando su id
    await db.delete('mascotas', where: 'id_mascota = ?', whereArgs: [idMascota]);
  }

  @override
  Future<List<Mascota>> obtenerMascotas() async {
    final db = await BaseDatos.obtenerDB();

    // Consultar todas las mascotas de la base de datos
    final res = await db.query('mascotas');
    
    // Mapear los resultados a una lista de objetos Mascota
    return res.map((e) => MascotaModelo.fromMap(e).toMascota()).toList();
  }
  @override
Future<void> actualizarMascota(Mascota mascota) async {
  final db = await BaseDatos.obtenerDB();

  final mascotaModelo = MascotaModelo.fromMascota(mascota);

  await db.update(
    'mascotas',
    mascotaModelo.toMap(),
    where: 'id_mascota = ?',
    whereArgs: [mascota.id],
  );
}
}