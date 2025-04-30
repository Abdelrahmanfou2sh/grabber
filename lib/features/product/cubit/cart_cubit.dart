import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/product_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState(cart: [], totalPrice: 0));

  List<Product> get cart => state.cart;

  void toggleCart(Product product) {
    final currentCart = List<Product>.from(state.cart);
    if (currentCart.contains(product)) {
      currentCart.remove(product);
    } else {
      currentCart.add(product);
    }
    _emitCart(currentCart);
  }

  void addToCart(Product product) {
    final currentCart = List<Product>.from(state.cart);
    if (!currentCart.contains(product)) {
      currentCart.add(product);
      _emitCart(currentCart);
    }
  }

  void removeFromCart(Product product) {
    final currentCart = List<Product>.from(state.cart);
    if (currentCart.contains(product)) {
      currentCart.remove(product);
      _emitCart(currentCart);
    }
  }

  void clearCart() {
    _emitCart([]);
  }

  bool isInCart(Product product) => state.cart.contains(product);

  void _emitCart(List<Product> updatedCart) {
    emit(
      CartState(cart: updatedCart, totalPrice: _calculateTotal(updatedCart)),
    );
  }

  double _calculateTotal(List<Product> cart) {
    return cart.fold(
      0.0,
      (total, product) => total + (product.discountPrice ?? product.price),
    );
  }
}
