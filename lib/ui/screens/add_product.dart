import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Product.dart';
import 'package:shop/Models/product.dart';
import 'package:shop/ui/screens/product_list.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0.0;
  String _description = '';
  File? _image;
  String _category = 'Homme';
  String? selectedSize;
  String? selectedColor;
  int _quantity = 0; 

  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  final List<String> colors = ['Red', 'Green', 'Blue', 'Black'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 139, 126),
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
          'Ajout d\'un Produit',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListPage(),
                ),
              );
            },
            child: const Row(
              children: [
                const Icon(
                  Icons.list,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextFormField(
                label: 'Nom du produit',
                icon: Icons.text_fields,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'vueillez saisir un nom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              buildTextFormField(
                label: 'Prix du produit',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'vueillez saisir un prix';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              buildTextFormField(
                label: 'Description',
                icon: Icons.description,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              buildTextFormField(
                label: 'Quantité', 
                icon: Icons.confirmation_number,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vueillez saisir la quantité ';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quantity = int.parse(value!);
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Catégories',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final image = await getImage();
                      setState(() {
                        _image = image;
                      });
                    },
                    icon: const Icon(Icons.image, color: Colors.white),
                    label: const Text('Choisir une image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _image != null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedSize,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSize = newValue;
                  });
                },
                items: sizes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Selectionner la taille'),
                validator: (value) {
                  if (value == null) {
                    return 'Veuiller selectionner la taille';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedColor,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedColor = newValue;
                  });
                },
                items: colors.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Selectionner la couleur'),
                validator: (value) {
                  if (value == null) {
                    return 'Veuiller selectionner la couleur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newProduct = Product(
                      name: _name,
                      price: _price,
                      description: _description,
                      imageUrl: _image?.path ?? '',
                      category: _category,
                      sizes: [selectedSize!],
                      colors: [selectedColor!],
                      quantity: _quantity, 
                    );
                    try {
                      await Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
                      showSuccessDialog(context);
                    } catch (error) {
                      showErrorDialog(context);
                    }
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
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Succès'),
        content: const Text('Le produit a été ajouté avec succès!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              resetForm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erreur'),
        content: const Text('Échec de l\'ajout du produit. Veuillez réessayer.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _image = null;
      selectedSize = null;
      selectedColor = null;
      _category = 'Homme';
    });
  }

  Widget buildTextFormField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Future<File?> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}
