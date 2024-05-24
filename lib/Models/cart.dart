import 'package:shop/Models/product.dart';

class Cart {
  final int? id; 
  int quantity;
  final String size;
  final String color;
  final Product product; 

  Cart({
    required this.id,
    required this.quantity,
    required this.size,
    required this.color,
    required this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'size': size,
      'color': color,
      'productId': product.id,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map, Product product) {
    return Cart(
      id: map['id'],
      quantity: map['quantity'],
      size: map['size'],
      color: map['color'],
      product: product,
    );
  }
}
