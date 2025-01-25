// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapp/client/clientLogin.dart';
import 'package:quizapp/services/clientinfo.dart';
import 'package:random_string/random_string.dart';

import '../admin/`/adminloginpage.dart';
import '../services/sharedpreference.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
    String email = "", password = "";

  // Controllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Bool to show/hide password
  bool _isConfirmPasswordVisible = false;

  // GlobalKey for form validation
  final _formKey = GlobalKey<FormState>();

  // Function to handle sign up
 Future<void> registraion() async {
  // Get the values from the text controllers
  String name = _nameController.text.trim();
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  // Validate the inputs before proceeding
  if (name.isEmpty || email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields.')));
    return;
  }

  // Check if password and confirm password match
  if (password != _confirmPasswordController.text.trim()) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match.')));
    return;
  }

  // Create user with email and password
  try {
    // Creating the user with Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Generate a random ID for the user
    String userId = randomAlpha(10);  // Use random_alpha package here
    
    await SharedpreferenceHelper().saveUserId(userId);
    await SharedpreferenceHelper().saveUserEmail(_emailController.text);
    await SharedpreferenceHelper().saveUserName(_nameController.text); 
    await SharedpreferenceHelper().saveUserImage("assets/images/user.png"); 


    // Map to store the user data in Firestore or Realtime Database
    Map<String, dynamic> userData = {
      "name": _nameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "image": "assets/images/user.png",
      "id": userId, // Store the random ID in the database
    };
    await DatabaseMethods().addUserDetails(userData, userId);

    // Optionally, store user data in Firestore (uncomment if using Firestore)
    // FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(userData);

    // Navigate to the Login page after successful registration
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Sampleloginui()),
    );

    // Show success dialog after successful sign-up
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("You successfully signed up!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Sampleloginui()),
                );
              },
            ),
          ],
        );
      },
    );

  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The password provided is too weak.')));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account already exists for that email.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An unexpected error occurred.')));
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
                  SizedBox(height: size.height * 0.04),
                  Image.asset(
                    'assets/images/Login (1).gif',
                    width: size.width * 0.7,
                    height: size.width * 0.7,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "Unlock Your Dream Home",
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.w400,

                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                   // Name input
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10), // Space between Icon and TextField
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle:  GoogleFonts.poppins(color: Colors.grey.withOpacity(0.5), fontSize: MediaQuery.of(context).size.width * 0.04),
                                border: InputBorder.none,
                                
                        ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        
                      ),
                      Icon(Icons.person, color: Colors.grey), // Email Icon

                        ],
                    ),)),

                  SizedBox(height: size.height * 0.01),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10), // Space between Icon and TextField
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle:  GoogleFonts.poppins(color: Colors.grey.withOpacity(0.5), fontSize: MediaQuery.of(context).size.width * 0.04),
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
                          Icon(Icons.email, color: Colors.grey), // Email Icon

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),

                   Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                      child: Row(
                        children: [
                          SizedBox(width: 10), // Space between Icon and TextField
                          Expanded(
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Passowrd',
                                hintStyle:  GoogleFonts.poppins(color: Colors.grey.withOpacity(0.5), fontSize: MediaQuery.of(context).size.width * 0.04),
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
                          Icon(Icons.lock, color: Colors.grey), // Email Icon

                        ],
                      ),
                    ),
                  ),
                  Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !_isConfirmPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  hintStyle:  GoogleFonts.poppins(color: Colors.grey.withOpacity(0.5), fontSize: MediaQuery.of(context).size.width * 0.04),
                                
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
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
                          email = _emailController.text.trim();
                          password = _passwordController.text.trim();
                        });
                          registraion();
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
                      'Sign Up',
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
                      const Text("Already have an account?"),
                      TextButton(
                         onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Sampleloginui()),
                        );
                      },
                        child: const Text(
                          "Login here!",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Admin Panel"),
                      TextButton(
                         onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Adminloginpage()),
                        );
                      },
                        child: const Text(
                          "Admin Login!",
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
