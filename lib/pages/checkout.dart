// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flower_app/cart.dart';
import 'package:flower_app/shared%20widgets/appbar.dart';
import 'package:flower_app/shared%20widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout Screen"),
        backgroundColor: valRed,
        actions: [
          ProductsAndPrice(),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 550,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: cart.flowersInCart.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text("${cart.flowersInCart[index].product}"),
                      subtitle: Text("Rs ${cart.flowersInCart[index].price}"),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(cart.flowersInCart[index].imgUrl),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            cart.remove(cart.flowersInCart[index]);
                          },
                          icon: Icon(Icons.remove)),
                    ),
                  );
                }),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(valRed),
                padding: MaterialStateProperty.all(
                  EdgeInsets.fromLTRB(25, 8, 25, 8),
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)))),
            child: Text(
              "Pay Rs ${cart.totalPrice}",
              style: TextStyle(fontSize: 19, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
