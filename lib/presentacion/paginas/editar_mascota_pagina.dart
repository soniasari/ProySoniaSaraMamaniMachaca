import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entidades/mascota.dart';
import '../../aplicacion/proveedores/mascota_proveedor.dart';

class EditarMascotaPagina extends ConsumerWidget {
  final Mascota mascota;

  const EditarMascotaPagina({super.key, required this.mascota});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombreController = TextEditingController(text: mascota.nombre);
    final especieController = TextEditingController(text: mascota.especie);
    final razaController = TextEditingController(text: mascota.raza);
    final fechaController = TextEditingController(text: mascota.fechaNacimiento.toIso8601String().split('T').first);
    String fotoPath = mascota.foto;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Mascota'), 
      centerTitle: true,
      foregroundColor: Colors.black, ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(controller: nombreController, decoration: const InputDecoration(labelText: 'Nombre',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12.0),
            ),
            ),
            SizedBox(height: 10,),
            TextField(controller: especieController, decoration: const InputDecoration(labelText: 'Especie (Gato o Perro)',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12.0)
              )
              ),
            SizedBox(height: 10,),
            TextField(controller: razaController, decoration: const InputDecoration(labelText: 'Raza',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12.0),)),
            SizedBox(height: 10,),
            TextField(
              controller: fechaController,
              decoration: const InputDecoration(labelText: 'Fecha de Nacimiento (AAAA-MM-DD)',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12.0),
            ),
            ),
            const SizedBox(height: 16),
            fotoPath.isEmpty
                ? const Text('Sin foto')
                : Image.file(File(fotoPath), height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      fotoPath = photo.path;
                    }
                  },
                  child: const Text("Tomar Foto"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (photo != null) {
                      fotoPath = photo.path;
                    }
                  },
                  child: const Text("Galería"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nueva = mascota.copyWith(
                  nombre: nombreController.text,
                  especie: especieController.text,
                  raza: razaController.text,
                  fechaNacimiento: DateTime.parse(fechaController.text),
                  foto: fotoPath,
                );

                // Usar un `mounted` check para evitar problemas con el BuildContext
                if (!context.mounted) return; // Verifica si el widget sigue montado

                // Editar la mascota a través del provider de Riverpod
                await ref.read(mascotasProvider.notifier).editarMascota(nueva);

                // Verificar si el widget sigue montado antes de navegar
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text("Guardar cambios"),
            ),
          ],
        ),
      ),
    );
  }
}