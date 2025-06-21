import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventwine/feature/embotellado/data/remote/embotellado_service.dart';
import 'package:eventwine/feature/embotellado/data/remote/embotellado_model.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';
import 'package:eventwine/feature/anejo/presentation/pages/anejo_page.dart';
import 'package:eventwine/feature/lote/data/remote/lote_service.dart';
import 'package:eventwine/feature/lote/data/remote/lote_model.dart';

class EmbotelladoPage extends StatefulWidget {
  @override
  _EmbotelladoPageState createState() => _EmbotelladoPageState();
}

class _EmbotelladoPageState extends State<EmbotelladoPage> {
  final EmbotelladoService _embotelladoService = EmbotelladoService();
  final LoteService _loteService = LoteService();

  List<Lote> _lotes = [];
  List<Embotellado> _embotellados = [];
  List<Embotellado> _embotelladosFiltrados = [];
  int? _selectedBatchId;
  bool _loading = true;

  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _diaEmbotelladoController = TextEditingController();
  final TextEditingController _tamanoBotellaController = TextEditingController();
  final TextEditingController _numeroBotellasController = TextEditingController();

  String? _selectedTipoEtiqueta;
  String? _selectedTipoCorcho;

  final List<String> _tiposEtiqueta = ['Clásica', 'Moderna', 'Personalizada'];
  final List<String> _tiposCorcho = ['Natural', 'Sintético', 'Tapón de rosca'];
  final List<String> _tamanosBotella = ['750', '500', '375', '1500', 'Otro'];

  @override
  void initState() {
    super.initState();
    _loadLotesAndEmbotellados();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _diaEmbotelladoController.dispose();
    _tamanoBotellaController.dispose();
    _numeroBotellasController.dispose();
    super.dispose();
  }

  Future<void> _loadLotesAndEmbotellados() async {
    setState(() => _loading = true);
    _lotes = await _loteService.obtenerLotesPorProfileId();
    if (_lotes.isNotEmpty) {
      _selectedBatchId = _lotes.first.id;
      await _loadEmbotellados();
    }
    setState(() => _loading = false);
  }

  Future<void> _loadEmbotellados() async {
    if (_selectedBatchId == null) return;
    setState(() => _loading = true);
    _embotellados = await _embotelladoService.obtenerEmbotelladosPorBatchId(_selectedBatchId!);
    _embotelladosFiltrados = _embotellados;
    setState(() => _loading = false);
  }

