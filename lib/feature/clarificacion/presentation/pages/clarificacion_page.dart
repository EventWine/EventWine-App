import 'package:eventwine/feature/fermentacion/presentation/pages/fermentacion_page.dart';
import 'package:eventwine/feature/prensado/presentation/pages/prensado_page.dart';
import 'package:flutter/material.dart';
import 'package:eventwine/feature/clarificacion/data/remote/clarificacion_service.dart';
import 'package:eventwine/feature/clarificacion/data/remote/clarificacion_model.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';

class ClarificacionPage extends StatefulWidget {
  @override
  _ClarificacionPageState createState() => _ClarificacionPageState();
}

class _ClarificacionPageState extends State<ClarificacionPage> {
  final ClarificacionService clarificacionService = ClarificacionService();
  List<Clarificacion> clarificaciones = [];
  List<Clarificacion> clarificacionesFiltradas = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    clarificaciones = clarificacionService.obtenerClarificaciones();
    clarificacionesFiltradas = clarificaciones;
  }

  void filtrarClarificaciones(String query) {
    final resultados = clarificaciones.where((clarificacion) {
      return clarificacion.id.toString().contains(query);
    }).toList();

    setState(() {
      clarificacionesFiltradas = resultados;
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

            // Sección "Clarificaciones" con flechas
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
                        MaterialPageRoute(builder: (context) => FermentacionPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Clarificaciones',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => PrensadoPage()),
                      );
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
                hintText: 'Buscar por número de clarificación',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: filtrarClarificaciones,
            ),

            const SizedBox(height: 16),

            // Lista de clarificaciones
            Expanded(
              child: ListView.builder(
                itemCount: clarificacionesFiltradas.length,
                itemBuilder: (context, index) {
                  final clarificacion = clarificacionesFiltradas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.water_drop_outlined, color: Colors.blueAccent),
                      title: Text('Clarificación #${clarificacion.id}'),
                      subtitle: Text('Inicio: ${clarificacion.diaInicio} | Final: ${clarificacion.diaFinal}'),
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
                              title: const Text('Detalles de la Clarificación'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${clarificacion.id}'),
                                  Text('Lote ID: ${clarificacion.loteId}'),
                                  Text('Productos Usados: ${clarificacion.productosUsados}'),
                                  Text('Método de Clarificación: ${clarificacion.metodoClarificacion}'),
                                  Text('Fecha de Filtración: ${clarificacion.fechaFiltracion}'),
                                  Text('Nivel de Claridad: ${clarificacion.nivelClaridad}'),
                                  Text('Día de Inicio: ${clarificacion.diaInicio}'),
                                  Text('Día Final: ${clarificacion.diaFinal}'),
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
          // Acción para nueva clarificación
        },
        label: const Text('Nueva clarificación'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
