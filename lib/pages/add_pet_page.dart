
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/pet_provider.dart';
import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/utils/image_picker.dart';
import 'package:app_projetoyuri/utils/validators.dart';
import 'package:app_projetoyuri/utils/constants.dart';
import 'dart:typed_data';
import 'dart:convert';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _careController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  List<Uint8List> _selectedImages = [];
  bool _vaccinated = false;
  bool _loading = false;
  bool _imageLoading = false;

  Future<void> _pickImages() async {
    if (_imageLoading) return;

    setState(() => _imageLoading = true);

    try {
      final images = await ImagePickerUtils.pickMultipleImages();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
          if (_selectedImages.length > AppConstants.maxImages) {
            _selectedImages =
                _selectedImages.sublist(0, AppConstants.maxImages);
            _showMessage('Máximo ${AppConstants.maxImages} fotos permitidas');
          }
        });
      }
    } catch (e) {
      _showError('Erro ao selecionar imagens: $e');
    } finally {
      setState(() => _imageLoading = false);
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: const Text(
          'Pet cadastrado com sucesso!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      final imageError = Validators.validateImages(_selectedImages);
      if (imageError != null) {
        _showError(imageError);
        return false;
      }
      return true;
    }
    return false;
  }

 void _submitForm() async {
  if (!_validateForm()) return;

  setState(() => _loading = true);

  try {

final List<String> photoUrls = _selectedImages.map((imageBytes) {
  final base64String = base64Encode(imageBytes);
  return 'data:image/jpeg;base64,$base64String';
}).toList();
   
    final pet = Pet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      species: _speciesController.text,
      breed: _breedController.text,
      age: _ageController.text,
      description: _descriptionController.text,
      careInstructions: _careController.text,
      photos: photoUrls, // ← AGORA COM URLs FICTÍCIAS!
      vaccinated: _vaccinated,
      location: _locationController.text,
      contact: _contactController.text,
      userId: 'user1',
      createdAt: DateTime.now(),
    );

    final success = await context.read<PetProvider>().addPet(pet);

    if (success) {
      _showSuccess();
      Navigator.of(context).pop(true);
    } else {
      _showError('Erro ao cadastrar pet: ${context.read<PetProvider>().error}');
    }
  } catch (e) {
    _showError('Erro inesperado: $e');
  } finally {
    setState(() => _loading = false);
  }
}
  void _resetForm() {
   
    if (!mounted) return;

    try {
      _nameController.clear();
      _speciesController.clear();
      _breedController.clear();
      _ageController.clear();
      _descriptionController.clear();
      _careController.clear();
      _locationController.clear();
      _contactController.clear();
    } catch (e) {
      // Ignora erros de controllers
    }

    setState(() {
      _selectedImages = [];
      _vaccinated = false;
    });
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Cadastrar Pet'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _loading ? null : _resetForm, 
            tooltip: 'Limpar formulário',
            color: theme.appBarTheme.foregroundColor,
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.primaryColor),
                  const SizedBox(height: 16),
                  const Text('Cadastrando pet...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPhotosSection(theme),
                    const SizedBox(height: 24),
                    _buildBasicInfoSection(theme),
                    const SizedBox(height: 24),
                    _buildCareSection(theme),
                    const SizedBox(height: 24),
                    _buildContactSection(theme),
                    const SizedBox(height: 32),
                    _buildSubmitButton(theme),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPhotosSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotos do Pet*',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Adicione até 5 fotos (mínimo 1)',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 12),
        if (_imageLoading)
          Center(
            child: Column(
              children: [
                CircularProgressIndicator(color: theme.primaryColor),
                const SizedBox(height: 8),
                const Text('Carregando imagens...'),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _selectedImages.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildAddPhotoButton(theme);
              return _buildPhotoPreview(index - 1, theme);
            },
          ),
      ],
    );
  }

  Widget _buildAddPhotoButton(ThemeData theme) {
    return GestureDetector(
      onTap: _imageLoading ? null : _pickImages,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _imageLoading ? Colors.grey : theme.primaryColor,
          ),
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo, size: 30, color: theme.primaryColor),
              const SizedBox(height: 4),
              Text(
                'Adicionar',
                style: TextStyle(fontSize: 12, color: theme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPreview(int index, ThemeData theme) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: MemoryImage(_selectedImages[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações Básicas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          _nameController,
          'Nome do Pet*',
          'Ex: Rex, Luna, Thor',
          Icons.pets,
          theme,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                _speciesController,
                'Espécie*',
                'Ex: Cachorro, Gato',
                Icons.category,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                _breedController,
                'Raça*',
                'Ex: Labrador, Siamês',
                Icons.emoji_nature,
                theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _ageController,
          'Idade*',
          'Ex: 2 anos, 6 meses',
          Icons.cake,
          theme,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _descriptionController,
          'Descrição*',
          'Conte um pouco sobre o pet...',
          Icons.description,
          theme,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildCareSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuidados e Saúde',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: _vaccinated,
              activeColor: theme.primaryColor,
              onChanged: (value) => setState(() => _vaccinated = value ?? false),
            ),
            const Text('Pet vacinado'),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _careController,
          'Cuidados Especiais',
          'Alimentação, medicamentos, comportamento...',
          Icons.medical_services,
          theme,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Localização e Contato',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          _locationController,
          'Localização*',
          'Ex: São Paulo, Centro',
          Icons.location_on,
          theme,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _contactController,
          'Contato*',
          'Telefone ou email para contato',
          Icons.phone,
          theme,
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon,
    ThemeData theme, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) => Validators.requiredField(value, fieldName: label),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: theme.colorScheme.secondary),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _loading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'CADASTRAR PET',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}