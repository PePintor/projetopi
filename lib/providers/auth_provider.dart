// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:app_projetoyuri/models/user_model.dart';
import 'package:app_projetoyuri/repositories/user_repository.dart';

class AuthProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  User? _currentUser;
  bool _loading = false;
  String _error = '';

  User? get currentUser => _currentUser;
  bool get loading => _loading;
  String get error => _error;
  bool get isLoggedIn => _currentUser != null;

  AuthProvider() {
    _loadCurrentUser();
  }

  //  CARREGA USUÁRIO - igual PetProvider.loadPets()
  Future<void> _loadCurrentUser() async {
    _loading = true;
    _error = '';
    notifyListeners();

    try {
      _currentUser = await _userRepository.getCurrentUser();
      _error = '';
    } catch (e) {
      _error = 'Erro ao carregar usuário: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  //  LOGIN - igual PetProvider.addPet()
  Future<bool> login(String email, String password) async {
    print('🟡 INICIANDO login - Email: $email');
    _loading = true;
    _error = '';
    notifyListeners();

    try {
      // Simula delay de rede
      await Future.delayed(const Duration(seconds: 2));

      // Cria usuário com email do login
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: _generateNameFromEmail(email),
        phone: null,
        location: null,
        bio: null,
        createdAt: DateTime.now(),
      );

      // Salva usuário no repositório
      _currentUser = await _userRepository.saveUser(user);
      _error = '';

      print('🟢 LOGIN REALIZADO COM SUCESSO');
      print('📧 Usuário: ${_currentUser!.email}');
      print('👤 Nome: ${_currentUser!.name}');
      print('🆔 ID: ${_currentUser!.id}');

      notifyListeners();
      return true;
    } catch (e) {
      print('🔴 ERRO NO LOGIN: $e');
      _error = 'Erro ao fazer login: $e';
      notifyListeners();
      return false;
    } finally {
      _loading = false;
    }
  }

  //  ATUALIZAR PERFIL - igual PetProvider.updatePet()
  Future<bool> updateProfile(User updatedUser) async {
    print('🔄 ATUALIZANDO PERFIL NO PROVIDER: ${updatedUser.name}');
    _loading = true;
    _error = '';
    notifyListeners();

    try {
      // Atualiza usuário no repositório
      _currentUser = await _userRepository.updateUser(updatedUser);
      _error = '';

      print('🟢 PERFIL ATUALIZADO COM SUCESSO');
      print('👤 Nome: ${_currentUser!.name}');
      print('📞 Telefone: ${_currentUser!.phone}');
      print('📍 Localização: ${_currentUser!.location}');
      print('📝 Bio: ${_currentUser!.bio}');

      notifyListeners();
      return true;
    } catch (e) {
      print('❌ ERRO AO ATUALIZAR PERFIL: $e');
      _error = 'Erro ao atualizar perfil: $e';
      notifyListeners();
      return false;
    } finally {
      _loading = false;
    }
  }

  //  LOGOUT - igual PetProvider.removePet()
  Future<bool> logout() async {
    print('🔵 INICIANDO logout');
    _loading = true;
    notifyListeners();

    try {
      // Limpa usuário no repositório
      await _userRepository.clearUser();

      _currentUser = null;
      _error = '';

      print('🟢 LOGOUT REALIZADO COM SUCESSO');
      notifyListeners();
      return true;
    } catch (e) {
      print('🔴 ERRO NO LOGOUT: $e');
      _error = 'Erro ao fazer logout: $e';
      notifyListeners();
      return false;
    } finally {
      _loading = false;
    }
  }

  //  MÉTODO AUXILIAR - Gera nome baseado no email
  String _generateNameFromEmail(String email) {
    final emailPart = email.split('@').first;
    final name = emailPart.replaceAll('.', ' ').replaceAll('_', ' ');
    return name.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).join(' ');
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void refreshUser() {
    notifyListeners();
  }
}
