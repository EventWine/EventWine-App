import 'package:flutter/material.dart';
import 'package:eventwine/feature/anejo/data/remote/anejo_service.dart';
import 'package:eventwine/feature/anejo/data/remote/anejo_model.dart';

class AnejoPage extends StatefulWidget {
  @override
  _AnejoPageState createState() => _AnejoPageState();
}

class _AnejoPageState extends State<AnejoPage> {
  final AnejoService anejoService = AnejoService();
  List<Anejo> anejos = [];
  List<Anejo> anejosFiltrados = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    anejos = anejoService.obtenerAnejos();
    anejosFiltrados = anejos;
  }

  void filtrarAnejos(String query) {
    final resultados = anejos.where((anejo) {
      return anejo.id.toString().contains(query);
    }).toList();

    setState(() {
      anejosFiltrados = resultados;
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

            // Sección "Anejos" con flechas
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
                    'Añejamientos',
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
                hintText: 'Buscar por número de añejamiento',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: filtrarAnejos,
            ),

            const SizedBox(height: 16),

            // Lista de anejos
            Expanded(
              child: ListView.builder(
                itemCount: anejosFiltrados.length,
                itemBuilder: (context, index) {
                  final anejo = anejosFiltrados[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.wine_bar, color: Colors.deepPurple),
                      title: Text('Añejamiento #${anejo.id}'),
                      subtitle: Text('Inicio: ${anejo.diaInicio} | Final: ${anejo.diaFinal}'),
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
                              title: const Text('Detalles del Añejamiento'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${anejo.id}'),
                                  Text('Lote ID: ${anejo.loteId}'),
                                  Text('Tipo de Barrica: ${anejo.tipoBarrica}'),
                                  Text('Día de Inicio: ${anejo.diaInicio}'),
                                  Text('Día Final: ${anejo.diaFinal}'),
                                  Text('Duración (Meses): ${anejo.duracionMeses}'),
                                  Text('Inspecciones Realizadas: ${anejo.inspeccionesRealizadas}'),
                                  Text('Resultado de Inspección: ${anejo.resultadoInspeccion}'),
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
          // Acción para nuevo añejamiento
        },
        label: const Text('Nuevo añejamiento'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
