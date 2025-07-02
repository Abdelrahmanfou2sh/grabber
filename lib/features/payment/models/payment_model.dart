class PaymentModel {
  final String? id;
  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final String cardType;
  final bool isSaved;
  final String userId;
  final DateTime createdAt;

  PaymentModel({
    this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.cardType,
    required this.isSaved,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvc': cvc,
      'cardType': cardType,
      'isSaved': isSaved,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map, String id) {
    return PaymentModel(
      id: id,
      cardNumber: map['cardNumber'] as String,
      expiryDate: map['expiryDate'] as String,
      cvc: map['cvc'] as String,
      cardType: map['cardType'] as String,
      isSaved: map['isSaved'] as bool,
      userId: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  PaymentModel copyWith({
    String? id,
    String? cardNumber,
    String? expiryDate,
    String? cvc,
    String? cardType,
    bool? isSaved,
    String? userId,
    DateTime? createdAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvc: cvc ?? this.cvc,
      cardType: cardType ?? this.cardType,
      isSaved: isSaved ?? this.isSaved,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
