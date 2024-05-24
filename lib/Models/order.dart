import 'package:shop/Models/cart.dart';

class Order {
  final String id;
  final List<Cart> cart;
  final double total;
  final String paymentMethod;

  Order({
    required this.id,
    required this.cart,
    required this.total,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cartId': cart.first.id, 
      'total': total,
      'paymentMethod': paymentMethod,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, List<Cart> cart) {
    return Order(
      id: map['id'],
      cart: cart,
      total: map['total'],
      paymentMethod: map['paymentMethod'],
    );
  }
}
