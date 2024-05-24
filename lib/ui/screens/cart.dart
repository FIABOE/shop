import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Cart.dart';
import 'package:shop/Models/cart.dart';
import 'package:shop/ui/screens/confirmation_page.dart';
import 'dart:io';


class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final carts = cartProvider.carts;
    final totalPrice = cartProvider.totalPrice;

    return Scaffold(
      appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 17, 148, 168),
        title: const Text(
          'Panier',
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: carts.length,
              itemBuilder: (context, index) {
                return buildCartItem(context, carts[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
  'Prix total: ',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 1, 46, 44), 
  ),
),
Text(
  '$totalPrice FCF',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue, 
  ),
),


                ElevatedButton.icon(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ConfirmPage()),
    );
  },
  icon: const Icon(Icons.shopping_cart, color: Colors.white), 
  label: const Text('Acheter', style: TextStyle(color: Colors.white)), 
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 17, 148, 168), 
  ),
),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCartItem(BuildContext context, Cart cart) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24.0,
            ),
            const SizedBox(width: 8),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(File(cart.product.imageUrl)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cart.product.name,
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  onPressed: () {
                    showProductDetailsDialog(context, cart);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false).removeItemFromCart(cart);
                  },
                ),
              ],
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${cart.product.price} FCF',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 231, 223, 223),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.remove, color: Color.fromARGB(255, 28, 10, 10), size: 18),
                    onPressed: () {
                      if (cart.quantity > 1) {
                        Provider.of<CartProvider>(context, listen: false).decreaseItemQuantity(cart);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  child: Text(
                    '${cart.quantity}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 231, 223, 223),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.add, color: Color.fromARGB(255, 23, 22, 22), size: 18),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).increaseItemQuantity(cart);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showProductDetailsDialog(BuildContext context, Cart cart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(cart.product.name),
          content: Column(
           
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(File(cart.product.imageUrl)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text('Taille: ${cart.size}'),
              Text('Couleur: ${cart.color}'),
              Text('Prix total: ${cart.product.price * cart.quantity} FCF'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
