import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'Screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Inicijalizacija FlutterFire
      future: _initialization,
      builder: (context, snapshot) {
        // Provera gresaka
        if (snapshot.hasError) {
          return Container();
        }

        // Konekcija gotova, prikaz aplikacije
        if (snapshot.connectionState == ConnectionState.done) {
          return Splash();
        }

        // U suprotnom korisnik ceka da se zavrsi inicijalizacija
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
