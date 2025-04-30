import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final FirebaseFirestore _firestore;

  PaymentRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveCard(PaymentModel payment) async {
    try {
      await _firestore.collection('payments').add(payment.toMap());
    } catch (e) {
      throw Exception('Failed to save card data');
    }
  }

  Future<List<PaymentModel>> getSavedCards(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('payments')
              .where('userId', isEqualTo: userId)
              .where('isSaved', isEqualTo: true)
              .get();

      return snapshot.docs
          .map((doc) => PaymentModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to retrieve saved cards');
    }
  }

  Future<void> deleteCard(String cardId) async {
    try {
      await _firestore.collection('payments').doc(cardId).delete();
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
