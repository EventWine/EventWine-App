import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';
import 'package:eventwine/feature/prensado/presentation/pages/prensado_page.dart';
import 'package:eventwine/feature/embotellado/presentation/pages/embotellado_page.dart';
import 'package:eventwine/feature/lote/data/remote/lote_service.dart';
import 'package:eventwine/feature/lote/data/remote/lote_model.dart';
import 'package:eventwine/feature/anejo/data/remote/anejo_service.dart';
import 'package:eventwine/feature/anejo/data/remote/anejo_model.dart';

class AnejoPage extends StatefulWidget {
  @override
  _AnejoPageState createState() => _AnejoPageState();
}

class _AnejoPageState extends State<AnejoPage> {
  final LoteService _loteService = LoteService();
  final AnejoService _anejoService = AnejoService();

  List<Lote> _lotes = [];
  List<Anejo> _anejos = [];
  List<Anejo> _anejosFiltrados = [];
  int? _selectedBatchId;
  bool _loading = true;

  final TextEditingController _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _diaInicioController = TextEditingController();
  final TextEditingController _diaFinalController = TextEditingController();
  final TextEditingController _duracionMesesController = TextEditingController();
  final TextEditingController _resultadoInspeccionController = TextEditingController();

  String? _selectedTipoBarrica;
  bool? _selectedInspeccionesRealizadas;
  String? _selectedResultadoInspeccion;

  final List<String> _tiposBarrica = [
    'Roble Francés',
    'Roble Americano',
    'Roble Húngaro',
    'Acero Inoxidable',
    'Otro'
  ];

  final List<String> _resultadoOpciones = ['Óptimo', 'Bueno', 'Regular', 'Deficiente'];


  @override
  void initState() {
    super.initState();
    _loadLotesAndAnejos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _diaInicioController.dispose();
    _diaFinalController.dispose();
    _duracionMesesController.dispose();
    _resultadoInspeccionController.dispose();
    super.dispose();
  }

  Future<void> _loadLotesAndAnejos() async {
    setState(() => _loading = true);
    _lotes = await _loteService.obtenerLotesPorProfileId();
    if (_lotes.isNotEmpty) {
      _selectedBatchId = _lotes.first.id;
      await _loadAnejos();
    }
    setState(() => _loading = false);
  }

  Future<void> _loadAnejos() async {
    if (_selectedBatchId == null) return;
    setState(() => _loading = true);
    _anejos = await _anejoService.obtenerAnejosPorBatchId(_selectedBatchId!);
    _anejosFiltrados = _anejos;
    setState(() => _loading = false);
  }

  void _filtrarAnejos(String query) {
    final resultados = _anejos.where((anejo) {
      return anejo.id.toString().contains(query);
    }).toList();
    setState(() {
      _anejosFiltrados = resultados;
    });
  }

