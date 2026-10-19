import 'package:flutter/material.dart';
import '../../core/rayito_theme.dart';
import '../../data/module_config.dart';
import '../../data/module_repository.dart';
import 'record_form_page.dart';

class RecordDetailPage extends StatelessWidget {
  final ModuleConfig config;
  final Map<String, dynamic> item;
  const RecordDetailPage({super.key, required this.config, required this.item});

  Future<void> edit(BuildContext context) async {
    final changed = await Navigator.push<bool>(context, MaterialPageRoute(
      builder: (_) => RecordFormPage(config: config, original: item)));
    if (changed == true && context.mounted) Navigator.pop(context, true);
  }

  Future<void> delete(BuildContext context) async {
    final confirm = await showDialog<bool>(context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: Text('¿Eliminar "${config.itemName(item)}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(dialog, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Eliminar')),
        ],
      ));
    if (confirm != true || !context.mounted) return;
    try {
      await ModuleRepository().remove(config, item);
      if (context.mounted) Navigator.pop(context, true);
    } catch (e) {
      if (context.mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('No se pudo eliminar: $e'),
    ),
  );
}
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalle')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(color: RayitoTheme.blush,
          borderRadius: BorderRadius.circular(23)),
        child: Column(children: [
          Icon(config.icon, size: 72, color: RayitoTheme.rose),
          const SizedBox(height: 12),
          Text(config.itemName(item), textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold,
              color: RayitoTheme.deep)),
        ]),
      ),
      const SizedBox(height: 20),
      Card(child: Column(children: [
        ListTile(title: const Text('Código'), subtitle: Text('${item[config.idInList]}')),
        for (final field in config.fields)
          ListTile(title: Text(field.label),
            subtitle: Text('${item[field.key] ?? '-'}')),
        if (config.stateKey != null)
          ListTile(title: const Text('Estado'),
            subtitle: Text('${item[config.stateKey] ?? '-'}')),
      ])),
      const SizedBox(height: 20),
      FilledButton.icon(onPressed: () => edit(context),
        icon: const Icon(Icons.edit_outlined), label: const Text('Editar')),
      const SizedBox(height: 10),
      OutlinedButton.icon(onPressed: () => delete(context),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red.shade700,
          padding: const EdgeInsets.symmetric(vertical: 16)),
        icon: const Icon(Icons.delete_outline), label: const Text('Eliminar')),
    ]),
  );
}
