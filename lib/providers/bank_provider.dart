import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../models/transaction_model.dart';

class BankProvider with ChangeNotifier {
  // Mock Data: Cards
  List<CardModel> cards = [
    CardModel(
      id: 'c1',
      cardNumber: '5432 1098 7654 3466',
      cardHolder: 'Tayyab Sohail',
      validDate: '12 / 02 / 2024',
      cvv: '663',
      isPhysical: true,
      balance: 1200.0,
      spendings: 1200.0,
    ),
    CardModel(
      id: 'c2',
      cardNumber: '4000 1234 5678 9010',
      cardHolder: 'Tayyab Sohail',
      validDate: '08 / 05 / 2025',
      cvv: '123',
      isPhysical: true,
      balance: 450.0,
      spendings: 300.0,
    ),
    CardModel(
      id: 'c3',
      cardNumber: '4111 2222 3333 4444',
      cardHolder: 'Tayyab Sohail',
      validDate: '01 / 11 / 2026',
      cvv: '999',
      isPhysical: false,
      balance: 2100.0,
      spendings: 85.0,
    ),
  ];

  // Mock Data: Transactions
  List<TransactionModel> transactions = [
    TransactionModel(
      id: 't1',
      cardId: 'c1',
      title: 'Online Shopping',
      time: '12:10 pm',
      date: '12-12-2024',
      amount: 100.0,
      isIncome: false,
      iconSvg: 'online_shopping',
    ),
    TransactionModel(
      id: 't2',
      cardId: 'c1',
      title: 'E wallet',
      time: '12:10 pm',
      date: '12-12-2024',
      amount: 100.0,
      isIncome: true,
      iconSvg: 'e_wallet',
    ),
    TransactionModel(
      id: 't3',
      cardId: 'c1',
      title: 'Online Shopping',
      time: '10:05 am',
      date: '11-12-2024',
      amount: 50.0,
      isIncome: false,
      iconSvg: 'online_shopping',
    ),
    TransactionModel(
      id: 't4',
      cardId: 'c2',
      title: 'Grocery Store',
      time: '04:30 pm',
      date: '10-12-2024',
      amount: 85.0,
      isIncome: false,
      iconSvg: 'grocery',
    ),
  ];

  // State
  int selectedCardIndex = 0;
  bool isPhysicalView = true;
  bool appNotificationEnabled = true;

  // Chart State
  int selectedChartIndex = 1; // Default to Feb
  List<double> chartData = [800, 3657, 1200, 2500, 2000, 4200];
  List<String> chartLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  String chartFilter = 'Weekly';

  // Getters
  List<CardModel> get filteredCards =>
      cards.where((c) => c.isPhysical == isPhysicalView).toList();

  CardModel? get activeCard {
    final filtered = filteredCards;
    if (filtered.isEmpty) return null;
    if (selectedCardIndex >= filtered.length) {
      selectedCardIndex = filtered.length - 1;
    }
    return filtered[selectedCardIndex];
  }

  List<TransactionModel> get activeCardTransactions {
    final card = activeCard;
    if (card == null) return [];
    return transactions.where((t) => t.cardId == card.id).toList();
  }

  double get activeChartValue => chartData[selectedChartIndex];

  // Actions
  void setPhysicalView(bool isPhysical) {
    isPhysicalView = isPhysical;
    selectedCardIndex = 0;
    notifyListeners();
  }

  void setActiveCardIndex(int index) {
    if (index >= 0 && index < filteredCards.length) {
      selectedCardIndex = index;
      notifyListeners();
    }
  }

  void toggleCardFreeze() {
    final card = activeCard;
    if (card != null) {
      card.isFrozen = !card.isFrozen;
      notifyListeners();
    }
  }

  void toggleCardReveal() {
    final card = activeCard;
    if (card != null) {
      card.isRevealed = !card.isRevealed;
      notifyListeners();
    }
  }

  void toggleAppNotification(bool val) {
    appNotificationEnabled = val;
    notifyListeners();
  }

  void updateCardSetting(String setting, bool value) {
    final card = activeCard;
    if (card != null) {
      switch (setting) {
        case 'pinChanged':
          card.pinChanged = value;
          break;
        case 'qrPaymentEnabled':
          card.qrPaymentEnabled = value;
          break;
        case 'onlineShoppingEnabled':
          card.onlineShoppingEnabled = value;
          break;
        case 'tapPayEnabled':
          card.tapPayEnabled = value;
          break;
      }
      notifyListeners();
    }
  }

  void selectChartPoint(int index) {
    if (index >= 0 && index < chartData.length) {
      selectedChartIndex = index;
      notifyListeners();
    }
  }

  void setChartFilter(String filter) {
    chartFilter = filter;
    // Mock updating chart data based on filter
    if (filter == 'Weekly') {
      chartData = [800, 3657, 1200, 2500, 2000, 4200];
    } else if (filter == 'Monthly') {
      chartData = [5000, 12000, 8000, 15000, 11000, 20000];
    } else if (filter == 'Today') {
      chartData = [10, 50, 20, 100, 15, 80];
    } else {
      chartData = [50000, 120000, 80000, 150000, 110000, 200000];
    }
    selectedChartIndex = 1;
    notifyListeners();
  }

  void addMockTransfer(double amount) {
    transactions.insert(
      0,
      TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardId: activeCard?.id ?? 'c1',
        title: 'Recent Transfer',
        time: 'Just now',
        date: 'Today',
        amount: amount,
        isIncome: false,
        iconSvg: 'transfer',
      ),
    );
    chartData[selectedChartIndex] += amount;
    notifyListeners();
  }
}
