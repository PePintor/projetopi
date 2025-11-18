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

  void _toggleEdit() => setState(() => _isEditing = !_isEditing);

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _loadUserData();
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
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Perfil atualizado com sucesso!'),
              backgroundColor: Theme.of(context).primaryColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: ${authProvider.error}'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

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
    final theme = Theme.of(context);

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

        if (user == null) return _buildUserNotFound(theme);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Meu Perfil'),
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.colorScheme.onPrimary,
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
                  _buildProfileHeader(user, theme),
                  const SizedBox(height: 20),
                  if (!_isEditing) _buildStatsCard(theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserNotFound(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Usuário não encontrado'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Fazer Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(user, ThemeData theme) {
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.brown.shade700;

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            if (!_isEditing) ...[
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(user.email,
                  style: TextStyle(color: textColor.withOpacity(0.7))),
              if (user.location != null) ...[
                const SizedBox(height: 4),
                Text(user.location!,
                    style: TextStyle(color: textColor.withOpacity(0.7))),
              ],
              if (user.bio != null && user.bio!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontStyle: FontStyle.italic),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _toggleEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Editar Perfil'),
              ),
            ],
            if (_isEditing) ...[
              _buildEditForm(theme),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancelEdit,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textColor,
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(ThemeData theme) {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Nome Completo*',
          hint: 'Digite seu nome',
          icon: Icons.person,
          validator: (value) =>
              Validators.validateName(value, fieldName: 'Nome'),
          theme: theme,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _emailController,
          label: 'E-mail',
          hint: 'Digite seu e-mail',
          icon: Icons.email,
          enabled: false,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _phoneController,
          label: 'Telefone',
          hint: '(11) 99999-9999',
          icon: Icons.phone,
          validator: Validators.validatePhone,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _locationController,
          label: 'Localização',
          hint: 'Cidade, Estado',
          icon: Icons.location_on,
          validator: Validators.validateLocation,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _bioController,
          label: 'Bio',
          hint: 'Conte um pouco sobre você...',
          icon: Icons.description,
          maxLines: 3,
          validator: Validators.validateBio,
          theme: theme,
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
    required ThemeData theme,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: theme.primaryColor),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
      ),
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
    );
  }

  Widget _buildStatsCard(ThemeData theme) {
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.brown.shade700;

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Minhas Estatísticas',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            _StatItem(icon: Icons.pets, label: 'Pets Cadastrados', value: '3', theme: theme),
            _StatItem(icon: Icons.favorite, label: 'Pets Adotados', value: '1', theme: theme),
            _StatItem(icon: Icons.thumb_up, label: 'Avaliações', value: '4.8', theme: theme),
            _StatItem(icon: Icons.calendar_today, label: 'Membro desde', value: 'Jan 2024', theme: theme),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.brown.shade700;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(color: textColor))),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}
