import 'package:flutter/material.dart';
import '../../core/rayito_theme.dart';
import '../../data/module_config.dart';
import '../../data/module_repository.dart';

class RecordFormPage extends StatefulWidget {
  final ModuleConfig config;
  final Map<String, dynamic>? original;
  const RecordFormPage({super.key, required this.config, this.original});
  @override
  State<RecordFormPage> createState() => _RecordFormPageState();
}

class _RecordFormPageState extends State<RecordFormPage> {
  final form = GlobalKey<FormState>();
  final repository = ModuleRepository();
  final controllers = <String, TextEditingController>{};
  bool saving = false;
  String? state;

  bool get isEditing => widget.original != null;

  @override
  void initState() {
    super.initState();
    for (final field in widget.config.fields) {
      controllers[field.key] = TextEditingController(
        text: '${widget.original?[field.key] ?? ''}');
    }
    final config = widget.config;
    state = config.states.contains(widget.original?[config.stateKey])
        ? '${widget.original?[config.stateKey]}' : config.defaultState;
  }

  @override
  void dispose() {
    for (final controller in controllers.values) { controller.dispose(); }
    super.dispose();
  }

  Future<void> save() async {
    if (!form.currentState!.validate()) return;
    setState(() => saving = true);
    try {
      final values = <String, dynamic>{};
      for (final field in widget.config.fields) {
        final content = controllers[field.key]!.text.trim();
        if (field.key == 'product_price') {
          values[field.key] = num.parse(content.replaceAll(',', '.'));
        } else {
          values[field.key] = content;
        }
      }
      if (isEditing && widget.config.stateKey != null) {
        values[widget.config.stateKey!] = state;
      }
      if (isEditing) {
        await repository.update(widget.config, widget.original!, values);
      } else {
        await repository.create(widget.config, values);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
     if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('No se pudo guardar: $e'),
    ),
  );
}
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(isEditing ? 'Editar ${widget.config.title.toLowerCase()}'
        : 'Agregar ${widget.config.title.toLowerCase()}')),
    body: Form(key: form, child: ListView(
      padding: const EdgeInsets.all(20), children: [
        const Text('Información del registro', style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: RayitoTheme.deep)),
        const SizedBox(height: 18),
        for (final field in widget.config.fields) ...[
          TextFormField(
            controller: controllers[field.key],
            keyboardType: field.keyboard,
            decoration: InputDecoration(labelText: field.label),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (field.required && text.isEmpty) return 'Completa ${field.label.toLowerCase()}';
              if (field.key == 'product_price' &&
                  (num.tryParse(text.replaceAll(',', '.')) == null ||
                   (num.tryParse(text.replaceAll(',', '.')) ?? 0) < 0)) {
                return 'Ingresa un precio válido';
              }
              if (field.key == 'provider_mail' &&
                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
        ],
        if (isEditing && widget.config.stateKey != null) ...[
          DropdownButtonFormField<String>(
            initialValue: state,
            decoration: const InputDecoration(labelText: 'Estado'),
            items: widget.config.states.map((v) => DropdownMenuItem(
              value: v, child: Text(v))).toList(),
            onChanged: (value) => setState(() => state = value),
          ),
          const SizedBox(height: 15),
        ],
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: saving ? null : save,
          icon: const Icon(Icons.save_outlined),
          label: Text(saving ? 'Guardando...' : 'Guardar cambios'),
        ),
      ],
    )),
  );
}
