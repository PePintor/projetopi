// lib/utils/validators.dart
import 'constants.dart';

class Validators {
  // Validação de campo obrigatório
  static String? requiredField(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  // Validação de email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return AppConstants.invalidEmailMessage;
    }
    return null;
  }

  // Validação de senha
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredFieldMessage;
    }

    if (value.length < 6) {
      return AppConstants.shortPasswordMessage;
    }

    return null;
  }

  // Validação de telefone (Brasil)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // ✅ CORREÇÃO: Telefone é opcional para usuário
    }

    // Remove caracteres não numéricos
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');

    // Valida se tem 10 ou 11 dígitos (com DDD)
    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return AppConstants.phoneInvalidMessage;
    }

    // Valida DDD (deve ser entre 11 e 99)
    final ddd = int.tryParse(cleanPhone.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) {
      return AppConstants.phoneInvalidMessage;
    }

    return null;
  }

  // Validação de nome (apenas letras e espaços)
  static String? validateName(String? value, {String fieldName = 'Nome'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }

    final nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return '$fieldName deve conter apenas letras';
    }

    if (value.trim().length < 2) {
      return AppConstants.nameTooShortMessage;
    }

    if (value.trim().length > 50) {
      return '$fieldName deve ter no máximo 50 caracteres';
    }

    return null;
  }

  // Validação de idade
  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Idade é obrigatória';
    }

    // Verifica formato comum: "X anos", "Y meses", etc.
    final ageRegex =
        RegExp(r'(\d+)\s*(ano|mes|mês|semana|dia)s?', caseSensitive: false);
    if (!ageRegex.hasMatch(value.toLowerCase())) {
      return 'Digite uma idade válida (ex: 2 anos, 6 meses)';
    }

    // Tenta extrair números da string
    final ageMatch = RegExp(r'(\d+)').firstMatch(value);
    if (ageMatch == null) {
      return 'Digite uma idade válida';
    }

    final age = int.tryParse(ageMatch.group(1)!);
    if (age == null || age <= 0 || age > 30) {
      return 'Digite uma idade válida (1-30 anos)';
    }

    return null;
  }

  // Validação de descrição
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }

    if (value.trim().length < 10) {
      return AppConstants.descriptionTooShortMessage;
    }

    if (value.trim().length > 500) {
      return AppConstants.descriptionTooLongMessage;
    }

    return null;
  }

  // Validação de localização
  static String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // ✅ CORREÇÃO: Localização é opcional para usuário
    }

    if (value.trim().length < 3) {
      return 'Localização deve ter pelo menos 3 caracteres';
    }

    return null;
  }

  // Validação de contato
  static String? validateContact(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }

    // Verifica se é email
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    final isEmail = emailRegex.hasMatch(value.trim());

    // Verifica se é telefone (apenas números e caracteres de formatação)
    final phoneRegex = RegExp(r'^[\d\s\(\)\-\.\+]+$');
    final isPhone = phoneRegex.hasMatch(value.replaceAll(' ', ''));

    if (!isEmail && !isPhone) {
      return 'Digite um email ou telefone válido';
    }

    if (isPhone) {
      return validatePhone(value);
    }

    return null;
  }

  // Validação de espécie - VERSÃO CORRIGIDA (aceita minúsculas)
  static String? validateSpecies(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }

    // ✅ CORREÇÃO: Converte para a formatação correta e compara
    final formattedValue = _capitalizeFirstLetter(value.trim());

    if (!AppConstants.petSpecies.contains(formattedValue)) {
      return 'Selecione uma espécie válida';
    }

    return null;
  }

  // ✅ MÉTODO AUXILIAR: Capitaliza primeira letra
  static String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Validação de raça
  static String? validateBreed(String? value, String? species) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.requiredFieldMessage;
    }

    // Para outras espécies, apenas verifica se não está vazio
    if (value.trim().length < 2) {
      return 'Raça deve ter pelo menos 2 caracteres';
    }

    return null;
  }

  // Validação de tamanho
  static String? validateSize(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Tamanho é opcional
    }

    if (!AppConstants.sizeOptions.contains(value)) {
      return 'Selecione um tamanho válido';
    }

    return null;
  }

  // Validação de gênero
  static String? validateGender(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Gênero é opcional
    }

    if (!AppConstants.genderOptions.contains(value)) {
      return 'Selecione um gênero válido';
    }

    return null;
  }

  // Validação de número de imagens
  static String? validateImages(List<dynamic>? images) {
    if (images == null || images.isEmpty) {
      return 'Adicione pelo menos uma foto do pet';
    }

    if (images.length > AppConstants.maxImages) {
      return 'Máximo ${AppConstants.maxImages} fotos permitidas';
    }

    return null;
  }

  // Validação de instruções de cuidado
  static String? validateCareInstructions(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Instruções são opcionais
    }

    if (value.trim().length > 1000) {
      return 'Instruções devem ter no máximo 1000 caracteres';
    }

    return null;
  }

  // ✅ NOVA VALIDAÇÃO: Bio do usuário (opcional)
  static String? validateBio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Bio é opcional
    }

    if (value.trim().length > 300) {
      return 'Bio deve ter no máximo 300 caracteres';
    }

    return null;
  }

  // Validação combinada para formulário de pet
  static Map<String, String?> validatePetForm({
    required String? name,
    required String? species,
    required String? breed,
    required String? age,
    required String? description,
    required String? location,
    required String? contact,
    required List<dynamic>? images,
    String? size,
    String? gender,
    String? careInstructions,
  }) {
    return {
      'name': validateName(name, fieldName: 'Nome do pet'),
      'species': validateSpecies(species),
      'breed': validateBreed(breed, species),
      'age': validateAge(age),
      'description': validateDescription(description),
      'location': validateLocation(location),
      'contact': validateContact(contact),
      'images': validateImages(images),
      'size': validateSize(size),
      'gender': validateGender(gender),
      'careInstructions': validateCareInstructions(careInstructions),
    };
  }

  // Validação combinada para formulário de usuário
  static Map<String, String?> validateUserForm({
    required String? name,
    required String? email,
    required String? phone,
    required String? location,
    required String? bio,
  }) {
    return {
      'name': validateName(name, fieldName: 'Nome completo'),
      'email': validateEmail(email),
      'phone': validatePhone(phone),
      'location': validateLocation(location),
      'bio': validateBio(bio),
    };
  }

  // Validação combinada para login
  static Map<String, String?> validateLoginForm({
    required String? email,
    required String? password,
  }) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
    };
  }

  // Verifica se o formulário é válido
  static bool isFormValid(Map<String, String?> errors) {
    return errors.values.every((error) => error == null);
  }

  // Retorna o primeiro erro encontrado
  static String? getFirstError(Map<String, String?> errors) {
    return errors.values
        .firstWhere((error) => error != null, orElse: () => null);
  }

  // Formata telefone enquanto digita
  static String formatPhone(String input) {
    final digits = input.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length <= 2) {
      return digits;
    } else if (digits.length <= 6) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2)}';
    } else if (digits.length <= 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    } else {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}';
    }
  }

  // Formata CEP
  static String formatCEP(String input) {
    final digits = input.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length <= 5) {
      return digits;
    } else {
      return '${digits.substring(0, 5)}-${digits.substring(5, 8)}';
    }
  }

  // Valida CEP
  static String? validateCEP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // CEP é opcional
    }

    final cleanCEP = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanCEP.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }

    return null;
  }

  // Sanitiza entrada de texto (remove caracteres especiais perigosos)
  static String sanitizeText(String input) {
    return input.replaceAll(RegExp(r'[<>{}]'), '');
  }

  // Valida URL (para fotos)
  static String? validateURL(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final urlRegex = RegExp(
      r'^(https?://)?([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Digite uma URL válida';
    }

    return null;
  }
}
