import 'package:flutter/material.dart';
import 'package:shop/Models/cart.dart';
import 'package:shop/Models/order.dart';
import 'package:shop/providers/Order.dart';
import 'package:shop/services/database_helper.dart'; 

class CartProvider with ChangeNotifier {
  final List<Cart> _carts = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Instance de DatabaseHelper

  List<Cart> get carts => _carts;

  // Méthode pour vider le panier
  void clearCart() {
    _carts.clear();
    notifyListeners();
  }


  Future<void> addItemToCart(Cart cart) async {
    _carts.add(cart);
    notifyListeners();
    await _databaseHelper.insertCart(cart); // Enregistrement du cart dans la base de données
  }

  Future<void> removeItemFromCart(Cart cart) async {
    _carts.remove(cart);
    notifyListeners();
    await _databaseHelper.deleteCart(cart); 
  }

  void decreaseItemQuantity(Cart cart) {
    if (cart.quantity > 1) {
      cart.quantity--;
      notifyListeners();
      _databaseHelper.updateCart(cart); // Mise à jour du cart dans la base de données
    }
  }

  void increaseItemQuantity(Cart cart) {
    cart.quantity++;
    notifyListeners();
    _databaseHelper.updateCart(cart); // Mise à jour du cart dans la base de données
  }

  double get totalPrice {
    return _carts.fold(0, (sum, cart) => sum + cart.product.price * cart.quantity);
  }

  Future<bool> placeOrder(String paymentMethod, OrderProvider orderProvider) async {
    try {
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cart: _carts,  
        total: totalPrice,
        paymentMethod: paymentMethod,
      );

      // Ajouter la commande au OrderProvider
      orderProvider.addOrder(order);

      // Enregistrer la commande dans la base de données
      await _databaseHelper.insertOrder(order);

      // Vider le panier après l'enregistrement de la commande
      _carts.clear();
      notifyListeners();

      return true; // Indiquer que la commande a été passée avec succès
    } catch (error) {
      return false; // Indiquer que la commande a échoué
    }
  }
}
