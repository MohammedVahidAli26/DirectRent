import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapp/client/userhomepage.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon (Icons.arrow_back,color: Colors.white,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserViewPage(),
          ));
        }),
        title: Text('About DirectRent', style: GoogleFonts.poppins(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App logo (optional)
              Center(
                child: Image.asset(
                  width: 250,
                
                  'assets/images/logo3.png', // You can use your app's logo here
                  height: 250,
                ),
              ),
              SizedBox(height: 10),
        
              // Title
              Text(
                'Welcome to DirectRent',
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 15),
        
              // Description of the app
              Text(
                "DirectRent is an innovative app designed to cut down broker fees, allowing renters to directly connect with property owners. We believe in simplifying the process and offering better deals for everyone by removing intermediaries. Our goal is to make the rental process more transparent and cost-effective for all users.",
                style: GoogleFonts.poppins(
                   fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
        
              // Feature Highlight
              Text(
                'Key Features:',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '• Direct communication between renters and owners\n'
                '• No broker fees\n'
                '• Transparent property listings\n'
                '• Easy search and filter options for properties\n'
                '• Safe and secure communication\n',
                style: GoogleFonts.poppins(
                   fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
        
              // Contact Info section
              Text(
                'Contact Us',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'For inquiries, please contact us at: support@directrent.com',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
        
              // A call to action button (optional)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // You can navigate to other screens here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Button color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
