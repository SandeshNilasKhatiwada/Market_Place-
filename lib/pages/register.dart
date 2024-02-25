// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/shared%20widgets/colors.dart';
import 'package:flower_app/shared%20widgets/constants.dart';
import 'package:flower_app/shared%20widgets/snackbar.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  bool obscurePassword = true;

  bool isPassword8Char = false;
  bool atLeast1Number = false;
  bool hasUpperCase = false;
  onPasswordChanged(String password) {
    setState(() {
      isPassword8Char = false;
      atLeast1Number = false;
      hasUpperCase = false;
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8Char = true;
      }
      ;
      if (password.contains(RegExp(r'.*[0-9].*'))) {
        atLeast1Number = true;
      }
      ;
      // if (password.contains(RegExp(r'?=.*?[A-Z]'))) {
      //   hasUpperCase = true;
      // }
    });
  }

  register() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  // deletes the controller when moving to a different screen
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 238, 238),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(33.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MyTextField(
                    //   textInputType: TextInputType.emailAddress,
                    //   isPassword: false,
                    //   hintText: "Enter your email",
                    // ),

                    TextField(
                      keyboardType: TextInputType.text,
                      // for password obscure
                      obscureText: false,
                      decoration: decorationTextField.copyWith(
                          hintText: "Enter Your Username",
                          suffixIcon: Icon(Icons.person)),
                    ),
                    SizedBox(
                      height: 33,
                    ),
                    TextFormField(
                      controller: emailController,
                      // Text Validation using EmailValidator package
                      validator: (value) {
                        return value!.contains(RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                            ? null
                            : "Enter a valid email";
                      },
                      // autovalidate ( tjrs khaddam )
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      // for password obscure
                      obscureText: false,
                      decoration: decorationTextField.copyWith(
                          hintText: "Enter Your Email",
                          suffixIcon: Icon(Icons.email)),
                    ),
                    SizedBox(
                      height: 33,
                    ),
                    TextFormField(
                      onChanged: (password) {
                        onPasswordChanged(password);
                      },
                      validator: (value) {
                        return value!.length < 8
                            ? "Enter at least 8 characters"
                            : null;
                      },
                      // autovalidate ( tjrs khaddam )
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      // for password obscure
                      obscureText: obscurePassword,
                      decoration: decorationTextField.copyWith(
                          hintText: "Enter Your Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              icon: obscurePassword
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off))),
                    ),

                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isPassword8Char ? Colors.green : Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 179, 177, 177))),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text("At least 8 characters")
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  atLeast1Number ? Colors.green : Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 179, 177, 177))),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text("At least 1 number")
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasUpperCase ? Colors.green : Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 179, 177, 177))),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text("Has Uppercase")
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 179, 177, 177))),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text("Has Lowercase")
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 179, 177, 177))),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text("Has special characters")
                      ],
                    ),

                    SizedBox(
                      height: 33,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // check if validation is true
                        if (_formkey.currentState!.validate()) {
                          register();
                        } else {
                          showSnackBar(context, "ERROR");
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(valBlue),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Register",
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account ?",
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
                                      builder: (context) => const Login()));
                            },
                            child: Text(
                              "Sign in",
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
        ),
      ),
    );
  }
}
