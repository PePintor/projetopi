// lib/repositories/user_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_projetoyuri/models/user_model.dart';
import 'package:app_projetoyuri/utils/constants.dart';

class UserRepository {
  // ✅ SALVA USUÁRIO - igual addPet
  Future<User> saveUser(User user) async {
    print('💾 SALVANDO USUÁRIO: ${user.email}');

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(AppConstants.userDataKey, userJson);

      print('✅ USUÁRIO SALVO: ${user.name}');
      return user;
    } catch (e) {
      print('🔴 ERRO AO SALVAR USUÁRIO: $e');
      rethrow;
    }
  }

  // ✅ BUSCA USUÁRIO ATUAL - igual getPets
  Future<User?> getCurrentUser() async {
    print('🌐 BUSCANDO USUÁRIO...');

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConstants.userDataKey);

      if (userJson != null) {
        final userData = jsonDecode(userJson);
        final user = User.fromJson(userData);
        print('✅ USUÁRIO ENCONTRADO: ${user.email}');
        return user;
      }

      print('🔵 NENHUM USUÁRIO ENCONTRADO');
      return null;
    } catch (e) {
      print('🔴 ERRO AO BUSCAR USUÁRIO: $e');
      return null;
    }
  }

  // ✅ ATUALIZA USUÁRIO - igual updatePet
  Future<User> updateUser(User user) async {
    print('🔄 ATUALIZANDO USUÁRIO: ${user.name}');

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(AppConstants.userDataKey, userJson);

      print('✅ USUÁRIO ATUALIZADO: ${user.email}');
      return user;
    } catch (e) {
      print('🔴 ERRO AO ATUALIZAR USUÁRIO: $e');
      rethrow;
    }
  }

  // ✅ REMOVE USUÁRIO - igual deletePet
  Future<void> clearUser() async {
    print('🗑️ REMOVENDO USUÁRIO...');

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userDataKey);
      print('✅ USUÁRIO REMOVIDO');
    } catch (e) {
      print('🔴 ERRO AO REMOVER USUÁRIO: $e');
      rethrow;
    }
  }
}
