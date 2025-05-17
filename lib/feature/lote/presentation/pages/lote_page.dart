import 'package:flutter/material.dart';
import 'package:eventwine/feature/lote/data/remote/lote_service.dart';
import 'package:eventwine/feature/lote/data/remote/lote_model.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';
import 'package:eventwine/feature/fermentacion/presentation/pages/fermentacion_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LotePage extends StatefulWidget {
  @override
  _LotePageState createState() => _LotePageState();
}

class _LotePageState extends State<LotePage> {
  final LoteService loteService = LoteService();
  List<Lote> lotes = [];
  List<Lote> lotesFiltrados = [];
  TextEditingController searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarLotes();
  }

  Future<void> _cargarLotes() async {
    setState(() {
      _isLoading = true;
    });
    lotes = await loteService.obtenerLotesPorProfileId();
    setState(() {
      lotesFiltrados = lotes;
      _isLoading = false;
    });
  }

  void filtrarLotes(String query) {
    final resultados = lotes.where((lote) {
      return lote.origenVinedo.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      lotesFiltrados = resultados;
    });
  }

  Future<void> _mostrarFormularioNuevoLote() async {
    final _formKey = GlobalKey<FormState>();
    final codigoVinedoController = TextEditingController();
    final variedadUvaController = TextEditingController();
    final fechaVendimiaController = TextEditingController();
    final cantidadUvaController = TextEditingController();
    final origenVinedoController = TextEditingController();
    final fechaInicioController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nuevo Lote'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: codigoVinedoController,
                    decoration: const InputDecoration(labelText: 'Código de Viñedo'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                  ),
                  TextFormField(
                    controller: variedadUvaController,
                    decoration: const InputDecoration(labelText: 'Variedad de Uva'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                  ),
                  TextFormField(
                    controller: fechaVendimiaController,
                    decoration: const InputDecoration(labelText: 'Fecha de Vendimia (YYYY-MM-DD)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Campo obligatorio';
                      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) return 'Formato incorrecto (YYYY-MM-DD)';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: cantidadUvaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad de Uva (kg)'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                  ),
                  TextFormField(
                    controller: origenVinedoController,
                    decoration: const InputDecoration(labelText: 'Origen del Viñedo'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                  ),
                  TextFormField(
                    controller: fechaInicioController,
                    decoration: const InputDecoration(labelText: 'Fecha de Inicio (YYYY-MM-DD)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Campo obligatorio';
                      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) return 'Formato incorrecto (YYYY-MM-DD)';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final prefs = await SharedPreferences.getInstance();
                  final profileId = prefs.getString('profileId');
                  if (profileId != null) {
                    final nuevoLote = Lote(
                      id: 0, // La API genera el ID
                      profileId: profileId,
                      codigoVinedo: codigoVinedoController.text,
                      variedadUva: variedadUvaController.text,
                      fechaVendimia: fechaVendimiaController.text,
                      cantidadUva: int.tryParse(cantidadUvaController.text) ?? 0,
                      origenVinedo: origenVinedoController.text,
                      fechaInicio: fechaInicioController.text,
                      status: 'Collected', // Establecemos el status por defecto
                    );

                    final loteCreado = await loteService.crearLote(nuevoLote);
                    if (loteCreado != null) {
                      // Recargar la lista de lotes después de crear uno nuevo
                      _cargarLotes();
                      Navigator.of(context).pop(); // Cerrar el diálogo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lote creado exitosamente')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al crear el lote')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: profileId no encontrado')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
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
                      // Acción para ir a la página anterior (si es necesario)
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FermentacionPage()),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
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
        onPressed: _mostrarFormularioNuevoLote,
        label: const Text('Nuevo lote'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}