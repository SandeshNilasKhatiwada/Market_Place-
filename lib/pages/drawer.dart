import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/add_product.dart';
import 'package:flower_app/pages/checkout.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/pages/product.dart';
import 'package:flower_app/pages/updateProduct.dart';
import 'package:flower_app/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localUser = Provider.of<LocalUserProfile>(context);
    return Drawer(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/neon.jpg"),
                      fit: BoxFit.cover)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(localUser.avatarUrl),
              ),
              accountEmail: Text(localUser.email),
              accountName: Text(
                localUser.fullName,
                style: const TextStyle(color: Colors.white),
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
              title: const Text("My Cart"),
              leading: const Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CheckOut()));
              },
            ),
            if (localUser.role == 'Admin')
              ListTile(
                title: const Text("Add Product"),
                leading: const Icon(Icons.add_sharp),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProductPage()));
                },
              ),
            if (localUser.role == 'Admin')
              ListTile(
                title: const Text("Edit Products"),
                leading: const Icon(Icons.image),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductPage2()));
                },
              ),

            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.exit_to_app),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
            ),
          ],
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: const Text(
              "Developed By Sandesh Nilas - 2024",
              style: TextStyle(fontSize: 14),
            ))
      ]),
    );
  }
}
