// lib/models/pet_model.dart
class Pet {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String age;
  final String description;
  final String careInstructions;
  final List<String> photos;
  final bool vaccinated;
  final String location;
  final String contact;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt; // ✅ ADICIONE ESTE CAMPO

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.description,
    required this.careInstructions,
    required this.photos,
    required this.vaccinated,
    required this.location,
    required this.contact,
    required this.userId,
    required this.createdAt,
    this.updatedAt, // ✅ OPCIONAL
  });

  // Método copyWith atualizado
  Pet copyWith({
    String? id,
    String? name,
    String? species,
    String? breed,
    String? age,
    String? description,
    String? careInstructions,
    List<String>? photos,
    bool? vaccinated,
    String? location,
    String? contact,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt, // ✅ ADICIONE
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      description: description ?? this.description,
      careInstructions: careInstructions ?? this.careInstructions,
      photos: photos ?? this.photos,
      vaccinated: vaccinated ?? this.vaccinated,
      location: location ?? this.location,
      contact: contact ?? this.contact,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt, // ✅ INCLUA
    );
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? '',
      description: json['description'] ?? '',
      careInstructions: json['careInstructions'] ?? '',
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
      vaccinated: json['vaccinated'] ?? false,
      location: json['location'] ?? '',
      contact: json['contact'] ?? '',
      userId: json['userId'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null, // ✅ INCLUA
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'description': description,
      'careInstructions': careInstructions,
      'photos': photos,
      'vaccinated': vaccinated,
      'location': location,
      'contact': contact,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(), // ✅ INCLUA
    };
  }
}
