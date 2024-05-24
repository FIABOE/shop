import 'package:flutter/material.dart';
import 'package:shop/Models/order.dart';
import 'package:shop/services/database_helper.dart'; // Importez votre classe DatabaseHelper

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Instance de votre classe DatabaseHelper

  List<Order> get orders => _orders;

  // Méthode pour charger les commandes depuis la base de données
  Future<void> fetchOrders() async {
    try {
      final List<Order> loadedOrders = await _databaseHelper.getOrders(); // Utilisez la méthode de votre DatabaseHelper
      _orders.clear();
      _orders.addAll(loadedOrders);
      notifyListeners();
    } catch (error) {
      print('Error fetching orders: $error');
      // Gérer l'erreur de chargement des commandes depuis la base de données
    }
  }

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }
}