  void _filtrarEmbotellados(String query) {
    final resultados = _embotellados.where((embotellado) {
      return embotellado.id.toString().contains(query);
    }).toList();
    setState(() {
      _embotelladosFiltrados = resultados;
    });
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _showEmbotelladoForm({Embotellado? embotellado}) async {
    _formKey.currentState?.reset();
    _diaEmbotelladoController.clear();
    _tamanoBotellaController.clear();
    _numeroBotellasController.clear();
    _selectedTipoEtiqueta = null;
    _selectedTipoCorcho = null;

    if (embotellado != null) {
      _diaEmbotelladoController.text = embotellado.diaEmbotellado;
      _tamanoBotellaController.text = embotellado.tamanoBotella;
      _numeroBotellasController.text = embotellado.numeroBotellas.toString();
      _selectedTipoEtiqueta = embotellado.tipoEtiqueta;
      _selectedTipoCorcho = embotellado.tipoCorcho;
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(embotellado == null ? 'Nuevo Embotellado' : 'Editar Embotellado'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _diaEmbotelladoController,
                  decoration: const InputDecoration(
                    labelText: 'Día de Embotellado',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async => await _pickDate(_diaEmbotelladoController),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedTipoEtiqueta,
                  decoration: const InputDecoration(labelText: 'Tipo de Etiqueta'),
                  items: _tiposEtiqueta.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedTipoEtiqueta = value),
                  validator: (value) => value == null ? 'Campo obligatorio' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedTipoCorcho,
                  decoration: const InputDecoration(labelText: 'Tipo de Corcho'),
                  items: _tiposCorcho.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedTipoCorcho = value),
                  validator: (value) => value == null ? 'Campo obligatorio' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _tamanoBotellaController.text.isNotEmpty ? _tamanoBotellaController.text : null,
                  decoration: const InputDecoration(labelText: 'Tamaño de Botella (ml)'),
                  items: _tamanosBotella.map((size) {
                    return DropdownMenuItem(value: size, child: Text(size));
                  }).toList(),
                  onChanged: (value) => setState(() => _tamanoBotellaController.text = value!),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: _numeroBotellasController,
                  decoration: const InputDecoration(labelText: 'Número de Botellas'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Campo obligatorio';
                    if (int.tryParse(value) == null) return 'Debe ser un número entero';
                    return null;
                  },
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
                final newEmbotellado = Embotellado(
                  id: embotellado?.id ?? 0,
                  loteId: _selectedBatchId!,
                  diaEmbotellado: _diaEmbotelladoController.text,
                  tamanoBotella: _tamanoBotellaController.text,
                  numeroBotellas: int.parse(_numeroBotellasController.text),
                  tipoEtiqueta: _selectedTipoEtiqueta!,
                  tipoCorcho: _selectedTipoCorcho!,
                );

                if (embotellado == null) {
                  final creado = await _embotelladoService.crearEmbotellado(_selectedBatchId!, newEmbotellado);
                  if (creado != null) {
                    Navigator.pop(context);
                    await _loadEmbotellados();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Embotellado creado exitosamente')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al crear embotellado')));
                  }
                } else {
                  Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF743636),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage())),
        ),
        title: SizedBox(
          height: 80,
          child: Image.asset('assets/logo_eventwine.jpg', fit: BoxFit.fitHeight),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
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
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
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
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AnejoPage())),
                    ),
                    const SizedBox(width: 8),
                    const Text('Embotellado', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedBatchId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Selecciona un Lote', border: OutlineInputBorder()),
              items: _lotes.map((lote) {
                return DropdownMenuItem(value: lote.id, child: Text('Lote ${lote.id} - ${lote.origenVinedo}'));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedBatchId = value);
                _loadEmbotellados();
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por ID de Embotellado',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: _filtrarEmbotellados,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _embotelladosFiltrados.isEmpty
                      ? Center(
                          child: Text(_selectedBatchId == null
                              ? 'Selecciona un lote para ver sus embotellados.'
                              : 'No hay embotellados registrados para este lote.'),
                        )
                      : ListView.builder(
                          itemCount: _embotelladosFiltrados.length,
                          itemBuilder: (context, index) {
                            final emb = _embotelladosFiltrados[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: const Icon(Icons.local_drink, color: Colors.teal),
                                title: Text('Embotellado #${emb.id}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Día: ${emb.diaEmbotellado}'),
                                    Text('Tamaño: ${emb.tamanoBotella}ml | Botellas: ${emb.numeroBotellas}'),
                                    Text('Etiqueta: ${emb.tipoEtiqueta} | Corcho: ${emb.tipoCorcho}'),
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
                                        title: const Text('Detalles del Embotellado'),
                                        content: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('ID: ${emb.id}'),
                                            Text('Lote ID: ${emb.loteId}'),
                                            Text('Día: ${emb.diaEmbotellado}'),
                                            Text('Tamaño: ${emb.tamanoBotella} ml'),
                                            Text('Botellas: ${emb.numeroBotellas}'),
                                            Text('Etiqueta: ${emb.tipoEtiqueta}'),
                                            Text('Corcho: ${emb.tipoCorcho}'),
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
      floatingActionButton: _embotellados.isEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Colors.amber,
              onPressed: () => _showEmbotelladoForm(),
              label: const Text('Nuevo Embotellado'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}
