import 'package:bookapp/Provider/auth_provider.dart';
import 'package:bookapp/Provider/google_auth_provider.dart';
import 'package:bookapp/Screens/CRUD/read_book.dart';
import 'package:bookapp/Screens/quotes_screen.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'welcome.dart';
import 'home.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  UserAccountState createState() => UserAccountState();
}

class UserAccountState extends State<UserAccount> {
  User? googleUser = FirebaseAuth.instance.currentUser;
  String? user = FirebaseAuth.instance.currentUser!.email;
  final String? _email = FirebaseAuth.instance.currentUser!.email;
  final TextEditingController _password = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  int selectedIndex = 3;
  GlobalKey bottomNavigationKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Container(
                    constraints: BoxConstraints.expand(height: 200.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/setting.png"),
                            fit: BoxFit.fill)),
                  ),
                ),
                inputEmail(),
                inputOldPassword(),
                inputNewPassword(),

                // dugme za ažuriranje lozinke
                Row(children: [
                  updateButton(),
                  logoutButton(),
                ]),
              ],
            ),
          ),
        ),
      ),
      //navigacija
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
            iconData: Icons.home,
            title: "Home",
          ),
          TabData(
            iconData: Icons.article_sharp,
            title: "Quotes",
          ),
          TabData(
            iconData: Icons.star,
            title: "Library",
          ),
          TabData(iconData: Icons.account_circle, title: "Account"),
        ],
        initialSelection: 3,
        circleColor: Colors.blueAccent,
        activeIconColor: Colors.white,
        inactiveIconColor: Colors.blueAccent,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          onItemTapped(position);
          setState(() {
            selectedIndex = position;
          });
        },
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      switch (selectedIndex) {
        case 0:
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          }
          break;
        case 1:
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Quotes();
            }));
          }
          break;
        case 2:
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BookList();
            }));
          }
          break;
        case 3:
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UserAccount();
            }));
          }
          break;
      }
    });
  }

  Widget inputEmail() {
    return // korisnikov email, ne može da se izmeni
        Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
            width: 320,
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              enabled: false,
              initialValue: _email,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ));
  }

  Widget inputOldPassword() {
    return // unos stare lozinke
        Container(
            width: 320,
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              obscureText: true,
              controller: _password,
              decoration: const InputDecoration(
                hintText: 'Enter Current Password',
                prefixIcon: Icon(Icons.lock),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
            ));
  }

  Widget inputNewPassword() {
    return // unos nove lozinke
        Container(
            width: 320,
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (value == _password.text) {
                  return 'Please enter different password!';
                }
                return null;
              },
              obscureText: true,
              controller: _newPassword,
              decoration: const InputDecoration(
                hintText: 'Enter New Password',
                prefixIcon: Icon(Icons.lock),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
            ));
  }

  // update lozinke
  Widget updateButton() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 20, bottom: 50),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding:
            EdgeInsets.only(left: 50.0, right: 50.0, top: 15.0, bottom: 15.0),
        child: Text(
          "Update",
          style: TextStyle(fontSize: 15),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_password.text == _newPassword.text) {
              final snackBar = SnackBar(content: const Text('Same password'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              AuthProvider().updatePassword(_newPassword.text, _email!);
              final snackBar =
                  SnackBar(content: const Text('Password updated'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              _password.text = '';
              _newPassword.text = '';
            }
          }
        },
        color: Colors.blueAccent,
        textColor: Colors.white,
      ),
    );
  }

  Widget logoutButton() {
    return // dugme za odjavu korisnika sa naloga
        Container(
      margin: EdgeInsets.only(top: 20.0, right: 20, left: 20, bottom: 50),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding:
            EdgeInsets.only(left: 50.0, right: 50.0, top: 15.0, bottom: 15.0),
        child: Text(
          "Logout",
          style: TextStyle(fontSize: 15),
        ),
        onPressed: () {
          // provera kako je krisnik prijavljen
          if (googleUser!.providerData[0].providerId == 'google.com') {
            GoogleAuth().signOut(context: context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
                (route) => false);
          } else {
            AuthProvider().signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
                (route) => false);
          }
        },
        color: Colors.white,
        textColor: Colors.blueAccent,
      ),
    );
  }
}
