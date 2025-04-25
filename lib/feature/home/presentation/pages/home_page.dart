import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final String nombreUsuario = "Carlos Mendoza";

  @override
  Widget build(BuildContext context) {
    String fechaActual = DateFormat.yMMMMEEEEd('es_PE').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('EventWine'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Text(
              '👋 Bienvenido, $nombreUsuario',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 4),
            Text(
              '📅 $fechaActual',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),

            // Dashboard
            Text(
              'Resumen general',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),

            // Tarjetas
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.purple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '🍇 Lotes activos',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '5',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.purple),
                          ),
                          SizedBox(height: 4),
                          Text('Último: Lote #124'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '📦 Inventario actual',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '820 botellas',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.green),
                          ),
                          SizedBox(height: 4),
                          Text('Reposo: 320 | Listas: 500'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
