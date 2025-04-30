import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/order_repository.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  OrderCubit(this._orderRepository) : super(OrderInitial());

  void getOrders({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required String paymentMethod,
    required String deliveryOption,
  }) async {
    emit(OrderLoading());
    try {
      await _orderRepository.placeOrder(
        products: products,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        deliveryOption: deliveryOption,
      );
      emit(OrderSuccess());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
