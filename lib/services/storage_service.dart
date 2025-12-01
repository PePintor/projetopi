// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ IMPORT CORRETO
import 'package:app_projetoyuri/models/pet_model.dart';
import 'package:app_projetoyuri/utils/constants.dart';

class StorageService {
  // Salva lista de pets no cache
  Future<void> savePets(List<Pet> pets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final petsJson = pets.map((pet) => pet.toJson()).toList();
      await prefs.setString(AppConstants.cachedPetsKey, jsonEncode(petsJson));
    } catch (e) {
      print('Erro ao salvar pets no cache: $e');
    }
  }

  // Carrega lista de pets do cache
  Future<List<Pet>> getPets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final petsJson = prefs.getString(AppConstants.cachedPetsKey);

      if (petsJson != null) {
        final List<dynamic> petsList = jsonDecode(petsJson);
        return petsList.map((json) => Pet.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao carregar pets do cache: $e');
    }
    return [];
  }

  // Limpa cache de pets
  Future<void> clearPets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.cachedPetsKey);
    } catch (e) {
      print('Erro ao limpar cache: $e');
    }
  }

  // Salva tema preferido
  Future<void> saveTheme(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.themePreferenceKey, isDark);
    } catch (e) {
      print('Erro ao salvar tema: $e');
    }
  }

  // Carrega tema preferido
  Future<bool> getTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(AppConstants.themePreferenceKey) ?? false;
    } catch (e) {
      print('Erro ao carregar tema: $e');
      return false;
    }
  }

  // Salva dados do usuário
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userDataKey, jsonEncode(userData));
    } catch (e) {
      print('Erro ao salvar dados do usuário: $e');
    }
  }

  // Carrega dados do usuário
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = prefs.getString(AppConstants.userDataKey);
      if (userDataJson != null) {
        return jsonDecode(userDataJson) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
    }
    return null;
  }

  //  Remove apenas dados do usuário
  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userDataKey);
      print('🧹 DADOS DO USUÁRIO REMOVIDOS');
    } catch (e) {
      print('Erro ao remover dados do usuário: $e');
    }
  }

  // Limpa todos os dados
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.cachedPetsKey);
      await prefs.remove(AppConstants.themePreferenceKey);
      await prefs.remove(AppConstants.userDataKey);
    } catch (e) {
      print('Erro ao limpar dados: $e');
    }
  }
}
