// lib/models/user_model.dart
class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? location;
  final String? bio;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.location,
    this.bio,
    required this.createdAt,
    this.updatedAt,
  });

  //COPYWITH - Para atualizações (igual PetModel)
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? location,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  //FROMJSON - Para MockAPI (igual PetModel)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      location: json['location'],
      bio: json['bio'],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // TOJSON - Para MockAPI (igual PetModel)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'location': location,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

 
  static User empty() {
    return User(
      id: '',
      email: '',
      name: '',
      createdAt: DateTime.now(),
    );
  }

  //  VERIFICAR SE É USUÁRIO VÁLIDO
  bool get isValid => id.isNotEmpty && email.isNotEmpty && name.isNotEmpty;
}
