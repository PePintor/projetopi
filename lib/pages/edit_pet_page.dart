import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/pet_provider.dart';
import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/utils/validators.dart';

class EditPetPage extends StatefulWidget {
  final Pet pet;

  const EditPetPage({super.key, required this.pet});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _careController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  bool _vaccinated = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.pet.name;
    _speciesController.text = widget.pet.species;
    _breedController.text = widget.pet.breed;
    _ageController.text = widget.pet.age;
    _descriptionController.text = widget.pet.description;
    _careController.text = widget.pet.careInstructions;
    _locationController.text = widget.pet.location;
    _contactController.text = widget.pet.contact;
    _vaccinated = widget.pet.vaccinated;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _careController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pet atualizado com sucesso!'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro: $error'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _showError('Por favor, corrija os erros no formulário');
      return;
    }

    setState(() => _loading = true);

    try {
      final updatedPet = widget.pet.copyWith(
        name: _nameController.text,
        species: _speciesController.text,
        breed: _breedController.text,
        age: _ageController.text,
        description: _descriptionController.text,
        careInstructions: _careController.text,
        location: _locationController.text,
        contact: _contactController.text,
        vaccinated: _vaccinated,
        updatedAt: DateTime.now(),
      );

      final success = await context.read<PetProvider>().updatePet(updatedPet);

      if (success && mounted) {
        _showSuccess();
        Navigator.of(context).pop(true);
      } else {
        _showError('Falha ao atualizar pet');
      }
    } catch (e) {
      _showError('$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Editar Pet'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _loading ? null : _submitForm,
            tooltip: 'Salvar alterações',
            color: theme.appBarTheme.foregroundColor,
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nome do Pet*',
                      icon: Icons.pets,
                      validator: (value) =>
                          Validators.validateName(value, fieldName: 'Nome do pet'),
                      theme: theme,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _speciesController,
                            label: 'Espécie*',
                            icon: Icons.category,
                            validator: Validators.validateSpecies,
                            theme: theme,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _breedController,
                            label: 'Raça*',
                            icon: Icons.emoji_nature,
                            validator: (value) =>
                                Validators.validateBreed(value, _speciesController.text),
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _ageController,
                      label: 'Idade*',
                      icon: Icons.cake,
                      validator: Validators.validateAge,
                      theme: theme,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Descrição*',
                      icon: Icons.description,
                      maxLines: 3,
                      validator: Validators.validateDescription,
                      theme: theme,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _careController,
                      label: 'Cuidados Especiais',
                      hint: 'Alimentação, medicamentos, comportamento...',
                      icon: Icons.medical_services,
                      maxLines: 3,
                      theme: theme,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _vaccinated,
                          onChanged: (value) {
                            setState(() {
                              _vaccinated = value ?? false;
                            });
                          },
                          fillColor: WidgetStateProperty.all(theme.colorScheme.secondary),
                        ),
                        const Text('Pet vacinado'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _locationController,
                      label: 'Localização*',
                      hint: 'Ex: São Paulo, Centro',
                      icon: Icons.location_on,
                      validator: Validators.validateLocation,
                      theme: theme,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _contactController,
                      label: 'Contato*',
                      hint: 'Telefone ou email para contato',
                      icon: Icons.phone,
                      validator: Validators.validateContact,
                      theme: theme,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: const Text('SALVAR ALTERAÇÕES'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    required ThemeData theme,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: theme.colorScheme.secondary),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
