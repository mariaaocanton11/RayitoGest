import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/rayito_theme.dart';
import 'features/auth/login_page.dart';
import 'features/home/home_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RayitoGestApp());
}

class RayitoGestApp extends StatelessWidget {
  const RayitoGestApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Rayito Gest',
    debugShowCheckedModeBanner: false,
    theme: RayitoTheme.theme,
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('No fue posible comprobar la sesión.')));
        }
        return snapshot.hasData ? const HomePage() : const LoginPage();
      },
    ),
  );
}
