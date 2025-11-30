import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: secondaryColor,
                ),
                title: const Text('Tema Escuro'),
                subtitle: Text(
                  themeProvider.isDarkMode ? 'Ativado' : 'Desativado',
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        // ignore: deprecated_member_use
                        ?.withOpacity(0.7),
                  ),
                ),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? 'Tema escuro ativado'
                              : 'Tema claro ativado',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: primaryColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  activeThumbColor: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // SOBRE O APP
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  Icons.info,
                  color: secondaryColor,
                ),
                title: const Text('AdotaJá'),
                subtitle: const Text('Versão 1.0.0'),
              ),
            ),
            const SizedBox(height: 20),

            // AJUDA E SUPORTE
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  Icons.help,
                  color: secondaryColor,
                ),
                title: const Text('Ajuda e Suporte'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Abrindo ajuda e suporte...'),
                      backgroundColor: secondaryColor,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // POLÍTICA DE PRIVACIDADE
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  Icons.security,
                  color: secondaryColor,
                ),
                title: const Text('Política de Privacidade'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Abrindo política de privacidade...'),
                      backgroundColor: secondaryColor,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
