
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/dashbord/sidevavigationdrawer.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: const FirebaseOptions(
  apiKey: "AIzaSyCPQ8ZnNv-cGzzh7EhUPZ5xOEbNimFwAEE",
  authDomain: "myapiprojects-425308.firebaseapp.com",
  databaseURL: "https://myapiprojects-425308-default-rtdb.firebaseio.com",
  projectId: "myapiprojects-425308",
  storageBucket: "myapiprojects-425308.appspot.com",
  messagingSenderId: "1008646289128",
  appId: "1:1008646289128:web:028217b3db6e371e2ebb5d",
  measurementId: "G-S4VW1WCD2D"
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
      home: const SideNavigationDrawer(),
    );
  }
}


