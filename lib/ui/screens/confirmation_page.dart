import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Cart.dart';
//import 'package:shop/providers/Order.dart';
import 'package:shop/Models/order.dart';
import 'package:shop/Models/cart.dart';
import 'package:shop/services/database_helper.dart';

class ConfirmPage extends StatefulWidget {
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {

  final addressController = TextEditingController();
  String? selectedPaymentMethod;

  final List<String> paymentMethods = [
    'Virement bancaire',
    'Paiement à la livraison'
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final carts = cartProvider.carts;
    final totalPrice = cartProvider.totalPrice;
    final databaseHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 17, 148, 168),
        title: const Text(
          'Confimer votre commande',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
  child: ListView.builder(
    itemCount: carts.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 2.0,
          child: ListTile(
            title: Text(
              carts[index].product.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
              'Quantité: ${carts[index].quantity} - Prix: ${carts[index].product.price * carts[index].quantity} FCF',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700], 
              ),
            ),
          ),
        ),
      );
    },
  ),
),
 const SizedBox(height: 20),
            DropdownButtonFormField<String>(
  decoration: InputDecoration(
    labelText: 'Méthode de paiement',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.blue),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  ),
  value: selectedPaymentMethod,
  items: paymentMethods.map((method) {
    return DropdownMenuItem(
      value: method,
      child: Text(
        method,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedPaymentMethod = value;
    });
  },
),

            const SizedBox(height: 20),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Prix total: ',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black, 
        ),
      ),
      TextSpan(
        text: '$totalPrice FCF',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue, 
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 20),
            ElevatedButton(
  onPressed: () {
    placeOrder(databaseHelper, cartProvider);
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 17, 148, 168),
  ),
  child: const Text(
    'Confirmer la commande',
    style: TextStyle(
      color: Colors.white, 
    ),
  ),
),

          ],
        ),
      ),
    );
  }

  void placeOrder(DatabaseHelper databaseHelper, CartProvider cartProvider) {
  if (selectedPaymentMethod != null) {
    final List<Cart> carts = cartProvider.carts; 
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cart: carts, 
      total: cartProvider.totalPrice, 
      paymentMethod: selectedPaymentMethod!,
    );
    databaseHelper.insertOrder(order).then((orderId) {
      // ignore: unnecessary_null_comparison
      if (orderId != null) {
        // Commande réussie
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Succès'),
            content: const Text('Commande passée avec succès!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                  Navigator.of(context).pop(); 
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        cartProvider.clearCart(); 
      } else {
        // Échec de la commande
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Échec'),
            content: const Text('La commande n\'a pas pu être passée. Veuillez réessayer.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez sélectionner une méthode de paiement')),
    );
  }
}


  Widget buildCartItem(BuildContext context, Cart cart) {
    return ListTile(
      title: Text(cart.product.name),
      subtitle: Text('Quantité: ${cart.quantity} - Prix: ${cart.product.price * cart.quantity} FCF'),
    );
  }
}
