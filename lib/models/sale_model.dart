class SaleModel {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final DateTime createdAt;

  SaleModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.createdAt,
  });

  // ================= COPY =================
  SaleModel copyWith({
    String? id,
    String? productId,
    String? productName,
    int? quantity,
    double? price,
    DateTime? createdAt,
  }) {
    return SaleModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ================= SERIALIZATION =================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
