import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_projetoyuri/pages/login_page.dart';
import 'package:app_projetoyuri/pages/home_page.dart';
import 'package:app_projetoyuri/pages/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/theme_provider.dart';
import 'package:app_projetoyuri/providers/pet_provider.dart';
import 'package:app_projetoyuri/providers/auth_provider.dart';


// 🔹 Temas personalizados
final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFFB84D),
  scaffoldBackgroundColor: const Color(0xFFFFF8E6),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFB84D),
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFFE6A7),
    selectedItemColor: Color(0xFFFF8A00),
    unselectedItemColor: Colors.grey,
  ),
  cardColor: const Color(0xFFFFF8E6),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFFB84D),
    onPrimary: Colors.white,
    secondary: Color(0xFFFF8A00),
    onSecondary: Colors.white,
    surface: Color(0xFFFFF8E6),
    onSurface: Colors.black,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFFFB84D),
  scaffoldBackgroundColor: const Color(0xFF2B2B2B),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFF8A00),
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF3C3C3C),
    selectedItemColor: Color(0xFFFFB84D),
    unselectedItemColor: Colors.grey,
  ),
  cardColor: const Color(0xFF3C3C3C),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFFB84D),
    onPrimary: Colors.white,
    secondary: Color(0xFFFF8A00),
    onSecondary: Colors.white,
    surface: Color(0xFF3C3C3C),
    onSurface: Colors.white,
  ),
);

void main() async {
  //  CONFIGURAÇÃO CORRETA
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'AdotePet',
            theme: lightTheme,      // tema claro personalizado
            darkTheme: darkTheme,   // tema escuro personalizado
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginPage(),
              '/home': (context) => const HomePage(),
              '/settings': (context) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}







