import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seguimiento_mascota/aplicacion/proveedores/mascota_proveedor.dart';
//import 'package:seguimiento_mascota/domain/entidades/vacuna.dart';
import 'package:seguimiento_mascota/aplicacion/proveedores/vacuna_proveedor.dart';
import 'package:seguimiento_mascota/presentacion/paginas/editar_vacuna_pagina.dart';

class HistorialVacunasPagina extends ConsumerWidget {
  const HistorialVacunasPagina({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtienes las mascotas
    final mascotas = ref.watch(mascotasProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Vacunas'),centerTitle: true, foregroundColor: Colors.black, ),
      body: mascotas.isEmpty
          ? const Center(child: Text("No tienes mascotas registradas"))
          : ListView.builder(
              itemCount: mascotas.length,
              itemBuilder: (context, index) {
                final mascota = mascotas[index];
                final vacunas = ref.watch(vacunasProvider(mascota.id));

                return ExpansionTile(
                  title: Text(mascota.nombre),
                  leading: Image.file(
                    File(mascota.foto),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  children: vacunas.isEmpty
                      ? [const ListTile(title: Text("No hay vacunas registradas"))]
                      : vacunas.map((vacuna) {
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(vacuna.nombreVacuna),
                              subtitle: Text(
                                'Fecha: ${vacuna.fechaVacuna.toLocal().toString().split(' ')[0]}\n'
                                'Próxima: ${vacuna.proximaVacuna?.toLocal().toString().split(' ')[0] ?? "No registrada"}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                        Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditarVacunaPagina(
                                            idVacuna: vacuna.idVacuna!,
                                            idMascota: mascota.id,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      // Lógica para eliminar la vacuna
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Eliminar vacuna"),
                                          content: const Text("¿Estás seguro de que deseas eliminar esta vacuna?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text("Cancelar"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Lógica para eliminar la vacuna
                                                ref.read(vacunasProvider(mascota.id).notifier)
                                                    .eliminarVacuna(vacuna.idVacuna!);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Eliminar"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                );
              },
            ),
    );
  }
}