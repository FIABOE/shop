import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Order.dart';
import 'package:shop/Models/order.dart';
import 'package:shop/Models/cart.dart';
import 'package:shop/services/database_helper.dart'; 

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 148, 168),
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
        title: const Text(
          'Liste des commandes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return buildOrderItem(context, orders[index]);
        },
      ),
    );
  }

  Widget buildOrderItem(BuildContext context, Order order) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.grey[200], 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'Commande #${order.id}',
              style: const TextStyle(
                fontWeight: FontWeight.bold, // Texte en gras
                color: Colors.black, // Couleur du texte
              ),
            ),
            subtitle: Text(
              'Méthode de paiement: ${order.paymentMethod}\nTotal: ${order.total} FCF',
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () {
                _showOrderDetails(context, order);
              },
              color: Colors.blue,
            ),
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                 
                },
                child: const Text(
                  'Commande traitée',
                  style: TextStyle(
                    color: Colors.white, 
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 12, 121, 116), 
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  
                },
                child: const Text(
                  'Commande livrée',
                  style: TextStyle(
                    color: Colors.white, 
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 218, 97, 97), 
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) async {
    if (order.cart.isNotEmpty) {
      List<Cart> orderDetails = await DatabaseHelper()
          .getOrderDetails(order.cart.first.id.toString());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Détails de la commande #${order.id}'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: orderDetails.map((item) {
                return ListTile(
                  leading: Image.asset(item.product.imageUrl),
                  title: Text(item.product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Taille: ${item.size}'),
                      Text('Quantité: ${item.quantity} pcs'),
                      
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
    } else {
      
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Le panier pour cette commande est vide.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
