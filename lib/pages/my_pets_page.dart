import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/providers/pet_provider.dart';
import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/pages/pet_detail_page.dart';
import 'package:app_projetoyuri/utils/constants.dart';
import 'package:app_projetoyuri/pages/add_pet_page.dart';
import 'package:app_projetoyuri/pages/edit_pet_page.dart'; // ✅ IMPORT ADICIONADO

// ✅ MUDE para StatefulWidget
class MyPetsPage extends StatefulWidget {
  const MyPetsPage({super.key});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  // ✅ ADICIONE: Recarrega os pets quando a página abre
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print('🔄 INICIANDO MEUS PETS - Carregando dados...');
        context.read<PetProvider>().loadMyPets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pets'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          print('🏠 MY PETS PAGE - Total: ${petProvider.myPets.length}');

          if (petProvider.loading && petProvider.myPets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando meus pets...'),
                ],
              ),
            );
          }

          if (petProvider.myPets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Você ainda não cadastrou nenhum pet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Clique no botão + para adicionar seu primeiro pet',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPetPage(),
                        ),
                      );
                    },
                    child: const Text('Cadastrar Primeiro Pet'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            // ✅ RECARREGA quando puxar para baixo
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

class _MyPetCard extends StatelessWidget {
  final Pet pet;

  const _MyPetCard({required this.pet});

  void _navigateToPetDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetDetailPage(pet: pet),
      ),
    );
  }

  // ✅ ATUALIZADO: Navegar para edição
  void _navigateToEditPet(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPetPage(pet: pet), // ✅ AGORA FUNCIONA!
      ),
    );

    // Se a edição foi bem sucedida, recarrega os dados
    if (result == true && context.mounted) {
      context.read<PetProvider>().loadMyPets();
    }
  }

  // ✅ ATUALIZADO: Diálogo de deletar
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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

  // ✅ ATUALIZADO: Deletar pet
  Future<void> _deletePet(BuildContext context) async {
    final petProvider = context.read<PetProvider>();

    try {
      final success = await petProvider.removePet(pet.id);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pet.name} removido com sucesso!'),
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
    return Card(
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
              // Foto do pet
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  image: pet.photos.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(pet.photos.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: pet.photos.isEmpty
                    ? const Icon(Icons.pets, size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),

              // Informações do pet
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.species} • ${pet.breed}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.age,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.location,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Botões de ação
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToEditPet(context); // ✅ AGORA FUNCIONA!
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
}
