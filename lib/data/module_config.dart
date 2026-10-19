import 'package:flutter/material.dart';

class DataField {
  final String key;
  final String label;
  final TextInputType keyboard;
  final bool required;
  const DataField(this.key, this.label,
      {this.keyboard = TextInputType.text, this.required = true});
}

class ModuleConfig {
  final String title;
  final IconData icon;
  final String listPath;
  final String addPath;
  final String editPath;
  final String deletePath;
  final String listKey;
  final String idInList;
  final String idForWrite;
  final String nameKey;
  final String? stateKey;
  final String? defaultState;
  final List<String> states;
  final List<DataField> fields;

  const ModuleConfig({
    required this.title,
    required this.icon,
    required this.listPath,
    required this.addPath,
    required this.editPath,
    required this.deletePath,
    required this.listKey,
    required this.idInList,
    required this.idForWrite,
    required this.nameKey,
    required this.fields,
    this.stateKey,
    this.defaultState,
    this.states = const [],
  });

  String itemName(Map<String, dynamic> item) {
    if (title == 'Proveedores') {
      return '${item['provider_name'] ?? ''} ${item['provider_last_name'] ?? ''}'.trim();
    }
    return '${item[nameKey] ?? 'Sin nombre'}';
  }
}

const modules = <ModuleConfig>[
  ModuleConfig(
    title: 'Productos', icon: Icons.inventory_2_outlined,
    listPath: 'product_list_rest/', addPath: 'product_add_rest/',
    editPath: 'product_edit_rest/', deletePath: 'product_del_rest/',
    listKey: 'Listado', idInList: 'product_id', idForWrite: 'product_id',
    nameKey: 'product_name', stateKey: 'product_state',
    defaultState: 'Activo', states: ['Activo', 'Inactivo'],
    fields: [
      DataField('product_name', 'Nombre del producto'),
      DataField('product_price', 'Precio', keyboard: TextInputType.number),
      DataField('product_image', 'URL de imagen', keyboard: TextInputType.url, required: false),
    ],
  ),
  ModuleConfig(
    title: 'Categorías', icon: Icons.category_outlined,
    listPath: 'category_list_rest/', addPath: 'category_add_rest/',
    editPath: 'category_edit_rest/', deletePath: 'category_del_rest/',
    listKey: 'Listado Categorias', idInList: 'category_id',
    idForWrite: 'category_id', nameKey: 'category_name',
    stateKey: 'category_state', defaultState: 'Activa',
    states: ['Activa', 'Inactiva'],
    fields: [DataField('category_name', 'Nombre de categoría')],
  ),
  ModuleConfig(
    title: 'Proveedores', icon: Icons.local_shipping_outlined,
    listPath: 'provider_list_rest/', addPath: 'provider_add_rest/',
    editPath: 'provider_edit_rest/', deletePath: 'provider_del_rest/',
    listKey: 'Proveedores Listado', idInList: 'providerid',
    idForWrite: 'provider_id', nameKey: 'provider_name',
    stateKey: 'provider_state', defaultState: 'Activo',
    states: ['Activo', 'Inactivo'],
    fields: [
      DataField('provider_name', 'Nombre'),
      DataField('provider_last_name', 'Apellido'),
      DataField('provider_mail', 'Correo electrónico', keyboard: TextInputType.emailAddress),
    ],
  ),
];
