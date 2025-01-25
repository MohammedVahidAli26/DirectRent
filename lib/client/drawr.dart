import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/sharedpreference.dart';
import 'about.dart';

class Drawerpage extends StatefulWidget {
   Drawerpage({super.key});

  @override
  State<Drawerpage> createState() => _DrawerpageState();
}

class _DrawerpageState extends State<Drawerpage> {
  String userName = " "; 
 // Default value for user name
    void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

   // Function to load the user's name from SharedPreferences
  _loadUserName() async {
    String? savedName = await SharedpreferenceHelper().getUserName();
    if (savedName != null && savedName.isNotEmpty) {
      setState(() {
        userName = savedName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    
    return Drawer(
      width: MediaQuery.of(context).size.width* 0.50,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            
            decoration: BoxDecoration(
              
              color: Colors.black,
              shape: BoxShape.rectangle,
              
            ),
            child: Padding(
              padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,  // Top padding: 4% of screen height
                              left: MediaQuery.of(context).size.width * 0.02, // Left padding: 2% of screen width
                              right: MediaQuery.of(context).size.width * 0.04, // Right padding: 4% of screen width
                              bottom: MediaQuery.of(context).size.height * 0.0, // Bottom padding: 2% of screen height
                            ),// Add padding at the top
                                        child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *0.8,
                    height:MediaQuery.of(context).size.width *0.08, 
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle, 
                      borderRadius: BorderRadius.circular(50), 
                      image: DecorationImage(
                        image: AssetImage('assets/images/user.png'),
                        fit: BoxFit.contain, 
                      ),
                    ),
                  ),


SizedBox(height: 12,),
         Text(
                'Hi, $userName',
                style: GoogleFonts.poppins(
                          color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w700

                    ),
              ),
                ],
            ),),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
            Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => AboutPage()),
);

            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
             signOut();
            },
          ),
        ],
      ),
    );
  }}
