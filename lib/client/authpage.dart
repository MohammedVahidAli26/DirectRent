import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizapp/client/clientLogin.dart';
import 'package:quizapp/client/userhomepage.dart';


class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(),
       builder: (context, snapshot) {
        if (snapshot.hasData){
          return UserViewPage();
        }
        else {
          return Sampleloginui();
        }
       }),
    );
  }
}
