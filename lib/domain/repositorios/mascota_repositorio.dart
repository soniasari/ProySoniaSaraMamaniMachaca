import '../../domain/entidades/mascota.dart';

abstract class MascotaRepositorio {
  Future<List<Mascota>> obtenerMascotas();
  Future<void> agregarMascota(Mascota mascota);
  Future<void> eliminarMascota(int idMascota);
  Future<void> actualizarMascota(Mascota mascota);
}