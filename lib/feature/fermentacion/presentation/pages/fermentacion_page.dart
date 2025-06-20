import 'package:eventwine/feature/lote/presentation/pages/lote_page.dart';
import 'package:flutter/material.dart';
import 'package:eventwine/feature/lote/data/remote/lote_service.dart';
import 'package:eventwine/feature/lote/data/remote/lote_model.dart';
import 'package:eventwine/feature/fermentacion/data/remote/fermentacion_service.dart';
import 'package:eventwine/feature/fermentacion/data/remote/fermentacion_model.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';
import 'package:eventwine/feature/clarificacion/presentation/pages/clarificacion_page.dart';
import 'package:intl/intl.dart';

class FermentacionPage extends StatefulWidget {
  @override
  _FermentacionPageState createState() => _FermentacionPageState();
}

class _FermentacionPageState extends State<FermentacionPage> {
  final LoteService loteService = LoteService();
  final FermentacionService fermentService = FermentacionService();

  List<Lote> lotes = [];
  int? _selectedBatchId;
  List<Fermentacion> fermentaciones = [];
  List<Fermentacion> fermentacionesFiltradas = [];
  TextEditingController searchController = TextEditingController();
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final fechaInicioController = TextEditingController();
  final fechaFinalController = TextEditingController();
  final temperaturaController = TextEditingController();
  final densidadInicialController = TextEditingController();
  final phInicialController = TextEditingController();
  final densidadFinalController = TextEditingController();
  final phFinalController = TextEditingController();
  final azucarController = TextEditingController();

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
      await _cargarFermentaciones();
    }
    setState(() => _isLoading = false);
  }

  Future<void> _cargarFermentaciones() async {
    if (_selectedBatchId == null) return;
    setState(() => _isLoading = true);
    fermentaciones = await fermentService.obtenerFermentacionesPorBatchId(_selectedBatchId!);
    fermentacionesFiltradas = fermentaciones;
    setState(() => _isLoading = false);
  }

  void _filtrarFermentaciones(String query) {
    final resultados = fermentaciones.where((f) {
      return f.id.toString().contains(query);
    }).toList();
    setState(() => fermentacionesFiltradas = resultados);
  }

  void _onBatchChanged(int? newId) async {
    if (newId == null) return;
    setState(() => _selectedBatchId = newId);
    await _cargarFermentaciones();
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

  Future<void> _mostrarFormularioNuevaFermentacion() async {
    _formKey.currentState?.reset();
    fechaInicioController.clear();
    fechaFinalController.clear();
    temperaturaController.clear();
    densidadInicialController.clear();
    phInicialController.clear();
    densidadFinalController.clear();
    phFinalController.clear();
    azucarController.clear();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Fermentación'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: fechaInicioController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Inicio',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _seleccionarFecha(fechaInicioController),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: fechaFinalController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha Final',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _seleccionarFecha(fechaFinalController),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: temperaturaController,
                  decoration: const InputDecoration(labelText: 'Temperatura media (°C)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: densidadInicialController,
                  decoration: const InputDecoration(labelText: 'Densidad inicial'),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: phInicialController,
                  decoration: const InputDecoration(labelText: 'pH inicial'),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: densidadFinalController,
                  decoration: const InputDecoration(labelText: 'Densidad final'),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: phFinalController,
                  decoration: const InputDecoration(labelText: 'pH final'),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: azucarController,
                  decoration: const InputDecoration(labelText: 'Azúcar residual (g/L)'),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Guardar'),
            onPressed: () async {
              if (_formKey.currentState!.validate() && _selectedBatchId != null) {
                final nueva = Fermentacion(
                  id: 0,
                  loteId: _selectedBatchId!,
                  fechaInicio: fechaInicioController.text,
                  fechaFinal: fechaFinalController.text,
                  temperaturaMedia: double.parse(temperaturaController.text),
                  densidadInicial: double.parse(densidadInicialController.text),
                  phInicial: double.parse(phInicialController.text),
                  densidadFinal: double.parse(densidadFinalController.text),
                  phFinal: double.parse(phFinalController.text),
                  azucarResidual: double.parse(azucarController.text),
                );

                final creada = await fermentService.crearFermentacion(_selectedBatchId!, nueva);
                if (creada != null) {
                  Navigator.pop(context);
                  await _cargarFermentaciones();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fermentación creada exitosamente')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al crear la fermentación')),
                  );
                }
              }
            },
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LotePage()),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Fermentaciones',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ClarificacionPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedBatchId,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Selecciona un lote',
              ),
              items: lotes.map((lote) {
                return DropdownMenuItem<int>(
                  value: lote.id,
                  child: Text('Lote ${lote.id} - ${lote.origenVinedo}'),
                );
              }).toList(),
              onChanged: _onBatchChanged,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por ID de fermentación',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filtrarFermentaciones,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: fermentacionesFiltradas.length,
                      itemBuilder: (context, index) {
                        final f = fermentacionesFiltradas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.local_drink, color: Colors.blue),
                            title: Text('Fermentación #${f.id}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Inicio: ${f.fechaInicio}'),
                                Text('Final: ${f.fechaFinal}'),
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
                                    title: const Text('Detalles de la Fermentación'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('ID: ${f.id}'),
                                        Text('Lote ID: ${f.loteId}'),
                                        Text('Fecha de Inicio: ${f.fechaInicio}'),
                                        Text('Fecha Final: ${f.fechaFinal}'),
                                        Text('Temperatura Media: ${f.temperaturaMedia} °C'),
                                        Text('Densidad Inicial: ${f.densidadInicial}'),
                                        Text('pH Inicial: ${f.phInicial}'),
                                        Text('Densidad Final: ${f.densidadFinal}'),
                                        Text('pH Final: ${f.phFinal}'),
                                        Text('Azúcar Residual: ${f.azucarResidual} g/L'),
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
      floatingActionButton: fermentaciones.isEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Colors.amber,
              onPressed: _mostrarFormularioNuevaFermentacion,
              label: const Text('Nueva fermentación'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}
