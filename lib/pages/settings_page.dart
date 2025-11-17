import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/theme_provider.dart'; // ← IMPORT CORRIGIDO

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Você saiu da conta'),
                  backgroundColor: Colors.red,
                ),
              );
              // Navega para login
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushReplacementNamed(context, '/login');
              });
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // TEMA ESCURO FUNCIONAL PARA TODO O APP
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color:
                      themeProvider.isDarkMode ? Colors.blue[200] : Colors.blue,
                ),
                title: const Text('Tema Escuro'),
                subtitle: Text(
                  themeProvider.isDarkMode ? 'Ativado' : 'Desativado',
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                  ),
                ),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    // Altera o tema de TODO O APP
                    themeProvider.toggleTheme(value);

                    // Mostra mensagem de sucesso
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? 'Tema escuro ativado 🌙'
                              : 'Tema claro ativado ☀️',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: value ? Colors.grey[800] : Colors.blue,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  activeColor: Colors.blue,
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
                  color: themeProvider.isDarkMode
                      ? Colors.green[200]
                      : Colors.green,
                ),
                title: const Text('AdotePet'),
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
                  color: themeProvider.isDarkMode
                      ? Colors.orange[200]
                      : Colors.orange,
                ),
                title: const Text('Ajuda e Suporte'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Abrindo ajuda e suporte...'),
                      backgroundColor: themeProvider.isDarkMode
                          ? Colors.orange[800]
                          : Colors.orange,
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
                  color: themeProvider.isDarkMode
                      ? Colors.purple[200]
                      : Colors.purple,
                ),
                title: const Text('Política de Privacidade'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Abrindo política de privacidade...'),
                      backgroundColor: themeProvider.isDarkMode
                          ? Colors.purple[800]
                          : Colors.purple,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // BOTÃO SAIR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Sair da Conta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
