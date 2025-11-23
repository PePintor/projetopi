// 📱 ARQUIVO: home_page.dart - TELA PRINCIPAL DO APLICATIVO
// 🎯 OBJETIVO: Navegação principal, busca e listagem de pets

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 📂 PÁGINAS
import 'package:app_projetoyuri/pages/add_pet_page.dart'; // ➕ Tela de cadastro
import 'package:app_projetoyuri/pages/my_pets_page.dart'; // 🐾 Meus pets
import 'package:app_projetoyuri/pages/profile_page.dart'; // 👤 Perfil
import 'package:app_projetoyuri/pages/settings_page.dart'; // ⚙️ Configurações
import 'package:app_projetoyuri/pages/pet_detail_page.dart'; // 📋 Detalhes do pet

// 📂 MODELOS E PROVIDERS
import 'package:app_projetoyuri/models/pet_model.dart'; // 🎯 Modelo de dados
import 'package:app_projetoyuri/providers/pet_provider.dart'; // 🐾 Provider de pets

// 📂 UTILITÁRIOS
import 'package:app_projetoyuri/utils/constants.dart'; // 📏 Constantes do app

// 🏠 HOME PAGE PRINCIPAL
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 🎯 Índice da aba selecionada

  @override
  void initState() {
    super.initState();
    // 🎬 Configura listener para atualizações do PetProvider após renderização
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PetProvider>().addListener(_onPetsChanged);
      }
    });
  }

  @override
  void dispose() {
    // 🧹 Remove listener para evitar memory leaks
    if (mounted) {
      context.read<PetProvider>().removeListener(_onPetsChanged);
    }
    super.dispose();
  }

  // 🔄 Atualiza UI quando pets mudam
  void _onPetsChanged() {
    if (mounted) setState(() {});
  }

  // 🎯 Gerencia navegação entre abas
  void _onItemTapped(int index) {
    if (index == 2) {
      _navigateToAddPet(); // ➕ Aba especial para adicionar pet
    } else {
      setState(() {
        _selectedIndex = index; // 🔄 Atualiza aba selecionada
      });
    }
  }

  // 🚀 Navega para a tela de cadastro de pet
  void _navigateToAddPet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPetPage()),
    );

    // 🔄 Atualiza Home caso um pet tenha sido cadastrado
    if (result == true && context.mounted) {
      setState(() {
        _selectedIndex = 0; // 🏠 Volta para a Home
      });
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) setState(() {});
    }
  }

  // 🎯 Retorna a página correspondente à aba selecionada
  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return const _HomeContent(); // 🏠 Conteúdo principal
      case 1:
        return const MyPetsPage(); // 🐾 Meus pets
      case 3:
        return const ProfilePage(); // 👤 Perfil
      case 4:
        return const SettingsPage(); // ⚙️ Configurações
      default:
        return const _HomeContent(); // 🏠 Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // 📝 AppBar com nome do app
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
      ),

      // 🎯 Corpo dinâmico baseado na aba selecionada
      body: _getCurrentPage(),

      // 🔽 Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.bottomAppBarColor,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.iconTheme.color,
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

extension on ThemeData {
  Color? get bottomAppBarColor => null;
}

