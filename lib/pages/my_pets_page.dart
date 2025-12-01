import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/pet_provider.dart';
import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/pages/pet_detail_page.dart';
import 'package:app_projetoyuri/pages/add_pet_page.dart';
import 'package:app_projetoyuri/pages/edit_pet_page.dart';
import 'package:app_projetoyuri/utils/constants.dart';
import 'dart:convert'; // 

class MyPetsPage extends StatefulWidget {
  const MyPetsPage({super.key});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PetProvider>().loadMyPets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Meus Pets'),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          if (petProvider.loading && petProvider.myPets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.primaryColor),
                  const SizedBox(height: 16),
                  const Text('Carregando meus pets...'),
                ],
              ),
            );
          }

          if (petProvider.myPets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 64, color: Colors.grey[500]),
                  const SizedBox(height: 16),
                  Text(
                    'Você ainda não cadastrou nenhum pet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Clique no botão + para adicionar seu primeiro pet',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPetPage()),
                      );
                    },
                    child: const Text('Cadastrar Primeiro Pet'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: theme.primaryColor,
            onRefresh: () => petProvider.loadMyPets(),
            child: ListView.builder(
              itemCount: petProvider.myPets.length,
              itemBuilder: (context, index) {
                final pet = petProvider.myPets[index];
                return _MyPetCard(pet: pet);
              },
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------
// CARD DOS PETS
// -------------------------------------------------------
class _MyPetCard extends StatelessWidget {
  final Pet pet;
  const _MyPetCard({required this.pet});

  void _navigateToPetDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetDetailPage(pet: pet)),
    );
  }

  void _navigateToEditPet(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPetPage(pet: pet)),
    );

    if (result == true && context.mounted) {
      context.read<PetProvider>().loadMyPets();
    }
  }

  void _showDeleteDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: const Text('Remover Pet'),
          content: Text('Tem certeza que deseja remover ${pet.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deletePet(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePet(BuildContext context) async {
    final petProvider = context.read<PetProvider>();
    try {
      final success = await petProvider.removePet(pet.id);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet removido com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao remover pet: ${petProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao remover pet: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: () => _navigateToPetDetail(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Foto
              // Foto
Container(
  width: 80,
  height: 80,
  decoration: BoxDecoration(
    color: theme.primaryColor.withOpacity(0.3),
    borderRadius: BorderRadius.circular(12),
    image: pet.photos.isNotEmpty
        ? DecorationImage(
            image: NetworkImage(pet.photos.first), // ← PROBLEMA
            fit: BoxFit.cover,
          )
        : null,
  ),
  child: pet.photos.isEmpty
      ? Icon(Icons.pets, size: 40, color: Colors.grey[600])
      : null,
),
              // Informações
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${pet.species} • ${pet.breed}',
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 4),
                    Text(pet.age,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 4),
                    Text(pet.location,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),

              // Menu
             // ... código anterior ...

              // Menu
              PopupMenuButton<String>(
                color: theme.scaffoldBackgroundColor,
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToEditPet(context);
                  } else if (value == 'delete') {
                    _showDeleteDialog(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Remover', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  NOVO MÉTODO: Processa imagens Base64 ou URL - DENTRO DA CLASSE!
  Widget _buildPetImage(String imageData, ThemeData theme) {
    try {
      if (imageData.startsWith('data:image')) {
        // É Base64 - converter para bytes
        final base64String = imageData.split(',').last;
        final bytes = base64Decode(base64String);
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            bytes,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        );
      } else {
        // É URL normal
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageData,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.pets, size: 40, color: Colors.grey[600]);
            },
          ),
        );
      }
    } catch (e) {
      return Icon(Icons.pets, size: 40, color: Colors.grey[600]);
    }
  }
} // ← FIM DA CLASSE _MyPetCard