import 'package:flutter/material.dart';
import 'package:eventwine/feature/register_and_login/presentation/pages/register_page.dart';
import 'package:eventwine/feature/register_and_login/presentation/pages/login_page.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';
import 'package:eventwine/feature/home/presentation/pages/homewine_page.dart';
import 'package:eventwine/feature/lote/presentation/pages/lote_page.dart';
import 'package:eventwine/feature/fermentacion/presentation/pages/fermentacion_page.dart';
import 'package:eventwine/feature/clarificacion/presentation/pages/clarificacion_page.dart';
import 'package:eventwine/feature/prensado/presentation/pages/prensado_page.dart';
import 'package:eventwine/feature/anejo/presentation/pages/anejo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventWine',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/prensado',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),	
        '/home-wine': (context) => const HomeWinePage(),
        '/lote': (context) => LotePage(),
        '/fermentacion': (context) => FermentacionPage(),
        '/clarificacion': (context) => ClarificacionPage(),
        '/prensado': (context) => PrensadoPage(),
        '/anejo': (context) => AnejoPage(),
      },
    );
  }
}
