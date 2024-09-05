
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/auth/login.dart';
import 'package:kumari_admin_web/dashbord/sidevavigationdrawer.dart';
//import 'package:kumari_admin_web/dashbord/sidevavigationdrawer.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: const FirebaseOptions(
   apiKey: "AIzaSyC-HaF59Rta8UqFpfP9UIXCxmSB4pfbQgo",
  authDomain: "kumariuseranddriver.firebaseapp.com",
  databaseURL: "https://kumariuseranddriver-default-rtdb.firebaseio.com",
  projectId: "kumariuseranddriver",
  storageBucket: "kumariuseranddriver.appspot.com",
  messagingSenderId: "624263695924",
  appId: "1:624263695924:web:ce12a37ff0bb22e804c461",
  measurementId: "G-J8GJYB3CSC"
    )
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(
      ),
      home:  const SideNavigationDrawer(),
    );
  }
}


