import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entidades/mascota.dart';
import '../../domain/repositorios/mascota_repositorio.dart';
import '../../data/repositorios/mascota_repositorio_impl.dart';

// Proveedor para el repositorio
final mascotaRepositorioProvider = Provider<MascotaRepositorio>((ref) {
  return MascotaRepositorioImpl(); // Implementación concreta del repositorio
});

final nombreProvider = StateProvider<String>((ref) => '');
final especieProvider = StateProvider<String>((ref) => '');
final razaProvider = StateProvider<String>((ref) => '');
final fechaNacimientoProvider = StateProvider<String>((ref) => '');
final fotoPathProvider = StateProvider<String>((ref) => '');

// Notifier que maneja el estado de las mascotas
class MascotaNotifier extends StateNotifier<List<Mascota>> {
  final MascotaRepositorio repositorio;

  // Constructor que recibe el repositorio
  MascotaNotifier(this.repositorio) : super([]) {
    cargarMascotas();
  }

  // Cargar las mascotas desde el repositorio
  Future<void> cargarMascotas() async {
    final lista = await repositorio.obtenerMascotas();
    state = lista;
  }

  // Agregar una nueva mascota
  Future<void> agregarMascota(Mascota mascota) async {
    await repositorio.agregarMascota(mascota);
    cargarMascotas(); // Recargar la lista después de agregar la mascota
  }

  // Eliminar una mascota
  Future<void> eliminarMascota(int id) async {
    await repositorio.eliminarMascota(id);
    cargarMascotas(); // Recargar la lista después de eliminar la mascota
  }
 Future<void> editarMascota(Mascota mascota) async {
  await repositorio.actualizarMascota(mascota);
  await cargarMascotas();
} 
}

// Proveedor para el Notifier de las mascotas
final mascotasProvider = StateNotifierProvider<MascotaNotifier, List<Mascota>>((ref) {
  final repo = ref.watch(mascotaRepositorioProvider); // Obtenemos el repositorio
  return MascotaNotifier(repo); // Creamos el notifier con el repositorio
});