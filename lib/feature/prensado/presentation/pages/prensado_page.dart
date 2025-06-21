import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';
import 'package:eventwine/feature/clarificacion/presentation/pages/clarificacion_page.dart';
import 'package:eventwine/feature/anejo/presentation/pages/anejo_page.dart';
import 'package:eventwine/feature/lote/data/remote/lote_service.dart';
import 'package:eventwine/feature/lote/data/remote/lote_model.dart';
import 'package:eventwine/feature/prensado/data/remote/prensado_service.dart';
import 'package:eventwine/feature/prensado/data/remote/prensado_model.dart';

class PrensadoPage extends StatefulWidget {
  @override
  _PrensadoPageState createState() => _PrensadoPageState();
}

class _PrensadoPageState extends State<PrensadoPage> {
  final LoteService loteService = LoteService();
  final PrensadoService prensadoService = PrensadoService();

  List<Lote> lotes = [];
  List<Prensado> prensados = [];
  List<Prensado> prensadosFiltrados = [];
  int? _selectedBatchId;
  bool _loading = true;
  final searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final fechaController = TextEditingController();
  final volumenController = TextEditingController();
  final presionController = TextEditingController();
  String? tipoSeleccionado;

  final List<String> tiposPrensa = ['Neumática', 'Hidráulica', 'Manual'];

  @override
  void initState() {
    super.initState();
    _loadLotes();
  }

  Future<void> _loadLotes() async {
    setState(() => _loading = true);
    lotes = await loteService.obtenerLotesPorProfileId();
    if (lotes.isNotEmpty) {
      _selectedBatchId = lotes.first.id;
      await _loadPrensado();
    }
    setState(() => _loading = false);
  }

  Future<void> _loadPrensado() async {
    if (_selectedBatchId == null) return;
    setState(() => _loading = true);
    prensados = await prensadoService.obtenerPrensadoPorBatchId(_selectedBatchId!);
    prensadosFiltrados = prensados;
    setState(() => _loading = false);
  }

  Future<void> _pickDate(TextEditingController c) async {
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (dt != null) c.text = DateFormat('yyyy-MM-dd').format(dt);
  }

  void _filtrar(String query) {
    final resultados = prensados.where((p) => p.id.toString().contains(query)).toList();
    setState(() => prensadosFiltrados = resultados);
  }

  Future<void> _showForm() async {
    _formKey.currentState?.reset();
    fechaController.clear();
    volumenController.clear();
    presionController.clear();
    tipoSeleccionado = null;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo Prensado'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: fechaController,
                decoration: const InputDecoration(
                    labelText: 'Día de Prensado', suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () => _pickDate(fechaController),
                validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: volumenController,
                decoration: const InputDecoration(labelText: 'Volumen de Mosto'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                items: tiposPrensa
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => tipoSeleccionado = v),
                decoration: const InputDecoration(labelText: 'Tipo de Prensa'),
                validator: (v) => v == null ? 'Selecciona un tipo' : null,
              ),
              TextFormField(
                controller: presionController,
                decoration: const InputDecoration(labelText: 'Presión Aplicada'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
            ]),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && _selectedBatchId != null) {
                final nuevo = Prensado(
                  id: 0, // ID will be assigned by the backend
                  loteId: _selectedBatchId!,
                  diaPrensado: fechaController.text,
                  volumenMosto: double.parse(volumenController.text),
                  tipoPrensa: tipoSeleccionado!,
                  presionAplicada: double.parse(presionController.text),
                );
                final creado =
                    await prensadoService.crearPrensado(_selectedBatchId!, nuevo);
                if (creado != null) {
                  Navigator.pop(context);
                  await _loadPrensado(); // Reload all pressings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Prensado creado exitosamente')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al crear prensado')),
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
    final bool puedeCrearPrensado = prensados.isEmpty; 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF743636),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomePage())),
        ),
        title: SizedBox(
          height: 80,
          child: Image.asset('assets/logo_eventwine.jpg', fit: BoxFit.fitHeight),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
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
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ClarificacionPage()),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Prensado', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => AnejoPage()),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _selectedBatchId,
            isExpanded: true,
            decoration: const InputDecoration(
                labelText: 'Selecciona un lote', border: OutlineInputBorder()),
            items: lotes
                .map((l) => DropdownMenuItem(
                      value: l.id,
                      child: Text('Lote ${l.id} - ${l.origenVinedo}'),
                    ))
                .toList(),
            onChanged: (v) {
              setState(() => _selectedBatchId = v);
              _loadPrensado();
            },
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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : prensadosFiltrados.isEmpty
                    ? const Center(child: Text('No se ha creado prensado para este lote'))
                    : ListView.builder(
                        itemCount: prensadosFiltrados.length,
                        itemBuilder: (context, index) {
                          final p = prensadosFiltrados[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              leading: const Icon(Icons.local_drink,
                                  color: Colors.deepPurple),
                              title: Text('Prensado #${p.id}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tipo: ${p.tipoPrensa}'),
                                  Text('Fecha: ${p.diaPrensado}'),
                                ],
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Detalles >>',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Detalles del Prensado'),
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('ID: ${p.id}'),
                                          Text('Lote ID: ${p.loteId}'),
                                          Text('Fecha: ${p.diaPrensado}'),
                                          Text('Volumen: ${p.volumenMosto}'),
                                          Text('Tipo de Prensa: ${p.tipoPrensa}'),
                                          Text('Presión Aplicada: ${p.presionAplicada}'),
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
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: puedeCrearPrensado
          ? FloatingActionButton.extended(
              backgroundColor: Colors.amber,
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Prensado'),
              onPressed: () => _showForm(),
            )
          : null,
    );
  }
}