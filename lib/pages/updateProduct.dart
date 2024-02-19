import 'package:flower_app/cart.dart';
import 'package:flower_app/model/item.dart';
import 'package:flower_app/pages/update_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPage2 extends StatefulWidget {
  const ProductPage2({super.key});

  @override
  State<ProductPage2> createState() => _ProductPage2State();
}

class _ProductPage2State extends State<ProductPage2> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void showOptions(BuildContext context, DocumentSnapshot product, Item item) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Update'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateProductForm(
                            item: item, productId: product.id

                            //   oldValue: {
                            //   'name': item.product,
                            //   'description': item.description,
                            //   'price': item.price,
                            //   'quantity': item.quantity,
                            //   'imageUrl': item.imgUrl,
                            //   'productId': product.id,
                            // },
                            );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    // Delete product
                    _firestore.collection('products').doc(product.id).delete();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Page')),
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
              return GestureDetector(
                onLongPress: () => showOptions(context, document, item),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.network(data['imageUrl']),
                      Text(data['name']),
                      Text('Price: \$${data['price']}'),
                      Text('Quantity: ${data['quantity']} on Stock'),
                      ElevatedButton(
                        onPressed: () {
                          var cart = Provider.of<Cart>(context, listen: false);
                          cart.add(item);
                        },
                        child: const Text('Add To Cart'),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
