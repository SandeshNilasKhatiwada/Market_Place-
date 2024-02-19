// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/model/user.dart';
import 'package:flower_app/pages/home.dart';
import 'package:flower_app/pages/product.dart';
import 'package:flower_app/pages/register.dart';
import 'package:flower_app/pages/signup.dart';
import 'package:flower_app/profile.dart';
import 'package:flower_app/shared%20widgets/colors.dart';
import 'package:flower_app/shared%20widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localUser = Provider.of<LocalUserProfile>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 238, 238),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(33.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 33,
                ),
                // MyTextField(
                //   textInputType: TextInputType.emailAddress,
                //   isPassword: false,
                //   hintText: "Enter your email",
                // ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  // for password obscure
                  obscureText: false,
                  decoration: decorationTextField.copyWith(
                      hintText: "Enter Your Email"),
                ),
                SizedBox(
                  height: 33,
                ),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  // for password obscure
                  obscureText: true,
                  decoration: decorationTextField.copyWith(
                      hintText: "Enter Your Password"),
                ),
                SizedBox(
                  height: 33,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String email = emailController.text.trim();
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email,
                              password: passwordController.text.trim());
                      User? user = credential.user;
                      if (user != null) {
                        DocumentSnapshot doc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .get();
                        String fullName = doc['fullName'];
                        String avatarUrl = doc['avatarUrl'];
                        String role = doc['role'];

                        localUser.set(
                          LocalUser(
                              fullName: fullName,
                              email: email,
                              avatarUrl: avatarUrl,
                              role: role),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ProductPage()
                              // Home(
                              //     fullName: fullName,
                              //     email: email,
                              //     avatarUrl: avatarUrl,
                              //     role: role),
                              ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(valBlue),
                    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontSize: 19, color: Colors.white),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do not have an account ?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          // a method to navigate to another page through the class name and not the route name
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()));
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              color: valRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
