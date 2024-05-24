import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:shop/ui/screens/add_product.dart';
// ignore: unused_import
import 'package:shop/ui/screens/home.dart';
// ignore: unused_import
import 'package:shop/ui/screens/order_page.dart';
// ignore: unused_import
import 'package:shop/ui/screens/product_list.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text(
                'Admin',
                style: TextStyle(
                  fontWeight: FontWeight.
                  bold, fontSize: 18,
                ),
              ),
              accountEmail: Text('admin@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 24, 
                    color: Colors.teal,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.teal),
              title: const Text('Ajouter Produit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pushNamed(context, '/AddProductPage');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.teal),
              title: const Text('Liste des produits',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pushNamed(context, '/ProductListPage');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.list_alt, color: Colors.teal),
              title: const Text('Liste des commandes',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600)
                  ),
              onTap: () {
                Navigator.pushNamed(context, '/OrdersPage');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.face, color: Colors.teal),
              title: const Text('Client',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600)
                  ),
              onTap: () {
                Navigator.pushNamed(context, '/HomePage');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal),
              title: const Text('Déconnexion',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600)
                  ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(), 
                shrinkWrap: true, 
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: <Widget>[
                  _buildStatisticCard(
                    title: 'Total Produits',
                    value: '', 
                    icon: Icons.shopping_bag,
                  ),
                   _buildStatisticCard(
                     title: 'Total commandes',
                      value: '', 
                       icon: Icons.point_of_sale,
                      ),
                    ],
              ),
        const SizedBox(height: 20), 
      ],
    ),
  ),
),



    );
  }

  Widget _buildStatisticCard(
      {required String title, required String value, required IconData icon}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.teal),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
