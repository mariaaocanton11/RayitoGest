import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/rayito_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool waiting = false;
  bool visible = false;

  @override
  void dispose() { email.dispose(); password.dispose(); super.dispose(); }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    setState(() => waiting = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final message = e.code == 'invalid-credential' || e.code == 'user-not-found' ||
          e.code == 'wrong-password' ? 'Correo o contraseña incorrectos.'
          : e.code == 'network-request-failed' ? 'Revisa la conexión a Internet.'
          : 'No fue posible ingresar (${e.code}).';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
    if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error de conexión: $e'),
    ),
   );
}
    } finally {
      if (mounted) setState(() => waiting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(26), child: Form(
        key: form,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.wb_sunny_outlined, size: 85, color: RayitoTheme.rose),
          const SizedBox(height: 14),
          const Text('Rayito Gest', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold,
              color: RayitoTheme.deep)),
          const SizedBox(height: 7),
          const Text('Bienvenida a tu espacio de gestión',
            textAlign: TextAlign.center,
            style: TextStyle(color: RayitoTheme.mauve)),
          const SizedBox(height: 32),
          TextFormField(controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Correo electrónico',
              prefixIcon: Icon(Icons.mail_outline)),
            validator: (v) => v == null || !v.contains('@') ? 'Ingresa un correo válido' : null),
          const SizedBox(height: 14),
          TextFormField(controller: password, obscureText: !visible,
            decoration: InputDecoration(labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => visible = !visible))),
            validator: (v) => v == null || v.isEmpty ? 'Ingresa tu contraseña' : null,
            onFieldSubmitted: (_) => submit()),
          const SizedBox(height: 24),
          FilledButton.icon(onPressed: waiting ? null : submit,
            icon: const Icon(Icons.login),
            label: Text(waiting ? 'Ingresando...' : 'Iniciar sesión')),
        ]),
      ),
    ))),
  );
}
