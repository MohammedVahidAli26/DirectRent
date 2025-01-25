import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapp/client/signup.dart';

import 'package:quizapp/client/userhomepage.dart';

class Sampleloginui extends StatefulWidget {
  const Sampleloginui({super.key});

  @override
  State<Sampleloginui> createState() => _SampleloginuiState();
}

class _SampleloginuiState extends State<Sampleloginui> {
  String email = "", password = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserViewPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else {
        errorMessage = '${e.code}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('An unexpected error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.07),
                  Image.asset(
                    'assets/images/rb_22606.png',
                    width: size.width * 0.8,
                    height: size.width * 0.8,
                    fit: BoxFit.cover,
                  ),
                
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Your Next Home is Just a Tap Away",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight:FontWeight.w500
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                      child: Row(
                        children: [
                          Icon(Icons.email, color: Colors.grey,size: 18,), // Email Icon
                          SizedBox(width: 16), // Space between Icon and TextField
                          Expanded(
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                                border: InputBorder.none,
                                
                                // Background color for the TextField
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                   Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                      child: Row(
                        children: [
                          Icon(Icons.lock, color: Colors.grey,size: 18,), // Email Icon
                          SizedBox(width: 16), // Space between Icon and TextField
                          Expanded(
                            child: TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: 'Passowrd',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                                border: InputBorder.none,
                                
                                // Background color for the TextField
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Password.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: size.height * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text.trim();
                          password = passwordController.text.trim();
                        });
                        userLogin();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.3,
                        vertical: size.height * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child:  Text(
                      'Login',
                      style: TextStyle(color: Colors.white,
                                            fontSize: MediaQuery.of(context).size.width * 0.04,
)
                      ,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                         onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                        child: const Text(
                          "Register here!",
                          style: TextStyle(color: Colors.blue),
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
}
