import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Models/cart.dart';
import 'package:shop/providers/Cart.dart';
import 'package:shop/ui/screens/cart.dart';
import 'package:shop/Models/product.dart'; 
import 'dart:io';

class DetailProduit extends StatefulWidget {
  final Product product;
  final String imagePath;

  const DetailProduit({Key? key, required this.product, required this.imagePath}) : super(key: key);

  @override
  _DetailProduitState createState() => _DetailProduitState();
}

class _DetailProduitState extends State<DetailProduit> {
  int quantity = 1;
  String selectedSize = 'M';
  String selectedColor = 'Bleu';

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'Bleu':
        return Colors.blue;
      case 'Rouge':
        return Colors.red;
      case 'Noir':
        return Colors.black;
      case 'Jaune':
        return Colors.yellow;
      case 'Vert':
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Détails du Produit',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20.0),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '   Total : ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 9, 128, 92),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 2, 111, 121),
                        ),
                        child: Center(
                          child: IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              });
                            },
                            color: const Color.fromARGB(255, 249, 249, 249),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 245, 135, 18),
                        ),
                        child: Center(
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 2, 111, 121),
                        ),
                        child: Center(
                          child: IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Taille
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '   Taille : ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 9, 128, 92),
                      ),
                    ),
                    SizedBox(height: 20),
                    const Text(
                      '   Couleur : ', 
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 9, 128, 92),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: selectedSize,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSize = newValue!;
                        });
                      },
                      items: <String>['S', 'M', 'L', 'XL']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedColor,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedColor = newValue!;
                        });
                      },
                      items: <String>['Bleu', 'Rouge', 'Noir', 'Jaune', 'Vert']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getColor(value),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomAppBar(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
Text(
  'Total :',
  style: TextStyle(
    fontSize: 
18.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: '${widget.product.price * quantity} FCF', 
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),


ElevatedButton.icon(
  onPressed: () async {
    // Nouvel objet Cart 
    Cart cart = Cart(
      id: widget.product.id,
      quantity: quantity,
      size: selectedSize,
      color: selectedColor,
      product: widget.product,
    );

    // Ajout de la nouvel objet au panier 
    Provider.of<CartProvider>(context, listen: false).addItemToCart(cart);

    // Affichage d'un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produit ajouté au panier'),
        duration: Duration(seconds: 2),
      ),
    );

    // Naviguer vers la page du panier
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage()), 
    );
  },
  icon: Icon(Icons.add_shopping_cart),
  label: Text(
    'Ajouter',
    style: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 17, 148, 168),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ).copyWith(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
