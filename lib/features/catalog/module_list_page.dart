import 'package:flutter/material.dart';
import '../../core/rayito_theme.dart';
import '../../data/module_config.dart';
import '../../data/module_repository.dart';
import 'record_detail_page.dart';
import 'record_form_page.dart';

class ModuleListPage extends StatefulWidget {
  final ModuleConfig config;
  const ModuleListPage({super.key, required this.config});
  @override
  State<ModuleListPage> createState() => _ModuleListPageState();
}

class _ModuleListPageState extends State<ModuleListPage> {
  final repository = ModuleRepository();
  late Future<List<Map<String, dynamic>>> future;

  @override
  void initState() { super.initState(); refresh(); }
  void refresh() {
  setState(() {
    future = repository.list(widget.config);
  });
  }

  Future<void> add() async {
    final saved = await Navigator.push<bool>(context, MaterialPageRoute(
      builder: (_) => RecordFormPage(config: widget.config)));
    if (saved == true && mounted) refresh();
  }

  Future<void> open(Map<String, dynamic> item) async {
    final changed = await Navigator.push<bool>(context, MaterialPageRoute(
      builder: (_) => RecordDetailPage(config: widget.config, item: item)));
    if (changed == true && mounted) refresh();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.config.title), actions: [
      IconButton(onPressed: refresh, tooltip: 'Actualizar',
        icon: const Icon(Icons.refresh)),
    ]),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: add, backgroundColor: RayitoTheme.rose,
      foregroundColor: Colors.white, icon: const Icon(Icons.add),
      label: const Text('Agregar')),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Padding(padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.wifi_off_outlined, color: RayitoTheme.rose, size: 42),
              const SizedBox(height: 12),
              Text('No se pudo cargar ${widget.config.title.toLowerCase()}.\n${snapshot.error}',
                textAlign: TextAlign.center),
              TextButton(onPressed: refresh, child: const Text('Reintentar')),
            ])));
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) return const Center(child: Text('No hay registros disponibles.'));
        return RefreshIndicator(
          onRefresh: () async { refresh(); await future; },
          child: ListView.builder(padding: const EdgeInsets.fromLTRB(14, 8, 14, 85),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final config = widget.config;
              final state = config.stateKey == null ? '' :
                  '${item[config.stateKey] ?? ''}';
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: RayitoTheme.light,
                    child: Icon(config.icon, color: RayitoTheme.rose)),
                  title: Text(config.itemName(item),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600,
                      color: RayitoTheme.deep)),
                  subtitle: Text('Código: ${item[config.idInList]}${state.isEmpty ? '' : ' · $state'}'),
                  trailing: const Icon(Icons.chevron_right, color: RayitoTheme.rose),
                  onTap: () => open(item),
                ),
              );
            }),
        );
      },
    ),
  );
}
