import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addItem(CartItem item) {
    // Check if item with same ID and variant exists
    final index = state.indexWhere((element) => element.id == item.id && element.variant == item.variant);
    
    if (index >= 0) {
      // Update quantity
      final existingItem = state[index];
      state = [
        ...state.sublist(0, index),
        existingItem.copyWith(quantity: existingItem.quantity + item.quantity),
        ...state.sublist(index + 1),
      ];
    } else {
      // Add new item
      state = [...state, item];
    }
  }

  void removeItem(String id, String variant) {
    state = state.where((item) => !(item.id == id && item.variant == variant)).toList();
  }

  void updateQuantity(String id, String variant, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(id, variant);
      return;
    }

    final index = state.indexWhere((element) => element.id == id && element.variant == variant);
    if (index >= 0) {
      final existingItem = state[index];
      state = [
        ...state.sublist(0, index),
        existingItem.copyWith(quantity: newQuantity),
        ...state.sublist(index + 1),
      ];
    }
  }

  void clearCart() {
    state = [];
  }

  double get subtotal {
    return state.fold(0, (total, item) => total + (item.price * item.quantity));
  }

  int get itemCount {
    return state.fold(0, (count, item) => count + item.quantity);
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
