class MedicalRecord {
  final int id;
  final String diagnosis;
  final String prescription;
  final String notes;
  final String nextMeetingDate;
  final String recordDate;
  final String recordType;
  final int petId;
  final int userId;

  MedicalRecord({
    required this.id,
    required this.diagnosis,
    required this.prescription,
    required this.notes,
    required this.nextMeetingDate,
    required this.recordDate,
    required this.recordType,
    required this.petId,
    required this.userId,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] ?? 0,
      diagnosis: json['diagnosis'] ?? '',
      prescription: json['prescription'] ?? '',
      notes: json['notes'] ?? '',
      nextMeetingDate: json['next_meeting_date'] ?? '',
      recordDate: json['record_date'] ?? '',
      recordType: json['record_type'] ?? 'CHECKUP',
      petId: json['pet_id'] ?? 0,
      userId: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diagnosis': diagnosis,
      'prescription': prescription,
      'notes': notes,
      'next_meeting_date': nextMeetingDate,
      'record_date': recordDate,
      'record_type': recordType,
      'pet_id': petId,
      'user_id': userId,
    };
  }

  MedicalRecord copyWith({
    int? id,
    String? diagnosis,
    String? prescription,
    String? notes,
    String? nextMeetingDate,
    String? recordDate,
    String? recordType,
    int? petId,
    int? userId,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      diagnosis: diagnosis ?? this.diagnosis,
      prescription: prescription ?? this.prescription,
      notes: notes ?? this.notes,
      nextMeetingDate: nextMeetingDate ?? this.nextMeetingDate,
      recordDate: recordDate ?? this.recordDate,
      recordType: recordType ?? this.recordType,
      petId: petId ?? this.petId,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'MedicalRecord{id: $id, diagnosis: $diagnosis, prescription: $prescription, notes: $notes, nextMeetingDate: $nextMeetingDate, recordDate: $recordDate, recordType: $recordType, petId: $petId, userId: $userId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalRecord &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          diagnosis == other.diagnosis &&
          prescription == other.prescription &&
          notes == other.notes &&
          nextMeetingDate == other.nextMeetingDate &&
          recordDate == other.recordDate &&
          recordType == other.recordType &&
          petId == other.petId &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      diagnosis.hashCode ^
      prescription.hashCode ^
      notes.hashCode ^
      nextMeetingDate.hashCode ^
      recordDate.hashCode ^
      recordType.hashCode ^
      petId.hashCode ^
      userId.hashCode;
}

class MedicalRecordCreate {
  final String diagnosis;
  final String prescription;
  final String notes;
  final String nextMeetingDate;
  final String recordType;
  final int petId;
  final int userId;

  MedicalRecordCreate({
    required this.diagnosis,
    required this.prescription,
    required this.notes,
    required this.nextMeetingDate,
    required this.recordType,
    required this.petId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'diagnosis': diagnosis,
      'prescription': prescription,
      'notes': notes,
      'next_meeting_date': nextMeetingDate,
      'record_type': recordType,
      'pet_id': petId,
      'user_id': userId,
    };
  }
}

class MedicalRecordUpdate {
  final String diagnosis;
  final String prescription;
  final String notes;
  final String nextMeetingDate;
  final String recordType;

  MedicalRecordUpdate({
    required this.diagnosis,
    required this.prescription,
    required this.notes,
    required this.nextMeetingDate,
    required this.recordType,
  });

  Map<String, dynamic> toJson() {
    return {
      'diagnosis': diagnosis,
      'prescription': prescription,
      'notes': notes,
      'next_meeting_date': nextMeetingDate,
      'record_type': recordType,
    };
  }
} 