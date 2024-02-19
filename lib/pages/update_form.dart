import 'package:flower_app/model/item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateProductForm extends StatefulWidget {
  // Map<String, String>? oldValue;
  late Item item;
  late String productId;

  UpdateProductForm({super.key, required this.item, required this.productId});

  @override
  State<UpdateProductForm> createState() => _UpdateProductFormState();
}

class _UpdateProductFormState extends State<UpdateProductForm> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  late File imageFile; // This should be set to the selected image file
  bool imageChanged = false;
  // bool isLoading = true;
  late String imgUrl;

  @override
  void initState() {
    setState(() {
      nameController.text = widget.item.product;
      descriptionController.text = widget.item.description;

      priceController.text = '${widget.item.price}';
      quantityController.text = '${widget.item.quantity}';
      imgUrl = widget.item.imgUrl;
    });

    super.initState();
  }

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageChanged = true;
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
      appBar: AppBar(title: const Text('Update Product')),
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
                'Change Image',
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

                if (imageChanged) {
                  // Upload the product image to Firebase Storage
                  Reference ref = FirebaseStorage.instance
                      .ref()
                      .child('products')
                      .child('$name.jpg');
                  await ref.putFile(imageFile);

                  // Get the download URL of the uploaded image
                  imgUrl = await ref.getDownloadURL();
                }

                //settting new data
                Map<String, dynamic> newProduct = {
                  'name': name,
                  'description': description,
                  'price': price,
                  'quantity': quantity,
                  'imageUrl': imgUrl,
                };

                //update data
                FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.productId)
                    .update(newProduct);

                // Show a SnackBar
                final snackbar = SnackBar(content: Text('$name Updated'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);

                Navigator.pop(context);
              },
              child: const Text('Update Product',
                  style: TextStyle(fontSize: 17, color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
