import 'package:flutter/material.dart';
import 'package:shop/Models/product.dart';
import 'dart:io';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 139, 126),
        title: Text(
          widget.product.name,
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.product.imageUrl.isNotEmpty &&
                  File(widget.product.imageUrl).existsSync())
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: FileImage(File(widget.product.imageUrl)),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  child: const Center(
                    child: Text(
                      'No Image Available',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAttributeRow(
                          'Prix', '${widget.product.price.toStringAsFixed(2)} FCFA'),
                      const SizedBox(height: 16),
                      _buildAttributeRow('Catégorie', widget.product.category),
                      const SizedBox(height: 8),
                      _buildAttributeRow('Quantité', widget.product.quantity.toString()),
                      const SizedBox(height: 8),
                      _buildAttributeRow('Tailles', widget.product.sizes.join(", ")),
                      const SizedBox(height: 8),
                      _buildAttributeRow('Couleurs', widget.product.colors.join(", ")),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 2, 88, 61),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttributeRow(String attribute, String value) {
    return Row(
      children: [
        Container(
          width: 100,
          child: Text(
            attribute,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 63, 135, 119),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 188, 103, 37),
            ),
          ),
        ),
      ],
    );
  }
}
