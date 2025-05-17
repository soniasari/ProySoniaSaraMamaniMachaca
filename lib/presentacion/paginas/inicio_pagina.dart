import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seguimiento_mascota/domain/entidades/vacuna.dart';
import '../../aplicacion/proveedores/mascota_proveedor.dart';
import '../../aplicacion/proveedores/vacuna_proveedor.dart';
import 'registro_vacuna_pagina.dart';


class InicioPagina extends ConsumerWidget {
  const InicioPagina({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mascotas = ref.watch(mascotasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Próximas Vacunas"), centerTitle: true,
      foregroundColor: Colors.black, ),
drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(color: const Color.fromARGB(255, 67, 57, 83)),
        child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      ListTile(
        leading: const Icon(Icons.pets),
        title: const Text('Registrar Mascota'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/registro');
        },
      ),
      ListTile(
        leading: const Icon(Icons.vaccines),
        title: const Text('Registrar Vacuna'),
        onTap: () {
          Navigator.pop(context);
          if (mascotas.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Primero registra una mascota")),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Selecciona una mascota"),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: mascotas.length,
                      itemBuilder: (context, index) {
                        final mascota = mascotas[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(File(mascota.foto)),
                          ),
                          title: Text(mascota.nombre),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RegistroVacunaPagina(idMascota: mascota.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      ListTile(
        leading: const Icon(Icons.history),
        title: const Text('Perfil de mis Mascotas'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/historial');
        },
      ),
        ListTile(
        leading: const Icon(Icons.medical_services),
        title: const Text('Historial de Vacunas'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/historial-vacunas');
        },
      ),
    ],
  ),
),
      body: mascotas.isEmpty
          ? const Center(child: Text("Hola!!! 👋 \n\nNo tienes mascotas registradas \n\n Por favor registra a tus mascotas \n\n 🐱 🐶",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18,),
          ))
          : ListView.builder(
              itemCount: mascotas.length,
              itemBuilder: (context, index) {
                final mascota = mascotas[index];
                final vacunas = ref.watch(vacunasProvider(mascota.id));

                final vacunasConProxima = vacunas.where((v) => v.proximaVacuna != null).toList();

                final proxima = vacunasConProxima.isEmpty
                    ? null
                    : vacunasConProxima.reduce((Vacuna a, Vacuna b) =>
                      a.proximaVacuna!.isBefore(b.proximaVacuna!) ? a : b);

                return ListTile(
                  leading: Image.file(
                    File(mascota.foto),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(mascota.nombre),
                  subtitle: proxima == null
                      ? const Text("Sin vacunas registradas")
                      : Text("Próxima vacuna: ${proxima.proximaVacuna!.toLocal().toString().split(' ')[0]}"),
                );
              },
            ),
          floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
           Navigator.pushNamed(context, '/registro');
          },
          icon: const Icon(Icons.pets), // O Icons.add
            label: const Text('Registrar mascota'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}