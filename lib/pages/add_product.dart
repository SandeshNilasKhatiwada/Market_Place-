import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  late File imageFile; // This should be set to the selected image file

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Product Description'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Product Price'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Product Quantity'),
            ),
            const SizedBox(
              height: 6,
            ),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text(
                'Pick Image',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            TextButton(
              onPressed: () async {
                String name = nameController.text;
                String description = descriptionController.text;
                double price = double.parse(priceController.text);
                int quantity = int.parse(quantityController.text);

                // Upload the product image to Firebase Storage
                Reference ref = FirebaseStorage.instance
                    .ref()
                    .child('products')
                    .child('$name.jpg');
                await ref.putFile(imageFile);

                // Get the download URL of the uploaded image
                String imageUrl = await ref.getDownloadURL();

                // Store the product data in Firestore
                await _firestore.collection('products').add({
                  'name': name,
                  'description': description,
                  'price': price,
                  'quantity': quantity,
                  'imageUrl': imageUrl,
                });

                // Show a SnackBar
                final snackbar =
                    SnackBar(content: Text('$quantity $name added'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);

                Navigator.pop(context);
              },
              child: const Text('Add Product',
                  style: TextStyle(fontSize: 17, color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
