
import 'package:flutter/material.dart';

void main() {
  runApp(const ControlHabitosApp());
}

// Modelo que representa cada hábito.
class Habito {
  final String nombre;
  final String descripcion;
  final IconData icono;
  final int meta;
  int contador;

  Habito({
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.meta,
    this.contador = 0,
  });
}

// Widget sin estado: muestra información que no cambia.
class EncabezadoHabitos extends StatelessWidget {
  const EncabezadoHabitos({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tu mejor versión empieza hoy',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF173B67),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pequeños pasos, grandes resultados.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.blueGrey.shade600,
          ),
        ),
      ],
    );
  }
}

class ControlHabitosApp extends StatelessWidget {
  const ControlHabitosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de hábitos',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF246BCE),
        ),
      ),
      home: const PantallaHabitos(),
    );
  }
}

// Widget con estado: controla los contadores de los hábitos.
class PantallaHabitos extends StatefulWidget {
  const PantallaHabitos({super.key});

  @override
  State<PantallaHabitos> createState() => _PantallaHabitosState();
}

class _PantallaHabitosState extends State<PantallaHabitos> {
  final List<Habito> habitos = [
    Habito(
      nombre: 'Tomar agua',
      descripcion: 'Hidrata tu cuerpo durante el día.',
      icono: Icons.water_drop,
      meta: 8,
    ),
    Habito(
      nombre: 'Estudiar',
      descripcion: 'Dedica tiempo a tu aprendizaje.',
      icono: Icons.menu_book,
      meta: 2,
    ),
    Habito(
      nombre: 'Hacer ejercicio',
      descripcion: 'Mantente activo y saludable.',
      icono: Icons.fitness_center,
      meta: 1,
    ),
  ];

  int get habitosCompletados =>
      habitos.where((habito) => habito.contador >= habito.meta).length;

  double get progreso =>
      habitos.isEmpty ? 0 : habitosCompletados / habitos.length;

  void registrarHabito(Habito habito) {
    setState(() {
      habito.contador++;
    });
  }

  void reiniciarDia() {
    setState(() {
      for (final habito in habitos) {
        habito.contador = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B67),
        foregroundColor: Colors.white,
        title: const Text(
          'Control de hábitos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const EncabezadoHabitos(),
            const SizedBox(height: 24),

            // Resumen del progreso diario.
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progreso diario',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$habitosCompletados de ${habitos.length}',
                          style: const TextStyle(
                            color: Color(0xFF246BCE),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    LinearProgressIndicator(
                      value: progreso,
                      minHeight: 9,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: const Color(0xFFE0E8F3),
                      color: const Color(0xFF246BCE),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progreso * 100).round()}% de hábitos completados',
                      style: TextStyle(color: Colors.blueGrey.shade600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Mis hábitos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173B67),
              ),
            ),

            const SizedBox(height: 10),

            // Cada elemento de la lista se convierte en una tarjeta.
            ...habitos.map(
              (habito) => TarjetaHabito(
                habito: habito,
                onRegistrar: () => registrarHabito(habito),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: reiniciarDia,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reiniciar día'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                foregroundColor: const Color(0xFF173B67),
                side: const BorderSide(color: Color(0xFF173B67)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                'La constancia construye resultados.',
                style: TextStyle(
                  color: Colors.blueGrey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Componente reutilizable para representar cada hábito.
class TarjetaHabito extends StatelessWidget {
  final Habito habito;
  final VoidCallback onRegistrar;

  const TarjetaHabito({
    super.key,
    required this.habito,
    required this.onRegistrar,
  });

  @override
  Widget build(BuildContext context) {
    final bool completado = habito.contador >= habito.meta;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: completado
                    ? const Color(0xFFDDF5E5)
                    : const Color(0xFFE7F0FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                habito.icono,
                color: completado
                    ? Colors.green.shade700
                    : const Color(0xFF246BCE),
                size: 28,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habito.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habito.descripcion,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${habito.contador} / ${habito.meta} realizadas',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF246BCE),
                    ),
                  ),
                  if (completado)
                    const Text(
                      '¡Meta cumplida!',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            IconButton.filled(
              onPressed: onRegistrar,
              tooltip: 'Registrar hábito',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
