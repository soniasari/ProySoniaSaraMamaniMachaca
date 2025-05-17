import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entidades/vacuna.dart';
import '../../aplicacion/proveedores/vacuna_proveedor.dart';

class EditarVacunaPagina extends ConsumerWidget {
  final int idVacuna;
  final int idMascota;

  EditarVacunaPagina({super.key, required this.idVacuna, required this.idMascota});

  final _nombreController = TextEditingController();
  final _fechaVacunaController = TextEditingController();
  final _proximaVacunaController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vacuna = ref.watch(vacunasProvider(idMascota));

    final vacunaData = vacuna.firstWhere(
      (v) => v.idVacuna == idVacuna,
      orElse: () => Vacuna(
        idVacuna: -1,
        idMascota: idMascota,
        nombreVacuna: '',
        fechaVacuna: DateTime.now(),
        proximaVacuna: null,
      ),
    );

    if (vacunaData.idVacuna == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar Vacuna'), centerTitle: true, foregroundColor: Colors.black,),
        body: const Center(child: Text('Vacuna no encontrada')),
      );
    }

    _nombreController.text = vacunaData.nombreVacuna;
    _fechaVacunaController.text = vacunaData.fechaVacuna.toLocal().toString().split(' ')[0];
    _proximaVacunaController.text = vacunaData.proximaVacuna?.toLocal().toString().split(' ')[0] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Vacuna', ), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre de la Vacuna",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fechaVacunaController,
              decoration: const InputDecoration(
                labelText: "Fecha de la Vacuna (YYYY-MM-DD)",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _proximaVacunaController,
              decoration: const InputDecoration(
                labelText: "Próxima Vacuna (opcional)",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_nombreController.text.isEmpty || _fechaVacunaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Por favor, llena todos los campos obligatorios")),
                  );
                  return;
                }

                try {
                  final fechaVacuna = DateTime.parse(_fechaVacunaController.text.trim());

                  DateTime? proximaVacuna;
                  if (_proximaVacunaController.text.trim().isNotEmpty) {
                    proximaVacuna = DateTime.parse(_proximaVacunaController.text.trim());

                    // Validar que la próxima vacuna sea posterior a hoy
                    if (!proximaVacuna.isAfter(DateTime.now())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("La próxima vacuna debe ser una fecha futura.")),
                      );
                      return;
                    }

                    // Validar que la próxima vacuna sea posterior a la fecha de vacunación
                    if (!proximaVacuna.isAfter(fechaVacuna)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("La próxima vacuna debe ser posterior a la fecha de la vacuna.")),
                      );
                      return;
                    }
                  }

                  final vacunaEditada = Vacuna(
                    idVacuna: idVacuna,
                    idMascota: idMascota,
                    nombreVacuna: _nombreController.text.trim(),
                    fechaVacuna: fechaVacuna,
                    proximaVacuna: proximaVacuna,
                  );

                  ref.read(vacunasProvider(idMascota).notifier).editarVacuna(vacunaEditada);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vacuna actualizada correctamente")),
                  );

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: formato de fecha inválido. ${e.toString()}")),
                  );
                }
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}