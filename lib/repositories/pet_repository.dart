import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/services/api_service.dart';
import 'package:app_projetoyuri/services/storage_service.dart';

class PetRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // Busca pets públicos
  Future<List<Pet>> getPets() async {
    try {
      final pets = await _apiService.getPets();
      await _storageService.savePets(pets);
      print('✅ PETS CARREGADOS DA API: ${pets.length}');
      return pets;
    } catch (e) {
      print('❌ ERRO NA API, tentando cache: $e');
      final cachedPets = await _storageService.getPets();
      print('📦 PETS DO CACHE: ${cachedPets.length}');
      return cachedPets;
    }
  }

  // Busca meus pets (filtra por userId)
  Future<List<Pet>> getMyPets() async {
    try {
      final allPets = await getPets();

      const currentUserId = 'user1';
      final myPets =
          allPets.where((pet) => pet.userId == currentUserId).toList();

      print('🐾 MEUS PETS: ${myPets.length} de ${allPets.length} total');
      print('👤 USER ID FILTRO: $currentUserId');

      return myPets;
    } catch (e) {
      print('❌ Erro ao buscar meus pets: $e');

      // Fallback para cache
      final cachedPets = await _storageService.getPets();
      const currentUserId = 'user1';
      final myCachedPets =
          cachedPets.where((pet) => pet.userId == currentUserId).toList();

      print('📦 MEUS PETS DO CACHE: ${myCachedPets.length}');
      return myCachedPets;
    }
  }

  // Adiciona novo pet
  Future<Pet> addPet(Pet pet) async {
    try {
      final newPet = await _apiService.addPet(pet);
      final currentPets = await _storageService.getPets();
      currentPets.add(newPet);
      await _storageService.savePets(currentPets);
      return newPet;
    } catch (e) {
      print('❌ Erro ao adicionar pet na API, salvando local: $e');

      // Cria pet local com ID único
      final localPet = pet.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );

      final currentPets = await _storageService.getPets();
      currentPets.add(localPet);
      await _storageService.savePets(currentPets);

      print('💾 PET SALVO LOCALMENTE: ${localPet.name}');
      return localPet;
    }
  }

  //  MÉTODO PARA ATUALIZAR PET
  Future<Pet> updatePet(Pet pet) async {
    try {
      print('🔄 ATUALIZANDO PET NA API: ${pet.name}');
      final updatedPet = await _apiService.updatePet(pet);

      // Atualiza no cache local também
      final currentPets = await _storageService.getPets();
      final index = currentPets.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        currentPets[index] = updatedPet;
        await _storageService.savePets(currentPets);
      }

      print('✅ PET ATUALIZADO: ${pet.name}');
      return updatedPet;
    } catch (e) {
      print('❌ Erro ao atualizar pet na API, atualizando local: $e');

      // Fallback: atualiza apenas localmente
      final updatedPet = pet.copyWith(updatedAt: DateTime.now());
      final currentPets = await _storageService.getPets();
      final index = currentPets.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        currentPets[index] = updatedPet;
        await _storageService.savePets(currentPets);
      }

      return updatedPet;
    }
  }

  //  MÉTODO PARA REMOVER PET
  Future<void> deletePet(String petId) async {
    try {
      print('🗑️ REMOVENDO PET: $petId');
      await _apiService.deletePet(petId);

      // Remove do cache local também
      final currentPets = await _storageService.getPets();
      currentPets.removeWhere((pet) => pet.id == petId);
      await _storageService.savePets(currentPets);

      print('✅ PET REMOVIDO: $petId');
    } catch (e) {
      print('❌ Erro ao remover pet da API, removendo local: $e');

      // Fallback: remove apenas localmente
      final currentPets = await _storageService.getPets();
      currentPets.removeWhere((pet) => pet.id == petId);
      await _storageService.savePets(currentPets);
    }
  }

  Future<void> clearCache() async {
    await _storageService.clearPets();
    print('🧹 CACHE LIMPO');
  }
}
