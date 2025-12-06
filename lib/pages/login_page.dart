import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/auth_provider.dart';
import 'package:app_projetoyuri/utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            // APENAS ISSO RESOLVE: SingleChildScrollView
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      // IMPORTANTE: mainAxisSize.min
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        SizedBox(
                          height: 80,
                          child: Image.asset(
                            'assets/images/logoAdotaJa.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'AdojaJá',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // E-mail
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            labelStyle: TextStyle(color: theme.primaryColor),
                            border: const OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.email, color: theme.primaryColor),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 16),

                        // Senha
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: TextStyle(color: theme.primaryColor),
                            border: const OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.lock, color: theme.primaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: theme.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A senha é obrigatória';
                            }
                            if (value.length < 6) {
                              return 'Senha deve ter pelo menos 6 caracteres';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 24),

                        // Botão de login
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: authProvider.loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: theme.primaryColor))
                              : ElevatedButton(
                                  onPressed: () =>
                                      _login(context, authProvider),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primaryColor,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),

                        // Mensagem de erro
                        if (authProvider.error.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              authProvider.error,
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        // Cadastre-se
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Cadastro em desenvolvimento'),
                                backgroundColor: theme.primaryColor,
                              ),
                            );
                          },
                          child: Text(
                            'Não tem conta? Cadastre-se',
                            style: TextStyle(color: theme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _login(BuildContext context, AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login realizado com sucesso!'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
