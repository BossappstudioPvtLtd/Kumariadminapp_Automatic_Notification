import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/Com/m_button.dart';

class AdminUpdate extends StatefulWidget {
  const AdminUpdate({super.key});

  @override
  _AdminUpdateState createState() => _AdminUpdateState();
}

class _AdminUpdateState extends State<AdminUpdate> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  User? _currentUser;
  bool passwordVisible = false;
  bool isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userRef = _databaseRef.child('admin/${_currentUser!.uid}');
      final snapshot = await userRef.once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        _emailController.text = data['email'] ?? '';
        // Do not set the password field from the database
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  Future<void> updateEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        if (_currentUser != null) {
          if (_emailController.text.isNotEmpty) {
            await _currentUser!.updateEmail(_emailController.text.trim());
            // Update email in the database
            await _databaseRef.child('admin/${_currentUser!.uid}').update({
              'email': _emailController.text.trim(),
            });
          }

          if (_passwordController.text.isNotEmpty) {
            await _currentUser!.updatePassword(_passwordController.text.trim());
            // Update password in the database
            await _databaseRef.child('admin/${_currentUser!.uid}').update({
              'password': _passwordController.text.trim(),
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop(); // Dismiss the popup
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 15, 89, 200),
              Color.fromARGB(255, 4, 33, 76),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Update Email & Password",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Email',
                            icon: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(Icons.email_outlined),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextFormField(
                          obscureText: passwordVisible,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Password',
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(Icons.lock),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value != null && value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      MaterialButtons(
                        borderRadius: BorderRadius.circular(10),
                        meterialColor: const Color.fromARGB(255, 3, 22, 60),
                        containerheight: 50,
                        elevationsize: 20,
                        textcolor: Colors.white,
                        fontSize: 18,
                        textweight: FontWeight.bold,
                        text: "Update",
                        onTap: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            barrierDismissible:
                                false, // User must tap a button to dismiss the dialog
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                elevation: 20,
                                title: const Text(
                                  'Are you sure',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                content: const Text(
                                  ' You want to change\n your email address and password',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      MaterialButtons(
                                        borderRadius: BorderRadius.circular(10),
                                        meterialColor: const Color.fromARGB(255, 3, 22, 60),
                                        containerheight: 30,
                                        containerwidth: 100,
                                        textcolor: Colors.white,
                                        elevationsize: 20,
                                        text: 'Cancel',
                                        onTap: () { Navigator.of(context).pop();},
                                      ),
                                      MaterialButtons(
                                        borderRadius: BorderRadius.circular(10),
                                        meterialColor: const Color.fromARGB(255, 3, 22, 60),
                                        containerheight: 30,
                                        containerwidth: 100,
                                        textcolor: Colors.white,
                                        elevationsize: 20,
                                        text: 'Continue',
                                        onTap: () {
                                          updateEmailAndPassword(); 
                                           Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                  
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      if (isLoading) // Show the loader when isLoading is true
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white,),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
