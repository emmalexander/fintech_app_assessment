class TransactionModel {
  final String id;
  final String cardId;
  final String title;
  final String time;
  final String date;
  final double amount;
  final bool isIncome;
  final String iconSvg;

  TransactionModel({
    required this.id,
    required this.cardId,
    required this.title,
    required this.time,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.iconSvg,
  });
}
