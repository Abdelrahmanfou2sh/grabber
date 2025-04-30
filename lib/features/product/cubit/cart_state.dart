part of 'cart_cubit.dart';

class CartState extends Equatable {
  final List<Product> cart;
  final double totalPrice;
  const CartState({required this.cart, required this.totalPrice});
  @override
  List<Object?> get props => [cart, totalPrice];
}
