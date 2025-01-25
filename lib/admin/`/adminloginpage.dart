import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/admin/%60/adminhome.dart';

class Adminloginpage extends StatefulWidget {
  const Adminloginpage({super.key});

  @override
  State<Adminloginpage> createState() => _AdminloginpageState();
}

class _AdminloginpageState extends State<Adminloginpage> {
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _adminPasswordController = TextEditingController();

  // Bool to show/hide password
  bool _isPasswordVisible = false;

  // Admin login method
  Future<void> adminLogin() async {
    String adminName = _adminNameController.text.trim();
    String adminPassword = _adminPasswordController.text.trim();

    if (adminName.isEmpty || adminPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all the fields.")),
      );
      return;
    }

    try {
      // Query Firestore for the admin credentials
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Admin")
          .where("Adminname", isEqualTo: adminName)
          .where("Adminpassword", isEqualTo: adminPassword)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Navigate to the HomePage if credentials are valid
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else {
        // Show error if credentials are invalid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid Admin credentials.")),
        );
      }
    } catch (e) {
      // Handle errors
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: Column(
            children: [
              Image.asset('assets/images/signup.png'),
              const Text(
                "Admin Login",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Admin name input
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _adminNameController,
                    decoration: InputDecoration(
                      hintText: 'Admin Name',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password input
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _adminPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black.withOpacity(0.44),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),

              // Login Button
              ElevatedButton(
                onPressed: () => adminLogin(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 162, 255),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
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
