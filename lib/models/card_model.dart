class CardModel {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String validDate;
  final String cvv;
  final bool isPhysical;
  bool isFrozen;
  bool isRevealed;
  bool pinChanged;
  bool qrPaymentEnabled;
  bool onlineShoppingEnabled;
  bool tapPayEnabled;
  double balance;
  double spendings;

  CardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.validDate,
    required this.cvv,
    required this.isPhysical,
    this.isFrozen = false,
    this.isRevealed = false,
    this.pinChanged = true,
    this.qrPaymentEnabled = true,
    this.onlineShoppingEnabled = true,
    this.tapPayEnabled = true,
    this.balance = 0.0,
    this.spendings = 0.0,
  });

  CardModel copyWith({
    String? id,
    String? cardNumber,
    String? cardHolder,
    String? validDate,
    String? cvv,
    bool? isPhysical,
    bool? isFrozen,
    bool? isRevealed,
    bool? pinChanged,
    bool? qrPaymentEnabled,
    bool? onlineShoppingEnabled,
    bool? tapPayEnabled,
    double? balance,
    double? spendings,
  }) {
    return CardModel(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolder: cardHolder ?? this.cardHolder,
      validDate: validDate ?? this.validDate,
      cvv: cvv ?? this.cvv,
      isPhysical: isPhysical ?? this.isPhysical,
      isFrozen: isFrozen ?? this.isFrozen,
      isRevealed: isRevealed ?? this.isRevealed,
      pinChanged: pinChanged ?? this.pinChanged,
      qrPaymentEnabled: qrPaymentEnabled ?? this.qrPaymentEnabled,
      onlineShoppingEnabled:
          onlineShoppingEnabled ?? this.onlineShoppingEnabled,
      tapPayEnabled: tapPayEnabled ?? this.tapPayEnabled,
      balance: balance ?? this.balance,
      spendings: spendings ?? this.spendings,
    );
  }
}
