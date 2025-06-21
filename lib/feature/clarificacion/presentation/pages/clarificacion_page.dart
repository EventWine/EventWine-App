import 'package:eventwine/feature/fermentacion/presentation/pages/fermentacion_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';
import 'package:eventwine/feature/prensado/presentation/pages/prensado_page.dart';
import 'package:eventwine/feature/clarificacion/data/remote/clarificacion_service.dart';
import 'package:eventwine/feature/clarificacion/data/remote/clarificacion_model.dart';
import 'package:eventwine/feature/lote/data/remote/lote_service.dart';
import 'package:eventwine/feature/lote/data/remote/lote_model.dart';

class ClarificacionPage extends StatefulWidget {
  @override
  _ClarificacionPageState createState() => _ClarificacionPageState();
}

class _ClarificacionPageState extends State<ClarificacionPage> {
  final ClarificacionService clarificacionService = ClarificacionService();
  final LoteService loteService = LoteService();

  List<Clarificacion> clarificaciones = [];
  List<Clarificacion> clarificacionesFiltradas = [];
  List<Lote> lotes = [];
  int? _selectedBatchId;
  bool _isLoading = true;
  final searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final diaInicioController = TextEditingController();
  final diaFinalController = TextEditingController();
  final fechaFiltracionController = TextEditingController();
  String? metodoSeleccionado;
  String? productoSeleccionado;
  double nivelClaridad = 1;

  final List<String> metodos = ['Filtración', 'Centrifugación', 'Decantación'];
  final List<String> productos = ['Bentonita', 'Gelatina', 'Carbón Activo'];

  @override
  void initState() {
    super.initState();
    _cargarLotes();
  }

  Future<void> _cargarLotes() async {
    setState(() => _isLoading = true);
    lotes = await loteService.obtenerLotesPorProfileId();
    if (lotes.isNotEmpty) {
      _selectedBatchId = lotes.first.id;
      await _cargarClarificaciones();
    }
    setState(() => _isLoading = false);
  }

  Future<void> _cargarClarificaciones() async {
    if (_selectedBatchId == null) return;
    setState(() => _isLoading = true);
    clarificaciones = await clarificacionService.obtenerClarificacionesPorBatchId(_selectedBatchId!);
    clarificacionesFiltradas = clarificaciones;
    setState(() => _isLoading = false);
  }

  void _filtrar(String query) {
    final resultados = clarificaciones.where((c) => c.id.toString().contains(query)).toList();
    setState(() => clarificacionesFiltradas = resultados);
  }

  Future<void> _seleccionarFecha(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _mostrarFormularioNuevaClarificacion() async {
    _formKey.currentState?.reset();
    diaInicioController.clear();
    diaFinalController.clear();
    fechaFiltracionController.clear();
    metodoSeleccionado = null;
    productoSeleccionado = null;
    nivelClaridad = 1;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Clarificación'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: diaInicioController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Día de Inicio', suffixIcon: Icon(Icons.calendar_today)),
                  onTap: () => _seleccionarFecha(diaInicioController),
                  validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: diaFinalController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Día Final', suffixIcon: Icon(Icons.calendar_today)),
                  onTap: () => _seleccionarFecha(diaFinalController),
                  validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                ),
                DropdownButtonFormField<String>(
                  value: metodoSeleccionado,
                  items: metodos.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (value) => setState(() => metodoSeleccionado = value),
                  decoration: const InputDecoration(labelText: 'Método de Clarificación'),
                  validator: (v) => v == null ? 'Selecciona un método' : null,
                ),
                DropdownButtonFormField<String>(
                  value: productoSeleccionado,
                  items: productos.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (value) => setState(() => productoSeleccionado = value),
                  decoration: const InputDecoration(labelText: 'Productos Usados'),
                  validator: (v) => v == null ? 'Selecciona un producto' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Nivel de Claridad:'),
                    Expanded(
                      child: Slider(
                        value: nivelClaridad,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: nivelClaridad.round().toString(),
                        onChanged: (value) {
                          setState(() => nivelClaridad = value);
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: fechaFiltracionController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Fecha de Filtración', suffixIcon: Icon(Icons.calendar_today)),
                  onTap: () => _seleccionarFecha(fechaFiltracionController),
                  validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && _selectedBatchId != null) {
                final nueva = Clarificacion(
                  id: 0,
                  loteId: _selectedBatchId!,
                  diaInicio: diaInicioController.text,
                  diaFinal: diaFinalController.text,
                  metodoClarificacion: metodoSeleccionado!,
                  productosUsados: productoSeleccionado!,
                  nivelClaridad: nivelClaridad.toInt(),
                  fechaFiltracion: fechaFiltracionController.text,
                );
                final creada = await clarificacionService.crearClarificacion(_selectedBatchId!, nueva);
                if (creada != null) {
                  Navigator.pop(context);
                  await _cargarClarificaciones();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Clarificación creada exitosamente')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al crear la clarificación')),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool puedeCrearClarificacion = clarificaciones.isEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF743636),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
          },
        ),
        title: SizedBox(
          height: 80,
          child: Image.asset('assets/logo_eventwine.jpg', fit: BoxFit.fitHeight),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
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
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FermentacionPage())),
                  ),
                  const SizedBox(width: 8),
                  const Text('Clarificación', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PrensadoPage())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedBatchId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Selecciona un lote', border: OutlineInputBorder()),
              items: lotes.map((l) => DropdownMenuItem<int>(
                value: l.id,
                child: Text('Lote ${l.id} - ${l.origenVinedo}'),
              )).toList(),
              onChanged: (id) => setState(() {
                _selectedBatchId = id;
                _cargarClarificaciones();
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por ID',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: _filtrar,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: clarificacionesFiltradas.length,
                      itemBuilder: (context, index) {
                        final c = clarificacionesFiltradas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.filter_alt, color: Colors.deepPurple),
                            title: Text('Clarificación #${c.id}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Método: ${c.metodoClarificacion}'),
                                Text('Filtración: ${c.fechaFiltracion}'),
                              ],
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Detalles >>', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Detalles Clarificación'),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('ID: ${c.id}'),
                                        Text('Lote ID: ${c.loteId}'),
                                        Text('Inicio: ${c.diaInicio}'),
                                        Text('Final: ${c.diaFinal}'),
                                        Text('Método: ${c.metodoClarificacion}'),
                                        Text('Productos Usados: ${c.productosUsados}'),
                                        Text('Nivel Claridad: ${c.nivelClaridad}'),
                                        Text('Fecha Filtración: ${c.fechaFiltracion}'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(child: const Text('Cerrar'), onPressed: () => Navigator.pop(context)),
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
      floatingActionButton: puedeCrearClarificacion
          ? FloatingActionButton.extended(
              backgroundColor: Colors.amber,
              icon: const Icon(Icons.add),
              label: const Text('Nueva Clarificación'),
              onPressed: _mostrarFormularioNuevaClarificacion,
            )
          : null,
    );
  }
}
