import 'dart:async';

import 'package:bookapp/Screens/home.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'welcome.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () async{
      var connectivityResult =  await (Connectivity().checkConnectivity());
      // provera internet konekcije
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        // ako korisnik nije prijavljen, prikaz welcome ekrana
        if (auth.currentUser == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Welcome()),
                  (route) => false);
        } else {
          // Ako je korisnik ostao prijavljen na svom nalogu, prikaz home ekrana
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
        }
      } else {
        print("Not connected");
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No internet")));
        // nema konekcije sa internetom, prikaz poruke
      }
    });

    return Scaffold(
      body: Center(
        // prikaz logoa i teksta aplikacije
        child: SplashScreenView(
          duration: 7000,
          imageSize: 130,
          imageSrc: "assets/images/appLogo.png",
          text: "Find books",
          textType: TextType.ColorizeAnimationText,
          textStyle: TextStyle(
            fontSize: 40.0,
            fontFamily: 'Merienda'
          ),
          navigateRoute: Welcome(),
        ),

      ),
    );
  }
}
