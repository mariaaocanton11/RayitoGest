import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/rayito_theme.dart';
import '../../data/module_config.dart';
import '../../widgets/module_tile.dart';
import '../catalog/module_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas salir de Rayito Gest?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialog, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(dialog, true), child: const Text('Salir')),
        ],
      ),
    );
    if (yes != true || !context.mounted) return;
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo cerrar sesión: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Row(children: [
        Icon(Icons.wb_sunny_outlined, color: RayitoTheme.rose),
        SizedBox(width: 9), Text('Rayito Gest'),
      ]),
      actions: [IconButton(icon: const Icon(Icons.logout),
        tooltip: 'Cerrar sesión', onPressed: () => _logout(context))],
    ),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(
        decoration: BoxDecoration(color: RayitoTheme.blush,
          borderRadius: BorderRadius.circular(23)),
        padding: const EdgeInsets.all(24),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('MI ESPACIO DE GESTIÓN', style: TextStyle(
            color: RayitoTheme.mauve, fontSize: 12, letterSpacing: 1,
            fontWeight: FontWeight.w700)),
          SizedBox(height: 9),
          Text('¡Hola, bienvenida!', style: TextStyle(
            fontSize: 26, color: RayitoTheme.deep, fontWeight: FontWeight.bold)),
          SizedBox(height: 7),
          Text('Organiza tus productos y proveedores de manera sencilla.',
            style: TextStyle(color: RayitoTheme.mauve)),
        ]),
      ),
      const SizedBox(height: 26),
      const Text('Mis módulos', style: TextStyle(fontSize: 22,
        fontWeight: FontWeight.bold, color: RayitoTheme.deep)),
      const SizedBox(height: 13),
      for (final module in modules)
        ModuleTile(
          title: module.title,
          subtitle: module.title == 'Productos' ? 'Administrar inventario'
              : module.title == 'Categorías' ? 'Organizar productos' : 'Gestionar contactos',
          icon: module.icon,
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ModuleListPage(config: module))),
        ),
      const SizedBox(height: 24),
      const Center(child: Text('Rayito Gest · Administración sencilla',
        style: TextStyle(color: RayitoTheme.mauve, fontSize: 12))),
    ]),
  );
}
