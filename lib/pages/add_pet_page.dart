import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/pet_provider.dart';
import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/utils/image_picker.dart';
import 'package:app_projetoyuri/utils/validators.dart';
import 'package:app_projetoyuri/utils/constants.dart';

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

    setState(() {
      _imageLoading = true;
    });

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
      setState(() {
        _imageLoading = false;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
      const SnackBar(
        content: Text('Pet cadastrado com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
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

    setState(() {
      _loading = true;
    });

    try {
      // ✅ CORREÇÃO: Use array vazio para fotos
      final pet = Pet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        species: _speciesController.text,
        breed: _breedController.text,
        age: _ageController.text,
        description: _descriptionController.text,
        careInstructions: _careController.text,
        photos: [], // ✅ ARRAY VAZIO EM VEZ DE base64_placeholder
        vaccinated: _vaccinated,
        location: _locationController.text,
        contact: _contactController.text,
        userId: 'user1',
        createdAt: DateTime.now(),
      );

      print('📝 ENVIANDO PET: ${pet.name}');
      print('👤 USER ID: ${pet.userId}');

      final success = await context.read<PetProvider>().addPet(pet);

      print('✅ RESULTADO DO CADASTRO: $success');

      if (success) {
        _showSuccess();
        _resetForm();
        Navigator.of(context).pop(true);
      } else {
        _showError(
            'Erro ao cadastrar pet: ${context.read<PetProvider>().error}');
      }
    } catch (e) {
      print('❌ ERRO NO SUBMIT: $e');
      _showError('Erro inesperado: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _resetForm() {
    _nameController.clear();
    _speciesController.clear();
    _breedController.clear();
    _ageController.clear();
    _descriptionController.clear();
    _careController.clear();
    _locationController.clear();
    _contactController.clear();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Pet'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _resetForm,
            tooltip: 'Limpar formulário',
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cadastrando pet...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPhotosSection(),
                    const SizedBox(height: 24),
                    _buildBasicInfoSection(),
                    const SizedBox(height: 24),
                    _buildCareSection(),
                    const SizedBox(height: 24),
                    _buildContactSection(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fotos do Pet*',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Adicione até 5 fotos (mínimo 1)',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 12),
        if (_imageLoading)
          const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Carregando imagens...'),
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
              childAspectRatio: 1,
            ),
            itemCount: _selectedImages.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddPhotoButton();
              } else {
                return _buildPhotoPreview(index - 1);
              }
            },
          ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _imageLoading ? null : _pickImages,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _imageLoading ? Colors.grey : Colors.blue),
          borderRadius: BorderRadius.circular(8),
          color: _imageLoading ? Colors.grey[100] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo,
                size: 30, color: _imageLoading ? Colors.grey : Colors.blue),
            const SizedBox(height: 4),
            Text(
              _imageLoading ? 'Carregando...' : 'Adicionar',
              style: TextStyle(
                  fontSize: 12,
                  color: _imageLoading ? Colors.grey : Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo, size: 30, color: Colors.blue),
                SizedBox(height: 4),
                Text('Foto',
                    style: TextStyle(fontSize: 10, color: Colors.blue)),
              ],
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

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informações Básicas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nameController,
          label: 'Nome do Pet*',
          hint: 'Ex: Rex, Luna, Thor',
          icon: Icons.pets,
          validator: (value) =>
              Validators.requiredField(value, fieldName: 'Nome do pet'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _speciesController,
                label: 'Espécie*',
                hint: 'Ex: Cachorro, Gato',
                icon: Icons.category,
                validator: (value) =>
                    Validators.requiredField(value, fieldName: 'Espécie'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _breedController,
                label: 'Raça*',
                hint: 'Ex: Labrador, Siamês',
                icon: Icons.emoji_nature,
                validator: (value) =>
                    Validators.requiredField(value, fieldName: 'Raça'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _ageController,
          label: 'Idade*',
          hint: 'Ex: 2 anos, 6 meses',
          icon: Icons.cake,
          validator: Validators.validateAge,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _descriptionController,
          label: 'Descrição*',
          hint: 'Conte um pouco sobre o pet...',
          icon: Icons.description,
          maxLines: 3,
          validator: Validators.validateDescription,
        ),
      ],
    );
  }

  Widget _buildCareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cuidados e Saúde',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: _vaccinated,
              onChanged: (value) {
                setState(() {
                  _vaccinated = value ?? false;
                });
              },
            ),
            const Text('Pet vacinado'),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _careController,
          label: 'Cuidados Especiais',
          hint: 'Alimentação, medicamentos, comportamento...',
          icon: Icons.medical_services,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Localização e Contato',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _locationController,
          label: 'Localização*',
          hint: 'Ex: São Paulo, Centro',
          icon: Icons.location_on,
          validator: Validators.validateLocation,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _contactController,
          label: 'Contato*',
          hint: 'Telefone ou email para contato',
          icon: Icons.phone,
          validator: Validators.validateContact,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _loading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'CADASTRAR PET',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
