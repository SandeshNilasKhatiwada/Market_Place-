import 'package:flower_app/cart.dart';
import 'package:flower_app/model/item.dart';
import 'package:flower_app/pages/details_screen.dart';
import 'package:flower_app/pages/drawer.dart';
import 'package:flower_app/shared%20widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../shared widgets/appbar.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: valRed,
        actions: const [
          ProductsAndPrice(),
        ],
      ),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              Item item = Item(
                  imgUrl: data['imageUrl'],
                  product: data['name'],
                  price: data['price'],
                  location: "Cité el Qods",
                  quantity: data['quantity'],
                  description: data['description']);
              return Card(
                child: Column(
                  children: <Widget>[
                    Image.network(
                      item.imgUrl,
                      width: 200,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      item: item,
                                    )));
                      },
                      child: Text(
                        item.product,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Rs ${item.price}',
                          style: const TextStyle(
                              color: Colors.purple, fontSize: 12),
                        ),
                        Text(
                          '${item.quantity} on Stock',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add to cart functionality here
                        cart.add(item);
                      },
                      child: const Text('Add To Cart'),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetailPage({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productData['name'])),
      body: Center(child: Text('Description: ${productData['description']}')),
    );
  }
}
