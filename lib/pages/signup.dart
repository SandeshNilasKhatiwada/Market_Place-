import 'package:flower_app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  late File avatarImage; // This should be set to the selected image file
  String role = 'User'; // Default role

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        avatarImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Profile Avatar'),
              ),
              DropdownButton<String>(
                value: role,
                onChanged: (String? newValue) {
                  setState(() {
                    role = newValue!;
                  });
                },
                items: <String>['Admin', 'User']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  String fullName = nameController.text;
                  String email = emailController.text;
                  String password = passwordController.text;

                  UserCredential userCredential =
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                  User? user = userCredential.user;

                  if (user != null) {
                    // Upload the avatar image to Firebase Storage
                    Reference ref = FirebaseStorage.instance
                        .ref()
                        .child('avatars')
                        .child('${user.uid}.jpg');
                    await ref.putFile(avatarImage);

                    // Get the download URL of the uploaded image
                    String avatarUrl = await ref.getDownloadURL();

                    // Store the user data in Firestore
                    await _firestore.collection('users').doc(user.uid).set({
                      'fullName': fullName,
                      'email': email,
                      'avatarUrl': avatarUrl,
                      'role': role,
                    });
                  }

                  //Go to login page
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
