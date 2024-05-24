import 'package:flutter/material.dart';
import 'package:shop/services/database_helper.dart';
import 'package:shop/Models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  Product? _selectedProduct; 

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;

  Future<void> fetchAndSetProducts() async {
    _products = await DatabaseHelper().getProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.insertProduct(product);
    await fetchAndSetProducts(); 
  }

  Future<void> updateProduct(Product product) async {
    await DatabaseHelper().updateProduct(product);
    await fetchAndSetProducts();
  }

  Future<void> deleteProduct(int id) async {
    await DatabaseHelper().deleteProduct(id);
    await fetchAndSetProducts();
  }

  int _quantity = 1;
  double _totalPrice = 0.0;

  int get quantity => _quantity;
  double get totalPrice => _totalPrice;

  void updateQuantity(Product product, int newQuantity) {
    _selectedProduct = product; 
    _quantity = newQuantity;
    _updateTotalPrice();
    notifyListeners();
  }

  void _updateTotalPrice() {
    if (_selectedProduct != null) {
      _totalPrice = _quantity * _selectedProduct!.price;
    }
  }
}
