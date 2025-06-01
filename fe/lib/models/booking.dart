class Booking {
  final int id;
  final String startDate;
  final String? endDate;
  final String notes;
  final String status;
  final int userId;
  final int serviceId;
  final int? petId;

  Booking({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.notes,
    required this.status,
    required this.userId,
    required this.serviceId,
    this.petId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? 0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'],
      notes: json['notes'] ?? '',
      status: json['status'] ?? '',
      userId: json['user_id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      petId: json['pet_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_date': startDate,
      'end_date': endDate,
      'notes': notes,
      'status': status,
      'user_id': userId,
      'service_id': serviceId,
      'pet_id': petId,
    };
  }

  Booking copyWith({
    int? id,
    String? startDate,
    String? endDate,
    String? notes,
    String? status,
    int? userId,
    int? serviceId,
    int? petId,
  }) {
    return Booking(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      petId: petId ?? this.petId,
    );
  }

  @override
  String toString() {
    return 'Booking{id: $id, startDate: $startDate, endDate: $endDate, notes: $notes, status: $status, userId: $userId, serviceId: $serviceId, petId: $petId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Booking &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          notes == other.notes &&
          status == other.status &&
          userId == other.userId &&
          serviceId == other.serviceId &&
          petId == other.petId;

  @override
  int get hashCode =>
      id.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      notes.hashCode ^
      status.hashCode ^
      userId.hashCode ^
      serviceId.hashCode ^
      petId.hashCode;
}

class BookingCreate {
  final String startDate;
  final String? endDate;
  final String notes;
  final int userId;
  final int serviceId;
  final int? petId;

  BookingCreate({
    required this.startDate,
    this.endDate,
    required this.notes,
    required this.userId,
    required this.serviceId,
    this.petId,
  });

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate ?? '',
      'notes': notes,
      'user_id': userId,
      'service_id': serviceId,
      'pet_id': petId,
    };
  }
}

class BookingUpdate {
  final String startDate;
  final String? endDate;
  final String notes;
  final int userId;
  final int serviceId;
  final int? petId;

  BookingUpdate({
    required this.startDate,
    this.endDate,
    required this.notes,
    required this.userId,
    required this.serviceId,
    this.petId,
  });

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate ?? '',
      'notes': notes,
      'user_id': userId,
      'service_id': serviceId,
      'pet_id': petId,
    };
  }
}

class BookingStatus {
  final int id;
  final String status;

  BookingStatus({
    required this.id,
    required this.status,
  });

  factory BookingStatus.fromJson(Map<String, dynamic> json) {
    return BookingStatus(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }
} 