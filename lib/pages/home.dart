// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, dead_code

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/cart.dart';
import 'package:flower_app/model/item.dart';
import 'package:flower_app/pages/add_product.dart';
import 'package:flower_app/pages/checkout.dart';
import 'package:flower_app/pages/details_screen.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/pages/product.dart';
import 'package:flower_app/shared%20widgets/appbar.dart';
import 'package:flower_app/shared%20widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// final userData = {'fullName': '', 'email': '', 'avatarUrl': '', 'role': ''};

class Home extends StatelessWidget {
  final String fullName;
  final String email;
  final String avatarUrl;
  final String role;

  const Home(
      {required this.fullName,
      required this.email,
      required this.avatarUrl,
      required this.role,
      super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return SafeArea(
      child: Scaffold(
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // width & height chghl
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Details(
                              item: items[index],
                            )));
              },
              child: GridTile(
                child: Stack(
                  children: [
                    Positioned(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 0,
                      // cliprect to add curve
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child:
                              Image.asset("assets/img/${items[index].imgUrl}")),
                    ),
                  ],
                ),
                footer: GridTileBar(
                  trailing: Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          color: valBlue,
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                        onPressed: () {
                          cart.add(items[index]);
                        },
                        icon: Icon(Icons.add),
                        color: Colors.black,
                      )),
                  leading: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 219, 113),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "\$${items[index].price}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(""),
                ),
              ),
            );
          },
        ),
        drawer: Drawer(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/img/neon.jpg"),
                              fit: BoxFit.cover)),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                      accountEmail: Text(email),
                      accountName: Text(
                        fullName,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // ListTile(
                    //   title: Text("Home"),
                    //   leading: Icon(Icons.home),
                    //   onTap: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) => Home()));
                    //   },
                    // ),
                    ListTile(
                      title: Text("My Cart"),
                      leading: Icon(Icons.shopping_cart),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckOut()));
                      },
                    ),
                    ListTile(
                      title: Text("Add Product"),
                      leading: Icon(Icons.add_sharp),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProductPage()));
                      },
                    ),
                    ListTile(
                      title: Text("View Products"),
                      leading: Icon(Icons.image),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductPage()));
                      },
                    ),

                    ListTile(
                      title: Text("Logout"),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Developed By Sandesh Nilas - 2024",
                      style: TextStyle(fontSize: 14),
                    ))
              ]),
        ),
        appBar: AppBar(
          title: Text(
            "Products",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: valRed,
          actions: [
            ProductsAndPrice(),
          ],
        ),
      ),
    );
  }
}
