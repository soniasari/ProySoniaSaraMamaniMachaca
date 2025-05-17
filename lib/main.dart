import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seguimiento_mascota/presentacion/paginas/historial_mascota_pagina';
import 'package:seguimiento_mascota/presentacion/paginas/historial_vacunas_pagina.dart';
import 'package:seguimiento_mascota/presentacion/paginas/inicio_pagina.dart';
import 'package:seguimiento_mascota/presentacion/paginas/registro_mascota_pagina.dart';

void main() {
  runApp(ProviderScope (child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seguimiento de Vacunas para Mascotas',
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => InicioPagina(), // Página principal
        '/registro': (context) => RegistroMascotaPagina(), // Página de registro
        '/historial': (context) => HistorialMascotasPagina(),
        '/historial-vacunas': (context) => HistorialVacunasPagina(),
      },
    );
  }
}