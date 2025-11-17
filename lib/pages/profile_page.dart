import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/auth_provider.dart';
import 'package:app_projetoyuri/utils/validators.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
      _locationController.text = user.location ?? '';
      _bioController.text = user.bio ?? '';
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _loadUserData(); // Recarrega dados originais ao cancelar
      }
    });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final currentUser = authProvider.currentUser;

      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          bio: _bioController.text.trim().isEmpty
              ? null
              : _bioController.text.trim(),
          updatedAt: DateTime.now(),
        );

        final success = await authProvider.updateProfile(updatedUser);

        if (success && mounted) {
          setState(() {
            _isEditing = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: ${authProvider.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _loadUserData(); // Volta aos dados originais
    });
  }

  // ❌ MÉTODO _showLogoutDialog REMOVIDO

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        if (authProvider.loading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando perfil...'),
              ],
            ),
          );
        }

        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Usuário não encontrado'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Fazer Login'),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu Perfil'),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            actions: [
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _toggleEdit,
                  tooltip: 'Editar Perfil',
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Foto e informações do usuário
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.purple,
                            child: Icon(Icons.person,
                                size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 16),

                          if (!_isEditing) ...[
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            if (user.location != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                user.location!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                            if (user.bio != null && user.bio!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                user.bio!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 16),
                          ],

                          // Botões de ação
                          if (_isEditing) ...[
                            _buildEditForm(),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _cancelEdit,
                                    child: const Text('Cancelar'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Salvar'),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            ElevatedButton(
                              onPressed: _toggleEdit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Editar Perfil'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Estatísticas (só mostra quando não está editando)
                  if (!_isEditing) ...[
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Minhas Estatísticas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            _StatItem(
                                icon: Icons.pets,
                                label: 'Pets Cadastrados',
                                value: '3'),
                            _StatItem(
                                icon: Icons.favorite,
                                label: 'Pets Adotados',
                                value: '1'),
                            _StatItem(
                                icon: Icons.thumb_up,
                                label: 'Avaliações',
                                value: '4.8'),
                            _StatItem(
                                icon: Icons.calendar_today,
                                label: 'Membro desde',
                                value: 'Jan 2024'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ❌ BOTÃO "SAIR DA CONTA" REMOVIDO AQUI
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Nome Completo*',
          hint: 'Digite seu nome',
          icon: Icons.person,
          validator: (value) =>
              Validators.validateName(value, fieldName: 'Nome'),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _emailController,
          label: 'E-mail',
          hint: 'Digite seu e-mail',
          icon: Icons.email,
          enabled: false, // Email não pode ser editado
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _phoneController,
          label: 'Telefone',
          hint: '(11) 99999-9999',
          icon: Icons.phone,
          validator: Validators.validatePhone,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _locationController,
          label: 'Localização',
          hint: 'Cidade, Estado',
          icon: Icons.location_on,
          validator: Validators.validateLocation,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _bioController,
          label: 'Bio',
          hint: 'Conte um pouco sobre você...',
          icon: Icons.description,
          maxLines: 3,
          validator: Validators.validateBio,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
