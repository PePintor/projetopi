import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_projetoyuri/pages/add_pet_page.dart';
import 'package:app_projetoyuri/pages/my_pets_page.dart';
import 'package:app_projetoyuri/pages/profile_page.dart';
import 'package:app_projetoyuri/pages/settings_page.dart';
import 'package:app_projetoyuri/pages/pet_detail_page.dart';
import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/providers/pet_provider.dart';
import 'package:app_projetoyuri/utils/constants.dart';

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
    if (mounted) setState(() {});
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
      setState(() {
        _selectedIndex = 0;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (context.mounted) setState(() {});
    }
  }

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return const _HomeContent();
      case 1:
        return const MyPetsPage();
      case 3:
        return const ProfilePage();
      case 4:
        return const SettingsPage();
      default:
        return const _HomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        title: Row(
          children: [
            Image.asset(
              "assets/images/logoAdotaJa.png",
              height: 32,
            ),
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.appBarTheme.foregroundColor,
              ),
            ),
          ],
        ),
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.bottomAppBarColor,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.unselectedWidgetColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Meus Pets'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Adicionar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
    );
  }
}

extension on ThemeData {
  Color? get bottomAppBarColor => null;
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
    final theme = Theme.of(context);

    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        final displayedPets = _searchQuery.isEmpty
            ? petProvider.pets
            : petProvider.searchPets(_searchQuery);

        if (petProvider.loading && petProvider.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: theme.primaryColor),
                const SizedBox(height: 16),
                const Text('Carregando pets...'),
              ],
            ),
          );
        }

        if (petProvider.error.isNotEmpty && petProvider.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: theme.primaryColor),
                const SizedBox(height: 16),
                Text(
                  'Erro ao carregar pets',
                  style: TextStyle(fontSize: 18, color: theme.primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  petProvider.error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () => petProvider.loadPets(),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: '🔍 Pesquisar pets...',
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: theme.primaryColor),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                child: Row(
                  children: [
                    Text(
                      '${displayedPets.length} pets encontrados',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: AppConstants.captionFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                color: theme.primaryColor,
                onRefresh: () => petProvider.loadPets(),
                child: displayedPets.isEmpty
                    ? _buildEmptyState(theme)
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

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? AppConstants.noPetsFound : 'Nenhum pet encontrado',
            style: TextStyle(fontSize: AppConstants.subheadingFontSize, color: theme.textTheme.bodyMedium?.color),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty ? 'Clique em + para adicionar um pet' : 'Tente buscar por outro termo',
            style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: AppConstants.captionFontSize),
          ),
        ],
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Pet pet;
  const _PetCard({required this.pet});

  void _navigateToPetDetail(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PetDetailPage(pet: pet)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding, vertical: 8),
      elevation: AppConstants.cardElevation,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius)),
      child: InkWell(
        onTap: () => _navigateToPetDetail(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.defaultBorderRadius)),
              child: Container(
                height: 200,
                color: theme.cardColor,
                child: pet.photos.isNotEmpty
                    ? Image.network(
                        pet.photos.first,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : _buildPlaceholderImage(theme),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColor)),
                  const SizedBox(height: 8),
                  Text('${pet.species} • ${pet.breed}', style: TextStyle(color: theme.textTheme.bodySmall?.color)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: theme.disabledColor),
                      const SizedBox(width: 4),
                      Expanded(child: Text(pet.location, style: TextStyle(color: theme.disabledColor))),
                      Icon(Icons.cake, size: 18, color: theme.disabledColor),
                      const SizedBox(width: 4),
                      Text(pet.age, style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        pet.vaccinated ? Icons.medical_services : Icons.medical_services_outlined,
                        size: 16,
                        color: pet.vaccinated ? Colors.green : theme.disabledColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pet.vaccinated ? 'Vacinado' : 'Não vacinado',
                        style: TextStyle(
                          fontSize: AppConstants.smallFontSize,
                          color: pet.vaccinated ? Colors.green : theme.disabledColor,
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

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pets, size: 50, color: theme.disabledColor),
        const SizedBox(height: 8),
        Text('Sem foto', style: TextStyle(color: theme.disabledColor)),
      ],
    );
  }
}
