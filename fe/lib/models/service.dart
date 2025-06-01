class Service {
  final int id;
  final String serviceName;
  final String category;
  final String description;
  final double price;

  Service({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.description,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      serviceName: json['service_name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_name': serviceName,
      'category': category,
      'description': description,
      'price': price,
    };
  }

  Service copyWith({
    int? id,
    String? serviceName,
    String? category,
    String? description,
    double? price,
  }) {
    return Service(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'Service{id: $id, serviceName: $serviceName, category: $category, description: $description, price: $price}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          serviceName == other.serviceName &&
          category == other.category &&
          description == other.description &&
          price == other.price;

  @override
  int get hashCode =>
      id.hashCode ^
      serviceName.hashCode ^
      category.hashCode ^
      description.hashCode ^
      price.hashCode;
}

class ServiceCreate {
  final String serviceName;
  final String category;
  final String description;
  final double price;

  ServiceCreate({
    required this.serviceName,
    required this.category,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'category': category,
      'description': description,
      'price': price,
    };
  }
}

class ServiceUpdate {
  final String serviceName;
  final String category;
  final String description;
  final double price;

  ServiceUpdate({
    required this.serviceName,
    required this.category,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'category': category,
      'description': description,
      'price': price,
    };
  }
} 