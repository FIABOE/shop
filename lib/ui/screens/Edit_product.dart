import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Product.dart';
import 'package:shop/Models/product.dart';
import 'dart:io';

class EditProductPage extends StatefulWidget {
  final Product product;

  EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late String _description;
  late String _category;
  late String _selectedSize;
  late String _selectedColor;
  late int _quantity;
  late File? _image;

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<String> _colors = ['Red', 'Green', 'Blue', 'Black'];

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _price = widget.product.price;
    _description = widget.product.description;
    _category = widget.product.category;
    _selectedSize = widget.product.sizes[0];
    _selectedColor = widget.product.colors[0];
    _quantity = widget.product.quantity;
    _image = File(widget.product.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 139, 126),
        title: const Text(
          'Modifier le Produit',
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                label: 'Nom',
                initialValue: _name,
                onSaved: (value) {
                  _name = value!;
                },
              ),
              _buildTextFormField(
                label: 'Prix (FCFA)',
                initialValue: _price.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              _buildTextFormField(
                label: 'Description',
                initialValue: _description,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              _buildTextFormField(
                label: 'Quantité',
                initialValue: _quantity.toString(),
                readOnly: true, // Champ de quantité non modifiable
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Catégorie'),
                value: _category,
                items: ['Homme', 'Femme', 'Enfant'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedSize,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSize = newValue!;
                  });
                },
                items: _sizes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Sélectionner la taille'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedColor,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedColor = newValue!;
                  });
                },
                items: _colors.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Sélectionner la couleur'),
              ),
               const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final editedProduct = Product(
                      id: widget.product.id,
                      name: _name,
                      price: _price,
                      description: _description,
                      imageUrl: _image!.path,
                      category: _category,
                      sizes: [_selectedSize],
                      colors: [_selectedColor],
                      quantity: _quantity,
                    );
                    Provider.of<ProductProvider>(context, listen: false).updateProduct(editedProduct);
                    Navigator.pop(context); 
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String initialValue,
    TextInputType keyboardType = TextInputType.text,
    FormFieldSetter<String>? onSaved,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        readOnly: readOnly,
        decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    keyboardType: keyboardType,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer une valeur';
    }
    return null;
  },
  onSaved: onSaved,
  ),
  );
}
}






