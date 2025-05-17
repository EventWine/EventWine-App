import 'package:flutter/material.dart';
import 'package:eventwine/feature/lote/data/remote/lote_service.dart';
import 'package:eventwine/feature/lote/data/remote/lote_model.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';
import 'package:eventwine/feature/fermentacion/presentation/pages/fermentacion_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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

  final _formKey = GlobalKey<FormState>();
  final codigoVinedoController = TextEditingController();
  String? _variedadUvaSeleccionada;
  final fechaVendimiaController = TextEditingController();
  final cantidadUvaController = TextEditingController();
  String? _origenVinedoSeleccionado;
  final fechaInicioController = TextEditingController();

  final List<String> _variedadesUva = ['Quebranta', 'Negra Criolla', 'Italia', 'Torontel', 'Mollar', 'Albilla'];
  final List<String> _origenesVinedo = ['Pisco', 'Ica', 'Chincha', 'Nazca', 'Palpa'];

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

  Future<void> _seleccionarFecha(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _mostrarFormularioNuevoLote() async {
    _formKey.currentState?.reset();
    codigoVinedoController.clear();
    _variedadUvaSeleccionada = null;
    fechaVendimiaController.clear();
    cantidadUvaController.clear();
    _origenVinedoSeleccionado = null;
    fechaInicioController.clear();

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
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Variedad de Uva'),
                    value: _variedadUvaSeleccionada,
                    items: _variedadesUva.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _variedadUvaSeleccionada = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Campo obligatorio' : null,
                  ),
                  TextFormField(
                    controller: fechaVendimiaController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Vendimia (YYYY-MM-DD)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _seleccionarFecha(context, fechaVendimiaController),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Campo obligatorio';
                      final intCantidad = int.tryParse(value);
                      if (intCantidad == null || intCantidad <= 0) return 'Debe ser un entero positivo';
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Origen del Viñedo'),
                    value: _origenVinedoSeleccionado,
                    items: _origenesVinedo.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _origenVinedoSeleccionado = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Campo obligatorio' : null,
                  ),
                  TextFormField(
                    controller: fechaInicioController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Inicio (YYYY-MM-DD)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _seleccionarFecha(context, fechaInicioController),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Campo obligatorio';
                      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) return 'Formato incorrecto (YYYY-MM-DD)';
                      if (fechaVendimiaController.text.isNotEmpty && value.isNotEmpty) {
                        final fechaVendimia = DateTime.parse(fechaVendimiaController.text);
                        final fechaInicio = DateTime.parse(value);
                        if (!fechaInicio.isAfter(fechaVendimia)) {
                          return 'Debe ser posterior a la fecha de vendimia';
                        }
                      }
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
                      id: 0,
                      profileId: profileId,
                      codigoVinedo: codigoVinedoController.text,
                      variedadUva: _variedadUvaSeleccionada!,
                      fechaVendimia: fechaVendimiaController.text,
                      cantidadUva: int.parse(cantidadUvaController.text),
                      origenVinedo: _origenVinedoSeleccionado!,
                      fechaInicio: fechaInicioController.text,
                      status: 'Collected',
                    );

                    final loteCreado = await loteService.crearLote(nuevoLote);
                    if (loteCreado != null) {
                      _cargarLotes();
                      Navigator.of(context).pop();
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
                    onPressed: () {},
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
                            title: Text('Origen: ${lote.origenVinedo}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Inicio: ${lote.fechaInicio}'),
                                Text('ID: ${lote.id}'),
                              ],
                            ),
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