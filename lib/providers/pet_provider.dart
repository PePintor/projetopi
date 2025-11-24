import 'package:flutter/material.dart';
import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/repositories/pet_repository.dart';

class PetProvider with ChangeNotifier {
  final PetRepository _petRepository = PetRepository();

  List<Pet> _pets = [];
  List<Pet> _myPets = [];
  bool _loading = false;
  String _error = '';

  List<Pet> get pets => _pets;
  List<Pet> get myPets => _myPets;
  bool get loading => _loading;
  String get error => _error;

  PetProvider() {
    loadPets();
  }

  Future<void> loadPets() async {
    _loading = true;
    _error = '';
    notifyListeners();

    try {
      _pets = await _petRepository.getPets();
      _error = '';
    } catch (e) {
      _error = 'Erro ao carregar pets: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMyPets() async {
    _loading = true;
    _error = '';
    notifyListeners();

    try {
      _myPets = await _petRepository.getMyPets();
      _error = '';
    } catch (e) {
      _error = 'Erro ao carregar meus pets: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addPet(Pet pet) async {
    print('🟡 INICIANDO addPet - Pet: ${pet.name}');
    _loading = true;
    notifyListeners();

    try {
      final newPet = await _petRepository.addPet(pet);

      _myPets.add(newPet);
      _pets.add(newPet);

      print('🟢 PET ADICIONADO COM SUCESSO');
      print('📊 Total na lista _pets: ${_pets.length}');
      print('📊 Total na lista _myPets: ${_myPets.length}');

      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      print('🔴 ERRO NO addPet: $e');
      _error = 'Erro ao adicionar pet: $e';
      notifyListeners();
      return false;
    } finally {
      _loading = false;
    }
  }

  // ✅ MÉTODO PARA ATUALIZAR PET
  Future<bool> updatePet(Pet updatedPet) async {
    print('🔄 ATUALIZANDO PET NO PROVIDER: ${updatedPet.name}');
    _loading = true;
    notifyListeners();

    try {
      final pet = await _petRepository.updatePet(updatedPet);

      // Atualiza nas listas locais
      final petIndex = _pets.indexWhere((p) => p.id == pet.id);
      final myPetIndex = _myPets.indexWhere((p) => p.id == pet.id);

      if (petIndex != -1) _pets[petIndex] = pet;
      if (myPetIndex != -1) _myPets[myPetIndex] = pet;

      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ ERRO AO ATUALIZAR PET: $e');
      _error = 'Erro ao atualizar pet: $e';
      notifyListeners();
      return false;
    } finally {
      _loading = false;
    }
  }

  // ✅ MÉTODO PARA REMOVER PET
  Future<bool> removePet(String petId) async {
    print('🗑️ REMOVENDO PET: $petId');
    _loading = true;
    notifyListeners();

    try {
      await _petRepository.deletePet(petId);

      // Remove das listas locais
      _pets.removeWhere((pet) => pet.id == petId);
      _myPets.removeWhere((pet) => pet.id == petId);

      _error = '';
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ ERRO AO REMOVER PET: $e');
      _error = 'Erro ao remover pet: $e';
      notifyListeners();
      return false;
    } finally {
      _loading = false;
    }
  }

  void refreshPets() {
    notifyListeners();
  }

  // ✅ MÉTODO DE PESQUISA CORRETO - SÓ CAMPOS QUE EXISTEM
  List<Pet> searchPets(String query) {
    if (query.isEmpty) return _pets;

    final queryLower = query.toLowerCase().trim();

    return _pets.where((pet) {
      // ✅ BUSCA NOS CAMPOS QUE EXISTEM NO SEU PET MODEL:
      return pet.name.toLowerCase().contains(queryLower) ||
          pet.breed.toLowerCase().contains(queryLower) ||
          pet.species.toLowerCase().contains(queryLower) ||
          pet.location.toLowerCase().contains(queryLower) ||
          pet.age.toLowerCase().contains(queryLower) ||
          pet.description.toLowerCase().contains(queryLower) ||
          pet.careInstructions.toLowerCase().contains(queryLower) ||
          _matchesSpecies(queryLower, pet.species) ||
          _matchesVaccinated(queryLower, pet.vaccinated);
    }).toList();
  }

  // ✅ BUSCA FLEXÍVEL POR ESPÉCIE
  bool _matchesSpecies(String query, String species) {
    final speciesLower = species.toLowerCase();

    final Map<String, List<String>> speciesSynonyms = {
      'cachorro': ['cachorro', 'cão', 'cao', 'dog', 'cachorros', 'cães'],
      'gato': ['gato', 'cat', 'gat', 'gatos', 'gata'],
      'hamster': ['hamster', 'hámster', 'hamsters'],
      'calopsita': ['calopsita', 'calopsite', 'calopsitas'],
      'pássaro': ['pássaro', 'passaro', 'ave', 'bird', 'pássaros', 'passaros'],
      'roedor': ['roedor', 'rato', 'hamster', 'roedores'],
      'réptil': ['réptil', 'reptil', 'cobra', 'lagarto', 'répteis', 'repteis'],
      'peixe': ['peixe', 'fish', 'peixes']
    };

    if (speciesSynonyms.containsKey(speciesLower)) {
      return speciesSynonyms[speciesLower]!.contains(query);
    }

    return false;
  }

  // ✅ BUSCA POR STATUS DE VACINA (campo que existe!)
  bool _matchesVaccinated(String query, bool vaccinated) {
    final vaccinatedMap = {
      true: ['vacinado', 'vacina', 'vaccinated', 'vacinada', 'vacinados'],
      false: ['não vacinado', 'nao vacinado', 'not vaccinated', 'sem vacina']
    };

    return vaccinatedMap[vaccinated]?.contains(query) ?? false;
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}

















// counter
// Criar display_page.dart:

// lib/pages/display_page.dart
// import 'package:flutter/material.dart';
// import 'package:app_projetoyuri/providers/counter_notifier.dart';

// class DisplayPage extends StatelessWidget {
//   const DisplayPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Mostrar Valor")),
//       body: Center(
//         child: ValueListenableBuilder<int>(
//           valueListenable: CounterController.counter,
//           builder: (context, value, child) {
//             return Text(
//               "Valor: $value",
//               style: const TextStyle(fontSize: 32),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// Criar o increment_page.dart:

// lib/pages/increment_page.dart

// import 'package:flutter/material.dart';
// import 'package:app_projetoyuri/providers/counter_notifier.dart';

// class IncrementPage extends StatelessWidget {
//   const IncrementPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Incrementar")),
//       body: Center(
//         child: ValueListenableBuilder<int>(
//           valueListenable: CounterController.counter,
//           builder: (context, value, _) {
//             return Text(
//               "Valor atual: $value",
//               style: const TextStyle(fontSize: 26),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => CounterController.increment(),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// Crie o counter_notifier.dart:

// Lib/providers/counter_notifier.dart
// import 'package:flutter/material.dart';

// class CounterController {
//   static ValueNotifier<int> counter = ValueNotifier<int>(0);

//   static void increment() {
//     counter.value++;
//   }
// }

// Na home tem que estar 

// import 'package:app_projetoyuri/pages/display_page.dart';

//                   ElevatedButton(
//   child: const Text("Ir para Incrementar"),
//   onPressed: () {
//     Navigator.push(context, MaterialPageRoute(
//       builder: (_) => const IncrementPage(),
//     ));
//   },
// ),

// ElevatedButton(
//   child: const Text("Ir para Mostrar Valor"),
//   onPressed: () {
//     Navigator.push(context, MaterialPageRoute(
//       builder: (_) => const DisplayPage(),
//     ));
//   },
// ),


