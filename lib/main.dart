// ignore_for_file: prefer_const_constructors

import 'package:flower_app/cart.dart';
import 'package:flower_app/firebase_options.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/pages/register.dart';
import 'package:flower_app/pages/signup.dart';
import 'package:flower_app/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => LocalUserProfile()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(), //Register(),
    );
  }
}