  int _calculateDurationInMonths() {
    try {
      final startDate = DateTime.parse(_diaInicioController.text);
      final endDate = DateTime.parse(_diaFinalController.text);

      if (startDate.isAfter(endDate)) {
        return 0;
      }

      int years = endDate.year - startDate.year;
      int months = endDate.month - startDate.month;
      int days = endDate.day - startDate.day;

      int totalMonths = years * 12 + months;

      if (days < 0) {
        totalMonths--;
      }

      return totalMonths < 0 ? 0 : totalMonths;
    } catch (e) {
      return 0;
    }
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
        if (_diaInicioController.text.isNotEmpty && _diaFinalController.text.isNotEmpty) {
          _duracionMesesController.text = _calculateDurationInMonths().toString();
        }
      });
    }
  }

  Future<void> _showAnejoForm({Anejo? anejo}) async {
    _formKey.currentState?.reset();
    _diaInicioController.clear();
    _diaFinalController.clear();
    _duracionMesesController.clear();
    _resultadoInspeccionController.clear();

    _selectedTipoBarrica = null;
    _selectedInspeccionesRealizadas = null;
    _selectedResultadoInspeccion = null;

    if (anejo != null) {
      _selectedTipoBarrica = anejo.tipoBarrica;
      _diaInicioController.text = anejo.diaInicio;
      _diaFinalController.text = anejo.diaFinal;
      _duracionMesesController.text = anejo.duracionMeses.toString();
      _selectedInspeccionesRealizadas = anejo.inspeccionesRealizadas == 1;
      _selectedResultadoInspeccion = anejo.resultadoInspeccion;
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(anejo == null ? 'Nuevo Añejamiento' : 'Editar Añejamiento'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedTipoBarrica,
                  decoration: const InputDecoration(labelText: 'Tipo de Barrica'),
                  items: _tiposBarrica.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTipoBarrica = value;
                    });
                  },
                  validator: (value) => value == null ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: _diaInicioController,
                  decoration: const InputDecoration(
                    labelText: 'Día de Inicio',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    await _pickDate(_diaInicioController);
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: _diaFinalController,
                  decoration: const InputDecoration(
                    labelText: 'Día Final',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    await _pickDate(_diaFinalController);
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                ),
                TextFormField(
                  controller: _duracionMesesController,
                  decoration: const InputDecoration(labelText: 'Duración (Meses)'),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione ambas fechas para calcular la duración.';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Debe ser un número entero';
                    }
                    if (int.parse(value) <= 0) {
                      return 'La duración debe ser mayor a 0.';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<bool>(
                  value: _selectedInspeccionesRealizadas,
                  decoration: const InputDecoration(labelText: 'Inspecciones Realizadas'),
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Sí')),
                    DropdownMenuItem(value: false, child: Text('No')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedInspeccionesRealizadas = value;
                    });
                  },
                  validator: (value) => value == null ? 'Campo obligatorio' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedResultadoInspeccion,
                  decoration: const InputDecoration(labelText: 'Resultado de Inspección'),
                  items: _resultadoOpciones.map((opcion) {
                    return DropdownMenuItem(
                      value: opcion,
                      child: Text(opcion),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedResultadoInspeccion = value;
                    });
                  },
                  validator: (value) => value == null ? 'Campo obligatorio' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && _selectedBatchId != null) {
                final newAnejo = Anejo(
                  id: anejo?.id ?? 0,
                  loteId: _selectedBatchId!,
                  tipoBarrica: _selectedTipoBarrica!,
                  diaInicio: _diaInicioController.text,
                  diaFinal: _diaFinalController.text,
                  duracionMeses: int.parse(_duracionMesesController.text),
                  inspeccionesRealizadas: _selectedInspeccionesRealizadas! ? 1 : 0,
                  resultadoInspeccion: _selectedResultadoInspeccion!,
                );

                if (anejo == null) {
                  final createdAnejo = await _anejoService.crearAnejo(_selectedBatchId!, newAnejo);
                  if (createdAnejo != null) {
                    Navigator.pop(context);
                    await _loadAnejos();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Añejamiento creado exitosamente')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al crear añejamiento')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('La edición de añejamientos no está implementada aún.')),
                  );
                  Navigator.pop(context);
                }
              }
            },
            child: Text(anejo == null ? 'Guardar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canCreateAnejo = _anejos.isEmpty;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título "Vinificación" centrado
            Center(
              child: const Text(
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

            // Cuadro de navegación de añejamientos centrado
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => PrensadoPage()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Añejamientos',
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
                          MaterialPageRoute(builder: (context) => EmbotelladoPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              value: _selectedBatchId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Selecciona un Lote',
                border: OutlineInputBorder(),
              ),
              items: _lotes.map((lote) {
                return DropdownMenuItem(
                  value: lote.id,
                  child: Text('Lote ${lote.id} - ${lote.origenVinedo}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBatchId = value;
                });
                _loadAnejos();
              },
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por ID de Añejamiento',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filtrarAnejos,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _anejosFiltrados.isEmpty
                      ? Center(
                          child: Text(_selectedBatchId == null
                              ? 'Selecciona un lote para ver sus añejamientos.'
                              : 'No hay añejamientos registrados para este lote o no hay resultados para la búsqueda.'),
                        )
                      : ListView.builder(
                          itemCount: _anejosFiltrados.length,
                          itemBuilder: (context, index) {
                            final anejo = _anejosFiltrados[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                leading: const Icon(Icons.wine_bar, color: Colors.deepPurple),
                                title: Text('Añejamiento #${anejo.id}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tipo: ${anejo.tipoBarrica}'),
                                    Text('Inicio: ${anejo.diaInicio} | Fin: ${anejo.diaFinal}'),
                                    Text('Inspecciones: ${anejo.inspeccionesRealizadas == 1 ? 'Sí' : 'No'}'),
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
                                        title: const Text('Detalles del Añejamiento'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('ID: ${anejo.id}'),
                                            Text('Lote ID: ${anejo.loteId}'),
                                            Text('Tipo de Barrica: ${anejo.tipoBarrica}'),
                                            Text('Día de Inicio: ${anejo.diaInicio}'),
                                            Text('Día Final: ${anejo.diaFinal}'),
                                            Text('Duración (Meses): ${anejo.duracionMeses}'),
                                            Text('Inspecciones Realizadas: ${anejo.inspeccionesRealizadas == 1 ? 'Sí' : 'No'}'),
                                            Text('Resultado de Inspección: ${anejo.resultadoInspeccion}'),
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
      floatingActionButton: canCreateAnejo
          ? FloatingActionButton.extended(
              backgroundColor: Colors.amber,
              onPressed: () => _showAnejoForm(),
              label: const Text('Nuevo Añejamiento'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}