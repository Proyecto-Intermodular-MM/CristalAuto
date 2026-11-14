import 'package:flutter/material.dart';

import 'colores.dart';
import 'pantallas/inicio.dart';
import 'repositorio.dart';

void main() => runApp(CristalAutoApp(repositorio: Repositorio()));

class CristalAutoApp extends StatelessWidget {
  const CristalAutoApp({super.key, required this.repositorio});

  final Repositorio repositorio;

  @override
  Widget build(BuildContext context) {
    final esquema = ColorScheme.fromSeed(
      seedColor: CristalColores.azulNoche,
      primary: CristalColores.azulNoche,
      secondary: CristalColores.amarilloBrillo,
      tertiary: CristalColores.azulAgua,
      surface: CristalColores.crema,
    );
    return MaterialApp(
      title: 'CristalAuto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: esquema,
        scaffoldBackgroundColor: CristalColores.crema,
        appBarTheme: const AppBarTheme(
          backgroundColor: CristalColores.azulNoche,
          foregroundColor: CristalColores.crema,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: CristalColores.amarilloBrillo,
            foregroundColor: CristalColores.azulNoche,
          ),
        ),
      ),
      home: Inicio(repositorio: repositorio),
    );
  }
}
