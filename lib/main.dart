import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/ui/screens/home.dart';
import 'package:shop/providers/Product.dart';
import 'package:shop/providers/Cart.dart';
import 'package:shop/providers/Order.dart';
import 'package:shop/ui/screens/add_product.dart';
import 'package:shop/ui/screens/product_list.dart';
import 'package:shop/services/database_helper.dart';
import 'package:shop/ui/screens/HomePage.dart';
import 'package:shop/ui/screens/order_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseHelper = DatabaseHelper();
  final db = await databaseHelper.database;

  // Sélectionnez les noms de toutes les tables de la base de données
  List<Map<String, dynamic>> tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');

  // Parcourez chaque table
  for (var table in tables) {
    String tableName = table['name'];
    print('Table: $tableName');

    // Sélectionnez toutes les lignes de la table actuelle
    List<Map<String, dynamic>> rows = await db.rawQuery('SELECT * FROM $tableName');
    
    // Affichez les données de chaque ligne
    for (var row in rows) {
      print(row);
    }
    print('\n');
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()), 
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AdminHomePage(),
          '/AddProductPage': (context) => AddProductPage(),
          '/ProductListPage': (context) => ProductListPage(),
          '/HomePage': (context) => const HomePage(),
          '/OrdersPage': (context) => const OrdersPage(),
        },
      ),
    );
  }
}
