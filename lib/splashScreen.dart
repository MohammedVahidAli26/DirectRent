import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'client/authpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  void navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5)); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Authpage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/sp.json', width: MediaQuery.of(context).size.width * 0.5,),
            Text(
              'DirectRent',
              style: GoogleFonts.kaushanScript(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.black, // Match brand color
            ),
          ],
        ),
      ),
    );
  }
}
