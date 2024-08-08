import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/Com/comen.dart';
import 'package:kumari_admin_web/Com/m_button.dart';
import 'package:kumari_admin_web/dashbord/sidevavigationdrawer.dart';
import 'package:kumari_admin_web/new.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  CommonMethods cMethods = CommonMethods();
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  void checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signInFormValidation();
  }

  void signInFormValidation() {
    if (!emailTextEditingController.text.contains("@gmail.com")) {
      cMethods.displaySnackBar("Please enter a valid email.", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar(
          "Your password must be at least 6 characters long.", context);
    } else {
      signInUser();
    }
  }

  Future<void> signInUser() async {
    try {
      // Sign in with email and password
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      final User? userFirebase = userCredential.user;

      if (userFirebase != null) {
        // Navigate directly to the dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const SideNavigationDrawer()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth exceptions
      if (e.code == 'wrong-password') {
        cMethods.displaySnackBar(
            "Incorrect password. Please try again.", context);
      } else if (e.code == 'user-not-found') {
        cMethods.displaySnackBar("No user found with this email.", context);
      } else {
        cMethods.displaySnackBar(
            e.message ?? "An error occurred. Please try again.", context);
      }
    } catch (error) {
      // Handle other types of errors
      cMethods.displaySnackBar(
          "An unexpected error occurred: ${error.toString()}", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SpinnerAnimated(),
                      Image.asset(
                        "assets/images/banner.png",
                        height: 250,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       
                        SizedBox(
                    height: 100,
                    child: AnimatedTextKit(
                    animatedTexts: [
                    RotateAnimatedText('KUMARI CABS', textStyle: const TextStyle(color:Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
                    RotateAnimatedText('KUMARI CABS', textStyle: const TextStyle(color:Colors.black,fontSize: 25,fontWeight: FontWeight.bold  )),
                    RotateAnimatedText('KUMARI CABS',textStyle: const TextStyle(color:Colors.black ,fontSize: 25,fontWeight: FontWeight.bold)),
   
                  ],
                  totalRepeatCount:10,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
),

                      const SizedBox(height: 20),
                      const Text(
                        "Login as Admin",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextFormField(
                          controller: emailTextEditingController,
                          decoration: const InputDecoration(
                            icon: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(Icons.email),
                            ),
                            border: InputBorder.none,
                            labelText: "Email",
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextFormField(
                          obscureText: passwordVisible,
                          controller: passwordTextEditingController,
                          decoration: InputDecoration(
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(Icons.lock),
                            ),
                            border: InputBorder.none,
                            labelText: "Password",
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
                        ),
                      ),
                      const SizedBox(height: 30),
                      MaterialButtons(
                        borderRadius: BorderRadius.circular(10),
                        meterialColor: const Color.fromARGB(255, 3, 22, 60),
                        containerheight: 50,
                        elevationsize: 10,
                        textcolor: Colors.white,
                        fontSize: 18,
                        textweight: FontWeight.bold,
                        text: "Login",
                        onTap: () {
                          checkIfNetworkIsAvailable();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
