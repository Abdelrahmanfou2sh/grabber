import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/payment_model.dart';
import '../repositories/payment_repository.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _repository;

  PaymentCubit({required PaymentRepository repository})
    : _repository = repository,
      super(PaymentInitial());

  Future<void> processPayment(PaymentModel payment) async {
    emit(PaymentLoading());
    try {
      final success = await _repository.processPayment(payment);
      if (success) {
        if (payment.isSaved) {
          await _repository.saveCard(payment);
        }
        emit(PaymentSuccess());
      } else {
        emit(
          const PaymentFailure('Payment processing failed. Please try again.'),
        );
      }
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> loadSavedCards(String userId) async {
    emit(PaymentLoading());
    try {
      final cards = await _repository.getSavedCards(userId);
      emit(SavedCardsLoaded(cards));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> deleteCard(String cardId) async {
    try {
      await _repository.deleteCard(cardId);
      final currentState = state;
      if (currentState is SavedCardsLoaded) {
        final updatedCards =
            currentState.cards.where((card) => card.id != cardId).toList();
        emit(SavedCardsLoaded(updatedCards));
      }
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  bool validateLuhn(String cardNumber) {
    int sum = 0;
    bool alternate = false;
    String numbers = cardNumber.replaceAll(' ', '');

    for (int i = numbers.length - 1; i >= 0; i--) {
      int n = int.parse(numbers[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }
}
