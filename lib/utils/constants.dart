// lib/utils/constants.dart

class AppConstants {
  // API Configuration - ATUALIZADO para seu MockAPI real
  static const String apiBaseUrl = 'https://69177d39a7a34288a280f135.mockapi.io/api/v1';
  static const int apiTimeoutSeconds = 30;

  // Storage Keys
  static const String cachedPetsKey = 'cached_pets';
  static const String themePreferenceKey = 'theme_preference';
  static const String userDataKey = 'user_data';
  static const String firstTimeKey = 'first_time';

  // App Information
  static const String appName = 'AdotaJá';
  static const String appVersion = '1.0.0';

  // Design System
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double buttonHeight = 50.0;

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);


  static const List<String> petSpecies = [
    'Cachorro',
    'Gato',
    'Hamster',
    'Calopsita',
    'Pássaro',
    'Roedor',
    'Réptil',
    'Peixe',
    'Outros'
  ];

  
  static bool isValidSpecies(String species) {
    return petSpecies.any((s) => s.toLowerCase() == species.toLowerCase());
  }

  // Raças por espécie
  static const List<String> dogBreeds = [
    'Vira-lata',
    'Labrador Retriever',
    'Golden Retriever',
    'Pastor Alemão',
    'Bulldog',
    'Poodle',
    'Beagle',
    'Rottweiler',
    'Yorkshire Terrier',
    'Boxer',
    'Pinscher',
    'Shih Tzu',
    'Dachshund',
    'Husky Siberiano',
    'Border Collie',
    'Outra'
  ];

  static const List<String> catBreeds = [
    'Vira-lata',
    'Siamês',
    'Persa',
    'Maine Coon',
    'Angorá',
    'Sphynx',
    'Ragdoll',
    'Bengal',
    'British Shorthair',
    'Scottish Fold',
    'Russian Blue',
    'Outra'
  ];

  static const List<String> birdBreeds = [
    'Calopsita',
    'Periquito',
    'Canário',
    'Agapornis',
    'Cacatua',
    'Papagaio',
    'Outra'
  ];

  // Age Options
  static const List<String> ageOptions = [
    'Filhote (0-1 ano)',
    'Jovem (1-3 anos)',
    'Adulto (3-8 anos)',
    'Idoso (8+ anos)'
  ];

  // Size Options
  static const List<String> sizeOptions = ['Pequeno', 'Médio', 'Grande'];

  // Gender Options
  static const List<String> genderOptions = ['Macho', 'Fêmea'];

  // Location Options
  static const List<String> brazilianStates = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS',
    'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC',
    'SP', 'SE', 'TO'
  ];

  static const List<String> cities = [
    'São Paulo', 'Rio de Janeiro', 'Belo Horizonte', 'Curitiba', 'Porto Alegre',
    'Salvador', 'Fortaleza', 'Recife', 'Brasília', 'Goiânia', 'Manaus', 'Belém',
    'Florianópolis', 'Vitória', 'Natal', 'João Pessoa', 'Maceió', 'Teresina',
    'Campo Grande', 'Cuiabá', 'Outra'
  ];

  // Validation Messages
  static const String requiredFieldMessage = 'Este campo é obrigatório';
  static const String invalidEmailMessage = 'Digite um email válido';
  static const String shortPasswordMessage = 'Senha deve ter pelo menos 6 caracteres';
  static const String phoneInvalidMessage = 'Digite um telefone válido';
  static const String nameTooShortMessage = 'Nome deve ter pelo menos 2 caracteres';
  static const String descriptionTooShortMessage = 'Descrição deve ter pelo menos 10 caracteres';
  static const String descriptionTooLongMessage = 'Descrição deve ter no máximo 500 caracteres';

  // Success Messages
  static const String petAddedSuccess = 'Pet cadastrado com sucesso!';
  static const String petUpdatedSuccess = 'Pet atualizado com sucesso!';
  static const String petDeletedSuccess = 'Pet removido com sucesso!';
  static const String loginSuccess = 'Login realizado com sucesso!';
  static const String logoutSuccess = 'Logout realizado com sucesso!';
  static const String profileUpdatedSuccess = 'Perfil atualizado com sucesso!';

  // Error Messages
  static const String networkError = 'Erro de conexão. Verifique sua internet.';
  static const String serverError = 'Erro no servidor. Tente novamente.';
  static const String unknownError = 'Erro desconhecido. Tente novamente.';
  static const String loginError = 'Email ou senha incorretos.';
  static const String noPetsFound = 'Nenhum pet encontrado.';
  static const String noInternet = 'Sem conexão com a internet.';

  
  static const int maxImages = 5;
  static const int imageQuality = 85;
  static const int maxImageWidth = 1200;
  static const int maxImageHeight = 900;
  static const int maxImageSizeMB = 2;
  static const String defaultPetImage = 'https://picsum.photos/400/300?random=';
  static const String userAvatarBaseUrl = 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/';

  // Mock Data for Development
  static const List<Map<String, dynamic>> mockPets = [
    {
      'name': 'Rex',
      'species': 'Cachorro',
      'breed': 'Labrador Retriever',
      'age': '2 anos',
      'location': 'São Paulo, SP',
      'size': 'Grande',
      'gender': 'Macho',
    },
    {
      'name': 'Luna',
      'species': 'Gato',
      'breed': 'Siamês',
      'age': '1 ano',
      'location': 'Rio de Janeiro, RJ',
      'size': 'Médio',
      'gender': 'Fêmea',
    },
    {
      'name': 'Thor',
      'species': 'Cachorro',
      'breed': 'Vira-lata',
      'age': '3 anos',
      'location': 'Belo Horizonte, MG',
      'size': 'Médio',
      'gender': 'Macho',
    },
    {
      'name': 'Mel',
      'species': 'Cachorro',
      'breed': 'Golden Retriever',
      'age': '4 meses',
      'location': 'Curitiba, PR',
      'size': 'Médio',
      'gender': 'Fêmea',
    },
  ];

  // App Colors
  static const int primaryColorValue = 0xFF2196F3;
  static const int secondaryColorValue = 0xFF4CAF50;
  static const int accentColorValue = 0xFFFF9800;
  static const int errorColorValue = 0xFFF44336;
  static const int successColorValue = 0xFF4CAF50;
  static const int warningColorValue = 0xFFFFC107;

  // Text Styles
  static const double headingFontSize = 24.0;
  static const double subheadingFontSize = 18.0;
  static const double bodyFontSize = 16.0;
  static const double captionFontSize = 14.0;
  static const double smallFontSize = 12.0;

  // API Endpoints
  static const String petsEndpoint = '/pets';
  static const String usersEndpoint = '/users';
  static const String authEndpoint = '/auth';
  static const String adoptionsEndpoint = '/adoptions';

  // Feature Flags
  static const bool enableMockData = true;
  static const bool enableDebugLogs = true;
  static const bool enableAnalytics = false;

  // App Settings
  static const bool requireEmailVerification = false;
  static const int maxPetsPerUser = 10;
  static const int cacheDurationHours = 24;

 
  static String generateImageUrl() {
    return '${defaultPetImage}${DateTime.now().millisecondsSinceEpoch}';
  }

  
  static List<String> getBreedsForSpecies(String species) {
    switch (species.toLowerCase()) {
      case 'cachorro':
        return dogBreeds;
      case 'gato':
        return catBreeds;
      case 'pássaro':
      case 'calopsita':
        return birdBreeds;
      default:
        return ['Outra']; // Para outras espécies
    }
  }
}