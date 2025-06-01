class User {
  final int id;
  final String userName;
  final String email;
  final String phone;
  final String roles;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.phone,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      roles: json['roles'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'email': email,
      'phone': phone,
      'roles': roles,
    };
  }

  User copyWith({
    int? id,
    String? userName,
    String? email,
    String? phone,
    String? roles,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      roles: roles ?? this.roles,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, userName: $userName, email: $email, phone: $phone, roles: $roles}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userName == other.userName &&
          email == other.email &&
          phone == other.phone &&
          roles == other.roles;

  @override
  int get hashCode =>
      id.hashCode ^
      userName.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      roles.hashCode;
}

class UserRole {
  final int id;
  final String roles;

  UserRole({
    required this.id,
    required this.roles,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'] ?? 0,
      roles: json['roles'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roles': roles,
    };
  }
}

class UserRegistration {
  final String userName;
  final String email;
  final String phone;
  final String password;

  UserRegistration({
    required this.userName,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}

class UserUpdate {
  final String userName;
  final String email;
  final String phone;

  UserUpdate({
    required this.userName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'email': email,
      'phone': phone,
    };
  }
} 