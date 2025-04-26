import 'package:flutter/material.dart';
import 'package:eventwine/feature/lote/data/remote/lote_service.dart';
import 'package:eventwine/feature/lote/data/remote/lote_model.dart';

class LotePage extends StatefulWidget {
  @override
  _LotePageState createState() => _LotePageState();
}

class _LotePageState extends State<LotePage> {
  final LoteService loteService = LoteService();
  List<Lote> lotes = [];
  List<Lote> lotesFiltrados = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    lotes = loteService.obtenerLotes();
    lotesFiltrados = lotes;
  }

  void filtrarLotes(String query) {
    final resultados = lotes.where((lote) {
      return lote.origenVinedo.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      lotesFiltrados = resultados;
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

            // Sección "Lotes" con flechas
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
                    'Lotes',
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
                hintText: 'Buscar por nombre de viñedo',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: filtrarLotes,
            ),

            const SizedBox(height: 16),

            // Lista de lotes
            Expanded(
              child: ListView.builder(
                itemCount: lotesFiltrados.length,
                itemBuilder: (context, index) {
                  final lote = lotesFiltrados[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.wine_bar, color: Colors.deepPurple),
                      title: Text(lote.origenVinedo),
                      subtitle: Text('Inicio: ${lote.fechaInicio}'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Detalles >>',
                          style: TextStyle(color: Colors.white), // Texto blanco
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Detalles del Lote'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${lote.id}'),
                                  Text('Código Viñedo: ${lote.codigoVinedo}'),
                                  Text('Variedad de Uva: ${lote.variedadUva}'),
                                  Text('Fecha de Vendimia: ${lote.fechaVendimia}'),
                                  Text('Cantidad de Uva: ${lote.cantidadUva} kg'),
                                  Text('Origen del Viñedo: ${lote.origenVinedo}'),
                                  Text('Fecha de Inicio: ${lote.fechaInicio}'),
                                  Text('Status: ${lote.status}'),
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
          // Acción para nuevo pedido
        },
        label: const Text('Nuevo lote'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
