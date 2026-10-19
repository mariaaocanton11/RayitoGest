import 'academic_api.dart';
import 'module_config.dart';

class ModuleRepository {
  final AcademicApi _api;
  ModuleRepository({AcademicApi? api}) : _api = api ?? AcademicApi();

  Future<List<Map<String, dynamic>>> list(ModuleConfig config) async {
    final response = await _api.get(config.listPath);
    if (response is! Map) throw const FormatException('Respuesta inesperada');
    final entries = response[config.listKey];
    if (entries is! List) throw const FormatException('Listado no disponible');
    return entries.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> create(ModuleConfig config, Map<String, dynamic> values) async {
    final payload = Map<String, dynamic>.from(values);
    // La API de productos y categorías acepta altas sin estado.
    if (config.title == 'Proveedores') {
      payload[config.stateKey!] = config.defaultState;
    }
    await _api.post(config.addPath, payload);
  }

  Future<void> update(ModuleConfig config, Map<String, dynamic> item,
      Map<String, dynamic> values) async {
    final payload = Map<String, dynamic>.from(values);
    payload[config.idForWrite] = item[config.idInList];
    if (config.stateKey != null) {
      payload[config.stateKey!] = values[config.stateKey] ??
          item[config.stateKey] ?? config.defaultState;
    }
    await _api.post(config.editPath, payload);
  }

  Future<void> remove(ModuleConfig config, Map<String, dynamic> item) async {
    await _api.post(config.deletePath, {
      config.idForWrite: item[config.idInList],
    });
  }
}
