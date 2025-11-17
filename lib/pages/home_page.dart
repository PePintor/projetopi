import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/pages/add_pet_page.dart';
import 'package:app_projetoyuri/pages/my_pets_page.dart';
import 'package:app_projetoyuri/pages/profile_page.dart';
import 'package:app_projetoyuri/pages/settings_page.dart';
import 'package:app_projetoyuri/pages/pet_detail_page.dart';
import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/providers/pet_provider.dart';
import 'package:app_projetoyuri/utils/constants.dart'; // ✅ AGORA SERÁ UTILIZADO

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PetProvider>().addListener(_onPetsChanged);
      }
    });
  }

  @override
  void dispose() {
    if (mounted) {
      context.read<PetProvider>().removeListener(_onPetsChanged);
    }
    super.dispose();
  }

  void _onPetsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _navigateToAddPet();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _navigateToAddPet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPetPage()),
    );

    if (result == true && context.mounted) {
      print('🔄 FORÇANDO ATUALIZAÇÃO DA HOME...');
      setState(() {
        _selectedIndex = 0;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (context.mounted) {
        setState(() {});
      }
    }
  }

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _HomeContent();
      case 1:
        return const MyPetsPage();
      case 3:
        return const ProfilePage();
      case 4:
        return const SettingsPage();
      default:
        return _HomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName), // ✅ CONSTANTE UTILIZADA
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Meus Pets'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: 'Adicionar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        print('🏠 HOME CONTENT - Total pets: ${petProvider.pets.length}');
        print('🐾 Pets: ${petProvider.pets.map((p) => p.name).toList()}');

        // ✅ FILTRA OS PETS BASEADO NA PESQUISA
        final displayedPets = _searchQuery.isEmpty
            ? petProvider.pets
            : petProvider.searchPets(_searchQuery);

        if (petProvider.loading && petProvider.pets.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando pets...'),
              ],
            ),
          );
        }

        if (petProvider.error.isNotEmpty && petProvider.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Erro ao carregar pets',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                SizedBox(height: 8),
                Text(
                  petProvider.error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => petProvider.loadPets(),
                  child: Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // ✅ BARRA DE PESQUISA AVANÇADA
            Padding(
              padding: const EdgeInsets.all(
                  AppConstants.defaultPadding), // ✅ CONSTANTE
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '🔍 Pesquisar pets...',
                      helperText:
                          'Busque por nome, raça, espécie, localização, idade ou descrição',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            AppConstants.defaultBorderRadius), // ✅ CONSTANTE
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ✅ SUGESTÕES DE PESQUISA RÁPIDA
                  if (_searchQuery.isEmpty)
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildQuickFilter('🐕 Cachorro', 'cachorro'),
                        _buildQuickFilter('🐈 Gato', 'gato'),
                        _buildQuickFilter('🐹 Hamster', 'hamster'),
                        _buildQuickFilter('🐦 Calopsita', 'calopsita'),
                        _buildQuickFilter('💉 Vacinados', 'vacinado'),
                        _buildQuickFilter('🔍 Ver todos', ''),
                      ],
                    ),
                ],
              ),
            ),

            // ✅ MOSTRA RESULTADOS DA PESQUISA
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding), // ✅ CONSTANTE
                child: Row(
                  children: [
                    Text(
                      '${displayedPets.length} pets encontrados',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: AppConstants.captionFontSize, // ✅ CONSTANTE
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_searchQuery.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(AppConstants
                                .defaultBorderRadius), // ✅ CONSTANTE
                          ),
                          child: Row(
                            children: [
                              Text(
                                '"$_searchQuery"',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.close, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () => petProvider.loadPets(),
                child: displayedPets.isEmpty
                    ? _buildEmptyState(_searchQuery)
                    : ListView.builder(
                        itemCount: displayedPets.length,
                        itemBuilder: (context, index) {
                          final pet = displayedPets[index];
                          return _PetCard(pet: pet);
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ✅ BOTÕES DE PESQUISA RÁPIDA
  Widget _buildQuickFilter(String label, String query) {
    return GestureDetector(
      onTap: () {
        _searchController.text = query;
        setState(() {
          _searchQuery = query;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue[100]!),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ✅ ESTADO VAZIO MELHORADO
  Widget _buildEmptyState(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            query.isEmpty
                ? AppConstants.noPetsFound
                : 'Nenhum pet encontrado', // ✅ CONSTANTE
            style: TextStyle(
                fontSize: AppConstants.subheadingFontSize,
                color: Colors.grey[600]), // ✅ CONSTANTE
          ),
          const SizedBox(height: 8),
          Text(
            query.isEmpty
                ? 'Clique em + para adicionar um pet'
                : 'Tente buscar por outro termo',
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: AppConstants.captionFontSize), // ✅ CONSTANTE
          ),
          if (query.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildQuickFilter('🐕 Cachorro', 'cachorro'),
                _buildQuickFilter('🐈 Gato', 'gato'),
                _buildQuickFilter('🐹 Hamster', 'hamster'),
                _buildQuickFilter('💉 Vacinados', 'vacinado'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Pet pet;

  const _PetCard({required this.pet});

  void _navigateToPetDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetDetailPage(pet: pet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding, vertical: 8), // ✅ CONSTANTE
      elevation: AppConstants.cardElevation, // ✅ CONSTANTE
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              AppConstants.defaultBorderRadius)), // ✅ CONSTANTE
      child: InkWell(
        onTap: () => _navigateToPetDetail(context),
        borderRadius: BorderRadius.circular(
            AppConstants.defaultBorderRadius), // ✅ CONSTANTE
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(
                      AppConstants.defaultBorderRadius)), // ✅ CONSTANTE
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: pet.photos.isNotEmpty
                    ? Image.network(
                        pet.photos.first,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      )
                    : _buildPlaceholderImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                  AppConstants.defaultPadding), // ✅ CONSTANTE
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${pet.species} • ${pet.breed}',
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(pet.location,
                              style: TextStyle(color: Colors.grey[600]))),
                      Icon(Icons.cake, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(pet.age,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  // ✅ MOSTRA STATUS DE VACINA (campo que existe)
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        pet.vaccinated
                            ? Icons.medical_services
                            : Icons.medical_services_outlined,
                        size: 16,
                        color: pet.vaccinated ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pet.vaccinated ? 'Vacinado' : 'Não vacinado',
                        style: TextStyle(
                          fontSize: AppConstants.smallFontSize, // ✅ CONSTANTE
                          color:
                              pet.vaccinated ? Colors.green : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pets, size: 50, color: Colors.grey),
        SizedBox(height: 8),
        Text('Sem foto', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
