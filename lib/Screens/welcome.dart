
import 'package:bookapp/Screens/Authenticate/create_account.dart';
import 'package:bookapp/Widgets/google_button.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import 'authenticate/login.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          //logo
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            constraints: BoxConstraints.expand(height: 270.0),
            width: MediaQuery.of(context).size.width *
                0.65, // total width of screen
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/home.png"),
                    fit: BoxFit.contain)),
          ),
          //naziv app
          Container(
            margin: EdgeInsets.only(top: 15.0),
            width: MediaQuery.of(context).size.width * 0.60,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                "Find books",
                style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: "Merienda",
                    color: Color.fromRGBO(26, 31, 88, 1)),
              ),
            ),
          ),
          // dgme za kreiranje naloga
          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 05.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: EdgeInsets.only(
                  left: 85.0, right: 85.0, top: 15.0, bottom: 15.0),
              child: Text(
                "Create Account",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateAccount();
                    },
                  ),
                );
              },
              color: Colors.blueAccent,
              textColor: Colors.white,
            ),
          ),
          // dugme za login
          Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: EdgeInsets.only(
                  left: 120.0, right: 120.0, top: 15.0, bottom: 15.0),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ),
                );
              },
              color: Colors.white,
              textColor: Colors.blueAccent,
            ),
          ),
          Text("or"),
          // dugme prijava pomocu google naloga
          GoogleSignInButton(),
        ],
      ),
    ));
  }

}
