import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Product.dart';
import 'package:shop/Models/product.dart';
import 'package:shop/ui/screens/detail_produit.dart';
import 'dart:io'; 


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  String selectedCategory = 'Tout'; 

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;
    final filteredProducts = selectedCategory == 'Tout'
        ? products
        : products.where((product) => product.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 148, 168),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.store, color: Colors.white),
              onPressed: () {
              },
            ),
            const Text(
              "SikaShop",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
            onPressed: () {
        
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        margin: const EdgeInsets.only(top: 100.0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 230, 227, 227),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 3, 136, 156),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Trouver un produit...',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Découvrez nos meilleurs produits',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      buildCategoryButton('Tout'),
                      const SizedBox(width: 10),
                      buildCategoryButton('Homme'),
                      const SizedBox(width: 10),
                      buildCategoryButton('Femme'),
                      const SizedBox(width: 10),
                      buildCategoryButton('Enfant'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: List.generate(
                        filteredProducts.length,
                        (index) => SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          child: ProductCard(
                            product: filteredProducts[index],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        color: const Color.fromARGB(255, 17, 148, 168),
        backgroundColor: Colors.white,
        items: const <Widget>[
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.shopping_cart, color: Colors.white),
          Icon(Icons.menu, color: Colors.white),
        ],
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget buildCategoryButton(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          return selectedCategory == category ? const Color.fromARGB(255, 242, 117, 64) : Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: selectedCategory == category ? const Color.fromARGB(255, 238, 247, 238) : Colors.indigo,
              width: 1.0,
            ),
          ),
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: selectedCategory == category ? Colors.white : Colors.indigo,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
    
        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailProduit(
      product: product, 
      imagePath: product.imageUrl, 
    ),
  ),
);

      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                
              },
              icon: const Icon(
                Icons.favorite_border, 
                color: Colors.red, 
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(
                    File(product.imageUrl),
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 4, 88, 67),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Prix : ',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 7, 104, 95),
                          ),
                        ),
                        TextSpan(
                          text: '${product.price} FCF',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
