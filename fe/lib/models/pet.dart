class Pet {
  final int id;
  final String name;
  final String birthDate;
  final String gender;
  final String species;
  final String color;
  final String healthInfo;
  final int userId;

  Pet({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.species,
    required this.color,
    required this.healthInfo,
    required this.userId,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      birthDate: json['birth_date'] ?? '',
      gender: json['gender'] ?? '',
      species: json['species'] ?? '',
      color: json['color'] ?? '',
      healthInfo: json['health_info'] ?? '',
      userId: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate,
      'gender': gender,
      'species': species,
      'color': color,
      'health_info': healthInfo,
      'user_id': userId,
    };
  }

  Pet copyWith({
    int? id,
    String? name,
    String? birthDate,
    String? gender,
    String? species,
    String? color,
    String? healthInfo,
    int? userId,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      species: species ?? this.species,
      color: color ?? this.color,
      healthInfo: healthInfo ?? this.healthInfo,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Pet{id: $id, name: $name, birthDate: $birthDate, gender: $gender, species: $species, color: $color, healthInfo: $healthInfo, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pet &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          birthDate == other.birthDate &&
          gender == other.gender &&
          species == other.species &&
          color == other.color &&
          healthInfo == other.healthInfo &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      birthDate.hashCode ^
      gender.hashCode ^
      species.hashCode ^
      color.hashCode ^
      healthInfo.hashCode ^
      userId.hashCode;
}

class PetCreate {
  final String name;
  final String birthDate;
  final String gender;
  final String species;
  final String color;
  final String healthInfo;
  final int userId;

  PetCreate({
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.species,
    required this.color,
    required this.healthInfo,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birth_date': birthDate,
      'gender': gender,
      'species': species,
      'color': color,
      'health_info': healthInfo,
      'user_id': userId,
    };
  }
}

class PetUpdate {
  final String name;
  final String birthDate;
  final String gender;
  final String species;
  final String color;
  final String healthInfo;
  final int userId;

  PetUpdate({
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.species,
    required this.color,
    required this.healthInfo,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birth_date': birthDate,
      'gender': gender,
      'species': species,
      'color': color,
      'health_info': healthInfo,
      'user_id': userId,
    };
  }
} 