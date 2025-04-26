import 'package:flutter/material.dart';
import 'package:eventwine/feature/lote/presentation/pages/lote_page.dart';

class HomePage extends StatelessWidget {
  final String nombreUsuario = "Carlos Mendoza";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF743636),
        elevation: 0,
        centerTitle: true,
        title: SizedBox(
          height: 80,
          child: Image.asset(
            'assets/logo_eventwine.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Text(
                '👋 Bienvenido, $nombreUsuario',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // Dashboard
              Text(
                'Resumen general',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

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
                            const SizedBox(height: 8),
                            Text(
                              '5',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: Colors.purple),
                            ),
                            const SizedBox(height: 4),
                            const Text('Último: Lote #124'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                            const SizedBox(height: 8),
                            Text(
                              '820 botellas',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: Colors.green),
                            ),
                            const SizedBox(height: 4),
                            const Text('Reposo: 320 | Listas: 500'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Últimos registros
              Text(
                '🕒 Últimos registros',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: Icon(Icons.history, color: Colors.deepPurple),
                  title: Text('Lote #125 creado'),
                  subtitle: Text('27 de abril - 10:30 AM'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.inventory, color: Colors.green),
                  title: Text('200 botellas añadidas'),
                  subtitle: Text('26 de abril - 3:45 PM'),
                ),
              ),

              const SizedBox(height: 24),

              // Botón "Empezar a vinificar"
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LotePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: const Text('Empezar a vinificar'),
              ),

              const SizedBox(height: 16),

              // Frase motivadora
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '🍷 "El buen vino es poesía embotellada" – Robert Louis Stevenson',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
