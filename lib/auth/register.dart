import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/Com/comen.dart';
import 'package:kumari_admin_web/Com/m_button.dart';
import 'package:kumari_admin_web/auth/login.dart';
import 'package:kumari_admin_web/dashbord/sidevavigationdrawer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  final CommonMethods cMethods = CommonMethods();
  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> checkIfNetworkIsAvailable() async {
    await cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  void signUpFormValidation() {
    if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Please enter a valid email.", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar("Your password must be at least 6 characters long.", context);
    } else {
      registerNewUser();
    }
  }

  Future<void> registerNewUser() async {
    try {
      final User? userFirebase = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      )).user;

      if (userFirebase != null) {
        final DatabaseReference usersRef = FirebaseDatabase.instance
            .ref()
            .child("admin")
            .child(userFirebase.uid);

        final Map<String, String> userDataMap = {
          "email": emailTextEditingController.text.trim(),
          "id": userFirebase.uid,
          "password": passwordTextEditingController.text.trim(), // Not recommended
          "blockStatus": "no",
        };

        await usersRef.set(userDataMap);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) =>  SideNavigationDrawer()));
      }
    } catch (errorMsg) {
      cMethods.displaySnackBar(errorMsg.toString(), context);
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text(
          "Create an Admin Account",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  buildTextField(emailTextEditingController, "Email",
                      Icons.email, false, TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  buildTextField(passwordTextEditingController, "Password",
                      Icons.lock, true, TextInputType.text),
                  const SizedBox(height: 30),
                  MaterialButtons(
                    borderRadius: BorderRadius.circular(10),
                    meterialColor: const Color.fromARGB(255, 3, 22, 60),
                    containerheight: 50,
                    elevationsize: 10,
                    textcolor: Colors.white,
                    fontSize: 18,
                    textweight: FontWeight.bold,
                    text: "Register",
                    onTap: checkIfNetworkIsAvailable,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an Account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => const LoginScreen()));
                        },
                        child: const Text(
                          "Login Here",
                          style: TextStyle(color: Color.fromARGB(255, 1, 72, 130)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      IconData icon, bool isPassword,
      [TextInputType? keyboardType]) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && passwordVisible,
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Icon(icon),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelText: labelText,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
