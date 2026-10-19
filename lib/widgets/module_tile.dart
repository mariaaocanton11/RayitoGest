import 'package:flutter/material.dart';
import '../core/rayito_theme.dart';

class ModuleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ModuleTile({super.key, required this.title, required this.subtitle,
    required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: RayitoTheme.light,
          borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: RayitoTheme.rose, size: 28),
      ),
      title: Text(title, style: const TextStyle(
        fontWeight: FontWeight.bold, color: RayitoTheme.deep)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
        size: 16, color: RayitoTheme.rose),
    ),
  );
}
