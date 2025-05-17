import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entidades/vacuna.dart';
import '../../aplicacion/proveedores/vacuna_proveedor.dart';

class RegistroVacunaPagina extends ConsumerWidget {
  final int idMascota;

  RegistroVacunaPagina({super.key, required this.idMascota});

  // Controladores de texto
  final _nombreController = TextEditingController();
  final _fechaVacunaController = TextEditingController();
  final _proximaVacunaController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Vacuna'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Nombre de la vacuna
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: "Nombre de la Vacuna",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12.0)
              ),
            ),
            const SizedBox(height: 12),

            // Fecha de la vacuna
            TextField(
              controller: _fechaVacunaController,
              decoration: const InputDecoration(labelText: "Fecha Aplicación de Vacuna (YYYY-MM-DD)",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12.0)
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 12),

            // Próxima vacuna (opcional)
            TextField(
              controller: _proximaVacunaController,
              decoration: const InputDecoration(labelText: "Próxima Vacuna (opcional) (YYYY-MM-DD)",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12.0)
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 24),

            // Botón para registrar
            ElevatedButton(
              onPressed: () {
                if (_nombreController.text.isEmpty || _fechaVacunaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Por favor, llena todos los campos obligatorios")),
                  );
                  return;
                }

                try {
                  final fechaVacuna = DateTime.parse(_fechaVacunaController.text);

                  DateTime? proximaVacuna;
                  if (_proximaVacunaController.text.isNotEmpty) {
                    proximaVacuna = DateTime.parse(_proximaVacunaController.text);

                    // ✅ Validar que la próxima vacuna sea posterior a la fecha de vacunación
                    if (!proximaVacuna.isAfter(fechaVacuna)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("La fecha de la próxima vacuna debe ser posterior a la fecha de la vacuna."),
                        ),
                      );
                      return;
                    }
                  }

                  final nuevaVacuna = Vacuna(
                    idVacuna: null,
                    idMascota: idMascota,
                    nombreVacuna: _nombreController.text,
                    fechaVacuna: fechaVacuna,
                    proximaVacuna: proximaVacuna,
                  );

                  ref.read(vacunasProvider(idMascota).notifier).agregarVacuna(nuevaVacuna);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vacuna registrada correctamente")),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: formato de fecha inválido. ${e.toString()}")),
                  );
                }
              },
              child: const Text('Registrar Vacuna'),
            ),
          ],
        ),
      ),
    );
  }
}