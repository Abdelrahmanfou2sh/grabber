part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object> get props => [message];
}

class SavedCardsLoaded extends PaymentState {
  final List<PaymentModel> cards;

  const SavedCardsLoaded(this.cards);

  @override
  List<Object> get props => [cards];
}
