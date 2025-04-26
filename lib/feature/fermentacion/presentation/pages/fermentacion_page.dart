import 'package:flutter/material.dart';
import 'package:eventwine/feature/fermentacion/data/remote/fermentacion_service.dart';
import 'package:eventwine/feature/fermentacion/data/remote/fermentacion_model.dart';

class FermentacionPage extends StatefulWidget {
  @override
  _FermentacionPageState createState() => _FermentacionPageState();
}

class _FermentacionPageState extends State<FermentacionPage> {
  final FermentacionService fermentacionService = FermentacionService();
  List<Fermentacion> fermentaciones = [];
  List<Fermentacion> fermentacionesFiltradas = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fermentaciones = fermentacionService.obtenerFermentaciones();
    fermentacionesFiltradas = fermentaciones;
  }

  void filtrarFermentaciones(String query) {
    final resultados = fermentaciones.where((fermentacion) {
      return fermentacion.id.toString().contains(query);
    }).toList();

    setState(() {
      fermentacionesFiltradas = resultados;
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
                  'Fermentación',
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

            // Sección "Fermentaciones" con flechas
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
                    'Fermentaciones',
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
                hintText: 'Buscar por número de fermentación',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: filtrarFermentaciones,
            ),

            const SizedBox(height: 16),

            // Lista de fermentaciones
            Expanded(
              child: ListView.builder(
                itemCount: fermentacionesFiltradas.length,
                itemBuilder: (context, index) {
                  final fermentacion = fermentacionesFiltradas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.local_drink, color: Colors.blue),
                      title: Text('Fermentación #${fermentacion.id}'),
                      subtitle: Text('Inicio: ${fermentacion.fechaInicio}  |  Final: ${fermentacion.fechaFinal}'),
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
                              title: const Text('Detalles de la Fermentación'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${fermentacion.id}'),
                                  Text('Lote ID: ${fermentacion.loteId}'),
                                  Text('Fecha de Inicio: ${fermentacion.fechaInicio}'),
                                  Text('Fecha Final: ${fermentacion.fechaFinal}'),
                                  Text('Temperatura Media: ${fermentacion.temperaturaMedia} °C'),
                                  Text('Densidad Inicial: ${fermentacion.densidadInicial}'),
                                  Text('pH Inicial: ${fermentacion.phInicial}'),
                                  Text('Densidad Final: ${fermentacion.densidadFinal}'),
                                  Text('pH Final: ${fermentacion.phFinal}'),
                                  Text('Azúcar Residual: ${fermentacion.azucarResidual} g/L'),
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
          // Acción para nueva fermentación
        },
        label: const Text('Nueva fermentación'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
