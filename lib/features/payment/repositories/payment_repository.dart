import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final SharedPreferences _prefs;

  PaymentRepository(this._prefs);

  Future<void> saveCard(PaymentModel payment) async {
    try {
      final cards = await getSavedCards(payment.userId);
      cards.add(payment);
      final cardsJson = cards.map((card) => card.toMap()).toList();
      await _prefs.setString('payments_${payment.userId}', jsonEncode(cardsJson));
    } catch (e) {
      throw Exception('Failed to save card data');
    }
  }

  Future<List<PaymentModel>> getSavedCards(String userId) async {
    try {
      final cardsJson = _prefs.getString('payments_$userId');
      if (cardsJson == null) return [];
      
      final List<dynamic> cardsList = jsonDecode(cardsJson);
      return cardsList
          .map((card) => PaymentModel.fromMap(card as Map<String, dynamic>, card['id'] ?? ''))
          .where((card) => card.isSaved)
          .toList();
    } catch (e) {
      throw Exception('Failed to retrieve saved cards');
    }
  }

  Future<void> deleteCard(String cardId) async {
    try {
      final userId = (await getSavedCards('')).firstWhere((card) => card.id == cardId).userId;
      final cards = await getSavedCards(userId);
      cards.removeWhere((card) => card.id == cardId);
      final cardsJson = cards.map((card) => card.toMap()).toList();
      await _prefs.setString('payments_$userId', jsonEncode(cardsJson));
    } catch (e) {
      throw Exception('Failed to delete card');
    }
  }

  Future<bool> processPayment(PaymentModel payment) async {
    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      throw Exception('Failed to process payment');
    }
  }
}
