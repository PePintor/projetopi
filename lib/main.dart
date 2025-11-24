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
  // ✅ CONFIGURAÇÃO CORRETA
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















//Criar uma tela com Slider e RadioListTile, exibindo os valores abaixo em Text.

// lib/pages/controls_page.dart
// import 'package:flutter/material.dart';

// class ControlsPage extends StatefulWidget {
//   const ControlsPage({super.key});

//   @override
//   State<ControlsPage> createState() => _ControlsPageState();
// }

// class _ControlsPageState extends State<ControlsPage> {
//   double _sliderValue = 50.0;
//   String _selectedOption = 'opcaoA';

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Slider & Radio - Exemplo'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTitle('Valor do Slider'),
//             Slider(
//               value: _sliderValue,
//               min: 0,
//               max: 100,
//               divisions: 100,
//               label: _sliderValue.toStringAsFixed(0),
//               onChanged: (value) => setState(() => _sliderValue = value),
//             ),
//             Text('Slider: ${_sliderValue.toStringAsFixed(0)}',
//                 style: TextStyle(color: theme.textTheme.bodyLarge?.color)),

//             const SizedBox(height: 24),

//             _buildTitle('Escolha uma opção'),
//             _buildRadio('Opção A', 'opcaoA'),
//             _buildRadio('Opção B', 'opcaoB'),

//             const SizedBox(height: 16),
//             Divider(color: theme.disabledColor),
//             const SizedBox(height: 8),

//             _buildTitle('Resultado:'),
//             Text('Valor do Slider: ${_sliderValue.toStringAsFixed(0)}'),
//             Text('Opção selecionada: ${_formatOption(_selectedOption)}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTitle(String text) => Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//       );

//   Widget _buildRadio(String title, String value) {
//     return RadioListTile<String>(
//       title: Text(title),
//       value: value,
//       // ignore: deprecated_member_use
//       groupValue: _selectedOption,
//       // ignore: deprecated_member_use
//       onChanged: (v) => setState(() => _selectedOption = v!),
//     );
//   }

//   String _formatOption(String opt) {
//     switch (opt) {
//       case 'opcaoA':
//         return 'Opção A';
//       case 'opcaoB':
//         return 'Opção B';
//       default:
//         return 'Desconhecida';
//     }
//   }
// }



// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//   child: SizedBox(
//     width: double.infinity,
//     child: ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const ControlsPage()),
//         );
//       },
//       child: const Text('Abrir controles (Slider + Radio)'),
//     ),
//   ),
// ),
// const SizedBox(height: 12),











