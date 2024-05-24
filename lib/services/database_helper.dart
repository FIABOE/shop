import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shop/Models/product.dart';
import 'package:shop/Models/cart.dart';
import 'package:shop/Models/order.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'myShop.db');
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        description TEXT,
        imageUrl TEXT,
        category TEXT,
        sizes TEXT,
        colors TEXT,
        quantity INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        quantity INTEGER,
        size TEXT,
        color TEXT,
        FOREIGN KEY (productId) REFERENCES products(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        cartId INTEGER,
        total REAL,
        paymentMethod TEXT,
        FOREIGN KEY (cartId) REFERENCES cart(id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  
  }

  Future<int> insertProduct(Product product) async {
    Database db = await this.database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    Database db = await this.database;
    return await db.update('products', product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  Future<int> deleteProduct(int id) async {
    Database db = await this.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Insertion(cart)
  Future<int> insertCart(Cart cart) async {
    Database db = await this.database;
    return await db.insert('cart', {
      'productId': cart.product.id,
      'quantity': cart.quantity,
      'size': cart.size,
      'color': cart.color,
    });
  }

  Future<void> deleteCart(Cart cart) async {
    Database db = await this.database;
    await db.delete('cart', where: 'id = ?', whereArgs: [cart.id]);
  }

  Future<void> updateCart(Cart cart) async {
    Database db = await this.database;
    await db.update('cart', cart.toMap(),
        where: 'id = ?', whereArgs: [cart.id]);
  }

  // liste de tous les produits du panier
  Future<List<Cart>> getCartItems() async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.query('cart');
    return List.generate(maps.length, (i) {
      return Cart(
        id: maps[i]['id'],
        quantity: maps[i]['quantity'],
        size: maps[i]['size'],
        color: maps[i]['color'],
        product: Product(
          id: maps[i]['productId'],
          name: '',
          price: 0,
          imageUrl: '',
          category: '',
          sizes: [],
          colors: [],
        ),
      );
    });
  }

  // Insertion(commande)
 Future<int> insertOrder(Order order) async {
  Database db = await this.database;
  String? cartId = order.cart.isNotEmpty ? order.cart[0].id.toString() : null;

  return await db.insert('orders', {
    'id': order.id,
    'cartId': cartId,
    'total': order.total,
    'paymentMethod': order.paymentMethod,
  });
}


  // Liste de tous les commandes
  Future<List<Order>> getOrders() async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.query('orders');
    return List.generate(maps.length, (i) {
      return Order(
        id: maps[i]['id'],
        cart: [],
        total: maps[i]['total'],
        paymentMethod: maps[i]['paymentMethod'],
      );
    });
  }

  Future<List<Cart>> getOrderDetails(String cartId) async {
  Database db = await database;

  List<Map<String, dynamic>> cartMaps = await db.query(
    'cart',
    where: 'id = ?',
    whereArgs: [cartId],
  );

  List<Cart> cartItems = [];
  for (var cartMap in cartMaps) {
    int productId = cartMap['productId'];
    Product product = await getProductById(productId);
    Cart cartItem = Cart(
      id: cartMap['id'],
      quantity: cartMap['quantity'],
      size: cartMap['size'],
      color: cartMap['color'],
      product: product,
    );
    cartItems.add(cartItem);
  }

  return cartItems;
}



Future<Product> getProductById(int productId) async {
  Database db = await database;
  List<Map<String, dynamic>> productMaps = await db.query('products',
      where: 'id = ?', whereArgs: [productId]);
  Map<String, dynamic> productMap = productMaps.first;
  return Product.fromMap(productMap);
}


}
