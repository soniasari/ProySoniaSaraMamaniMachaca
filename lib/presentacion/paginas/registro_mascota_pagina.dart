import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../domain/entidades/mascota.dart'; // Asegúrate de tener la clase Mascota
import '../../aplicacion/proveedores/mascota_proveedor.dart';


class RegistroMascotaPagina extends ConsumerWidget {
  const RegistroMascotaPagina({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picker = ImagePicker();

    final nombre = ref.watch(nombreProvider);
    final especie = ref.watch(especieProvider);
    final raza = ref.watch(razaProvider);
    final fecha = ref.watch(fechaNacimientoProvider);
    final fotoPath = ref.watch(fotoPathProvider);

    void registrarMascota() {
      if (fotoPath.isEmpty || !File(fotoPath).existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Debes seleccionar una foto para registrar la mascota.")),
        );
        return;
      }

      try {
        final nuevaMascota = Mascota(
          id: DateTime.now().millisecondsSinceEpoch,
          nombre: nombre,
          especie: especie,
          raza: raza,
          fechaNacimiento: DateTime.parse(fecha),
          foto: fotoPath,
        );

        ref.read(mascotasProvider.notifier).agregarMascota(nuevaMascota);

        // Limpiar campos
        ref.invalidate(nombreProvider);
        ref.invalidate(especieProvider);
        ref.invalidate(razaProvider);
        ref.invalidate(fechaNacimientoProvider);
        ref.invalidate(fotoPathProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mascota registrada correctamente")),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Mascota"), 
      centerTitle: true,
      //backgroundColor: Colors.teal, // Cambia el color del fondo del AppBar
      foregroundColor: Colors.black, ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: nombre,
              decoration: const InputDecoration(labelText: "Nombre", 
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12.0),
              ),
              onChanged: (value) => ref.read(nombreProvider.notifier).state = value,
            ),
            SizedBox(height: 7,),
            TextFormField(
              initialValue: especie,
              decoration: const InputDecoration(labelText: "Especie (Gato o Perro)",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)
              ),
              onChanged: (value) => ref.read(especieProvider.notifier).state = value,
            ),
            SizedBox(height: 7,),
            TextFormField(
              initialValue: raza,
              decoration: const InputDecoration(labelText: "Raza",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)
              ),
              onChanged: (value) => ref.read(razaProvider.notifier).state = value,
            ),
            SizedBox(height: 7,),
            TextFormField(
              initialValue: fecha,
              decoration: const InputDecoration(labelText: "Fecha de Nacimiento (AAAA-MM-DD)",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)),
              keyboardType: TextInputType.datetime,
              onChanged: (value) => ref.read(fechaNacimientoProvider.notifier).state = value,
            ),
            const SizedBox(height: 16),
            fotoPath.isEmpty
                ? const Text("No hay foto seleccionada")
                : Image.file(File(fotoPath), height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      ref.read(fotoPathProvider.notifier).state = photo.path;
                    }
                  },
                  child: const Text("Tomar Foto"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                    if (photo != null) {
                      ref.read(fotoPathProvider.notifier).state = photo.path;
                    }
                  },
                  child: const Text("Seleccionar de Galería"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registrarMascota,
              child: const Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}