class Cage {
  final int id;
  final String type;
  final String size;
  final String status;
  final String startDate;
  final String endDate;
  final int? petId;

  Cage({
    required this.id,
    required this.type,
    required this.size,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.petId,
  });

  factory Cage.fromJson(Map<String, dynamic> json) {
    return Cage(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      size: json['size'] ?? '',
      status: json['status'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      petId: json['pet_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'size': size,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'pet_id': petId,
    };
  }

  Cage copyWith({
    int? id,
    String? type,
    String? size,
    String? status,
    String? startDate,
    String? endDate,
    int? petId,
  }) {
    return Cage(
      id: id ?? this.id,
      type: type ?? this.type,
      size: size ?? this.size,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      petId: petId ?? this.petId,
    );
  }

  @override
  String toString() {
    return 'Cage{id: $id, type: $type, size: $size, status: $status, startDate: $startDate, endDate: $endDate, petId: $petId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          size == other.size &&
          status == other.status &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          petId == other.petId;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      size.hashCode ^
      status.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      petId.hashCode;
}

class CageCreate {
  final String type;
  final String size;
  final String status;
  final String startDate;
  final String endDate;
  final int? petId;

  CageCreate({
    required this.type,
    required this.size,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.petId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'size': size,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'pet_id': petId,
    };
  }
}

class CageUpdate {
  final String type;
  final String size;
  final String status;
  final String startDate;
  final String endDate;
  final int? petId;

  CageUpdate({
    required this.type,
    required this.size,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.petId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'size': size,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'pet_id': petId,
    };
  }
} 