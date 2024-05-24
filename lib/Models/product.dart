class Product {
  int? id;
  String name;
  double price;
  String description;
  String imageUrl;
  String category;
  List<String> sizes;
  List<String> colors;
  int quantity; 

  Product({
    this.id,
    required this.name,
    required this.price,
    this.description = '',
    required this.imageUrl,
    required this.category,
    required this.sizes,
    required this.colors,
    this.quantity = 0, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'sizes': sizes.join(','),
      'colors': colors.join(','),
      'quantity': quantity, 
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      category: map['category'],
      sizes: (map['sizes'] as String).split(',').toList(),
      colors: (map['colors'] as String).split(',').toList(),
      quantity: map['quantity'] ?? 0, 
    );
  }
}
