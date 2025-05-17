import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entidades/vacuna.dart';
import '../../domain/repositorios/vacuna_repositorio.dart';
import '../../data/repositorios/vacuna_repositorio_impl.dart';


final fechaVacunaProvider = StateProvider<DateTime?>((ref) => null);
final proximaVacunaProvider = StateProvider<DateTime?>((ref) => null);

/// Proveedor del repositorio de vacunas
final vacunaRepositorioProvider = Provider<VacunaRepositorio>((ref) {
  // Se crea la instancia del repositorio, el cual se encarga de las operaciones de base de datos
  return VacunaRepositorioImpl();
});

/// Proveedor de vacunas para una mascota específica
/// Usamos `StateNotifierProvider.family` para que el estado dependa de un `idMascota`.
final vacunasProvider = StateNotifierProvider.family<VacunasNotifier, List<Vacuna>, int>((ref, idMascota) {
  // Accedemos al repositorio a través del proveedor `vacunaRepositorioProvider`
  final repo = ref.watch(vacunaRepositorioProvider);
  // Se crea el notifier que manejará el estado de las vacunas para una mascota específica
  return VacunasNotifier(repo, idMascota)..cargarVacunas(); // Se carga el estado inicial de las vacunas
});

/// Notifier que maneja el estado de las vacunas para una mascota específica
class VacunasNotifier extends StateNotifier<List<Vacuna>> {
  final VacunaRepositorio repositorio;
  final int idMascota;

  VacunasNotifier(this.repositorio, this.idMascota) : super([]);

  // Método para cargar las vacunas para una mascota específica
  Future<void> cargarVacunas() async {
    // Se obtienen las vacunas desde el repositorio (la base de datos)
    final listaModelo = await repositorio.obtenerVacunasPorMascota(idMascota);

    // Convertir la lista de modelos `VacunaModelo` a una lista de entidades `Vacuna`
    state = listaModelo.map((modelo) => Vacuna(
      idVacuna: modelo.idVacuna,
      idMascota: modelo.idMascota,
      nombreVacuna: modelo.nombreVacuna,
      fechaVacuna: modelo.fechaVacuna,
      proximaVacuna: modelo.proximaVacuna,
    )).toList();
  }

  // Método para agregar una vacuna a la base de datos
  Future<void> agregarVacuna(Vacuna vacuna) async {
    await repositorio.agregarVacuna(vacuna); // Se agrega la vacuna a través del repositorio
    await cargarVacunas(); // Recargamos las vacunas después de agregar una
  }

  // Método para eliminar una vacuna
  Future<void> eliminarVacuna(int idVacuna) async {
    await repositorio.eliminarVacuna(idVacuna); // Se elimina la vacuna desde el repositorio
    await cargarVacunas(); // Recargamos las vacunas después de eliminar una
  }
  
  //Metodo para editar vacuna
  Future<void> editarVacuna(Vacuna vacuna) async {
  await repositorio.actualizarVacuna(vacuna);
  await cargarVacunas(); // Recargamos las vacunas después de editar
}
}
