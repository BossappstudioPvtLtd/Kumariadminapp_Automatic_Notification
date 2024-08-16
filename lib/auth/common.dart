import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DriverHomeState createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference driverRef;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      driverRef = FirebaseDatabase.instance.ref().child('drivers').child(user!.uid);
      driverRef.onValue.listen((event) {
        if (event.snapshot.exists) {
          var data = event.snapshot.value as Map<dynamic, dynamic>;
          if (data['blockStatus'] == "Yes") {
            signOutDriver();
          }
        }
      });
    }
  }

  Future<void> signOutDriver() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Home'),
      ),
      body: const Center(
        child: Text('Welcome, Driver!'),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Login Screen'),
      ),
    );
  }
}
