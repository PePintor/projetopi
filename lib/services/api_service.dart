import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/pet_model.dart';

class ApiService {
  // ✅ ACESSO CORRETO ÀS VARIÁVEIS DE AMBIENTE
  String get _baseUrl =>
      dotenv.env['API_BASE_URL'] ??
      'https://69177d39a7a34288a280f135.mockapi.io/api/v1';

  int get _timeout => int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30') ?? 30;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  // GET - Buscar todos os pets
  Future<List<Pet>> getPets() async {
    try {
      final url = '$_baseUrl/pets';
      print('🌐 BUSCANDO PETS DA API: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: _headers,
          )
          .timeout(Duration(seconds: _timeout));

      print('📡 STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('✅ PETS ENCONTRADOS: ${data.length}');
        return data.map((json) => Pet.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar pets: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ERRO: $e');
      throw Exception('Erro de conexão: $e');
    }
  }

  // POST - Adicionar novo pet
  Future<Pet> addPet(Pet pet) async {
    try {
      final url = '$_baseUrl/pets';
      print('🌐 ENVIANDO PET PARA API: ${pet.name} - URL: $url');

      final response = await http
          .post(
            Uri.parse(url),
            headers: _headers,
            body: jsonEncode(pet.toJson()),
          )
          .timeout(Duration(seconds: _timeout));

      print('📡 STATUS: ${response.statusCode}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('✅ PET ADICIONADO COM SUCESSO');
        return Pet.fromJson(data);
      } else {
        throw Exception('Falha ao adicionar pet: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ERRO: $e');
      throw Exception('Erro de conexão: $e');
    }
  }

  // PUT - Atualizar pet
  Future<Pet> updatePet(Pet pet) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl/pets/${pet.id}'),
            headers: _headers,
            body: jsonEncode(pet.toJson()),
          )
          .timeout(Duration(seconds: _timeout));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Pet.fromJson(data);
      } else {
        throw Exception('Falha ao atualizar pet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // DELETE - Remover pet
  Future<void> deletePet(String petId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$_baseUrl/pets/$petId'),
            headers: _headers,
          )
          .timeout(Duration(seconds: _timeout));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar pet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
