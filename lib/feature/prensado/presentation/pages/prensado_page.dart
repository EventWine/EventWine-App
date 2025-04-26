import 'package:flutter/material.dart';
import 'package:eventwine/feature/prensado/data/remote/prensado_service.dart';
import 'package:eventwine/feature/prensado/data/remote/prensado_model.dart';

class PrensadoPage extends StatefulWidget {
  @override
  _PrensadoPageState createState() => _PrensadoPageState();
}

class _PrensadoPageState extends State<PrensadoPage> {
  final PrensadoService prensadoService = PrensadoService();
  List<Prensado> prensados = [];
  List<Prensado> prensadosFiltrados = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    prensados = prensadoService.obtenerPrensados();
    prensadosFiltrados = prensados;
  }

  void filtrarPrensados(String query) {
    final resultados = prensados.where((prensado) {
      return prensado.id.toString().contains(query);
    }).toList();

    setState(() {
      prensadosFiltrados = resultados;
    });
  }

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
        child: Column(
          children: [
            // Título principal
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vinificación',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDAA520),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFDAA520),
                    decorationThickness: 2,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),

            // Sección "Prensados" con flechas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      // Acción para página anterior
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Prensados',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      // Acción para página siguiente
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Barra de búsqueda
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por número de prensado',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: filtrarPrensados,
            ),

            const SizedBox(height: 16),

            // Lista de prensados
            Expanded(
              child: ListView.builder(
                itemCount: prensadosFiltrados.length,
                itemBuilder: (context, index) {
                  final prensado = prensadosFiltrados[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.local_drink_outlined, color: Colors.blueAccent),
                      title: Text('Prensado #${prensado.id}'),
                      subtitle: Text('Día: ${prensado.diaPrensado}'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Detalles >>',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Detalles del Prensado'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${prensado.id}'),
                                  Text('Lote ID: ${prensado.loteId}'),
                                  Text('Día de Prensado: ${prensado.diaPrensado}'),
                                  Text('Volumen de Mosto: ${prensado.volumenMosto}'),
                                  Text('Tipo de Prensa: ${prensado.tipoPrensa}'),
                                  Text('Presión Aplicada: ${prensado.presionAplicada}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cerrar'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber,
        onPressed: () {
          // Acción para nuevo prensado
        },
        label: const Text('Nuevo prensado'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
