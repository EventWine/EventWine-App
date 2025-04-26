import 'package:flutter/material.dart';
import 'package:eventwine/feature/embotellado/data/remote/embotellado_service.dart';
import 'package:eventwine/feature/embotellado/data/remote/embotellado_model.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';
import 'package:eventwine/feature/anejo/presentation/pages/anejo_page.dart';

class EmbotelladoPage extends StatefulWidget {
  @override
  _EmbotelladoPageState createState() => _EmbotelladoPageState();
}

class _EmbotelladoPageState extends State<EmbotelladoPage> {
  final EmbotelladoService embotelladoService = EmbotelladoService();
  List<Embotellado> embotellados = [];
  List<Embotellado> embotelladosFiltrados = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    embotellados = embotelladoService.obtenerEmbotellados();
    embotelladosFiltrados = embotellados;
  }

  void filtrarEmbotellados(String query) {
    final resultados = embotellados.where((embotellado) {
      return embotellado.id.toString().contains(query);
    }).toList();

    setState(() {
      embotelladosFiltrados = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF743636),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
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

            // Sección "Embotellado" con flechas
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AnejoPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Embotellado',
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
                hintText: 'Buscar por número de embotellado',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: filtrarEmbotellados,
            ),

            const SizedBox(height: 16),

            // Lista de embotellados
            Expanded(
              child: ListView.builder(
                itemCount: embotelladosFiltrados.length,
                itemBuilder: (context, index) {
                  final embotellado = embotelladosFiltrados[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.local_drink, color: Colors.teal),
                      title: Text('Embotellado #${embotellado.id}'),
                      subtitle: Text('Día: ${embotellado.diaEmbotellado} | Botellas: ${embotellado.numeroBotellas}'),
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
                              title: const Text('Detalles del Embotellado'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${embotellado.id}'),
                                  Text('Lote ID: ${embotellado.loteId}'),
                                  Text('Día de Embotellado: ${embotellado.diaEmbotellado}'),
                                  Text('Tamaño de Botella (ml): ${embotellado.tamanoBotella}'),
                                  Text('Número de Botellas: ${embotellado.numeroBotellas}'),
                                  Text('Tipo de Etiqueta: ${embotellado.tipoEtiqueta}'),
                                  Text('Tipo de Corcho: ${embotellado.tipoCorcho}'),
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
          // Acción para nuevo embotellado
        },
        label: const Text('Nuevo embotellado'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