// 🏠 CONTEÚDO PRINCIPAL DA HOME
class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // 🎯 Estado local da busca

  @override
  void dispose() {
    _searchController.dispose(); // 🧹 Limpa controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        // 🔍 Filtra pets com base na busca
        final displayedPets = _searchQuery.isEmpty
            ? petProvider.pets
            : petProvider.searchPets(_searchQuery);

        // ⏳ Loading
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

        // ❌ Estado de erro
        if (petProvider.error.isNotEmpty && petProvider.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text('Erro ao carregar pets',
                    style: TextStyle(
                        fontSize: 18, color: theme.colorScheme.error)),
                const SizedBox(height: 8),
                Text(petProvider.error,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => petProvider.loadPets(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: theme.colorScheme.onPrimary),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        // 🎨 UI principal
        return Column(
          children: [
            // 🔍 Campo de busca
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value; // 🔄 Atualiza busca em tempo real
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '🔍 Pesquisar pets...',
                      helperText:
                          'Busque por nome, raça, espécie, localização, idade ou descrição',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            AppConstants.defaultBorderRadius),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = ''; // 🧹 Limpa busca
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 🎯 Filtros rápidos (apenas quando não há busca)
                  if (_searchQuery.isEmpty)
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildQuickFilter(theme, '🐕 Cachorro', 'cachorro'),
                        _buildQuickFilter(theme, '🐈 Gato', 'gato'),
                        _buildQuickFilter(theme, '🐹 Hamster', 'hamster'),
                        _buildQuickFilter(theme, '🐦 Calopsita', 'calopsita'),
                        _buildQuickFilter(theme, '💉 Vacinados', 'vacinado'),
                        _buildQuickFilter(theme, '🔍 Ver todos', ''),
                      ],
                    ),
                ],
              ),
            ),

            // 📜 Resultados da busca
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding),
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

            // 🐾 Lista de pets
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => petProvider.loadPets(), // 🔄 Pull to refresh
                child: displayedPets.isEmpty
                    ? _buildEmptyState(theme, _searchQuery) // 📭 Estado vazio
                    : ListView.builder(
                        itemCount: displayedPets.length,
                        itemBuilder: (context, index) {
                          final pet = displayedPets[index];
                          return _PetCard(
                              pet: pet, theme: theme); // 🎴 Card do pet
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 🎯 Filtro rápido
  Widget _buildQuickFilter(ThemeData theme, String label, String query) {
    return GestureDetector(
      onTap: () {
        _searchController.text = query;
        setState(() {
          _searchQuery = query; // 🔄 Aplica filtro
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          // ignore: deprecated_member_use
          border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 📭 Estado vazio quando não há pets
  Widget _buildEmptyState(ThemeData theme, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? AppConstants.noPetsFound : 'Nenhum pet encontrado',
            style: TextStyle(
              fontSize: AppConstants.subheadingFontSize,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            query.isEmpty
                ? 'Clique em + para adicionar um pet'
                : 'Tente buscar por outro termo',
            style: TextStyle(
              color: theme.textTheme.bodySmall?.color,
              fontSize: AppConstants.captionFontSize,
            ),
          ),
        ],
      ),
    );
  }
}

// 🎴 CARD DO PET - Componente reutilizável
class _PetCard extends StatefulWidget {
  final Pet pet;
  final ThemeData theme;

  const _PetCard({required this.pet, required this.theme});

  @override
  State<_PetCard> createState() => __PetCardState();
}

class __PetCardState extends State<_PetCard> {
  Color? _cardColor;

  // 🚀 Navega para detalhes do pet
  void _navigateToPetDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetDetailPage(pet: widget.pet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

//GestureDetector 
    return GestureDetector(
onTap: () {
  setState(() {
    _cardColor = _cardColor == null
        ? const Color(0xFFFFF8E1) // branco creme
        : null; // volta à cor normal
  });

  _navigateToPetDetail(context);
},
      child: Card(
        margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding, vertical: 8),
        elevation: AppConstants.cardElevation,
        color: _cardColor ?? theme.cardColor,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.defaultBorderRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Imagem do pet
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.defaultBorderRadius)),
              child: widget.pet.photos.isNotEmpty
                  ? Image.network(
                      widget.pet.photos.first,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage(
                            theme); // Placeholder em caso de erro
                      },
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[200], // cor clara de fundo
                      child: _buildPlaceholderImage(
                          theme), // Placeholder quando não há foto
                    ),
            ),

            // 📋 Informações do pet
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.pet.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color)),
                  const SizedBox(height: 4),
                  Text('${widget.pet.species} • ${widget.pet.breed}',
                      style:
                          TextStyle(color: theme.textTheme.bodyMedium?.color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🖼️ Placeholder para pets sem foto
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
