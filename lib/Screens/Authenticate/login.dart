import 'package:bookapp/Provider/auth_provider.dart';
import 'package:bookapp/Screens/Authenticate/create_account.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == false
          ? SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0),
                        constraints: BoxConstraints.expand(height: 200.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/login.png"),
                                fit: BoxFit.contain)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "Login to your account",
                            style: TextStyle(
                                fontSize: 10.0,
                                fontFamily: "Merienda",
                                color: Color.fromRGBO(26, 31, 88, 1)),
                          ),
                        ),
                      ),
                      inputEmail(),
                      inputPassword(),
                      loginButton(),
                      linkToScreen(),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget inputEmail() {
    return Container(
        width: 320,
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            if (!_emailRegex.hasMatch(value)) {
              return 'Not a valid email';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          controller: _email,
          decoration: const InputDecoration(
            hintText: 'Enter Email',
            prefixIcon: Icon(Icons.email),
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

  Widget inputPassword() {
    return Container(
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
            hintText: 'Enter Password',
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

  Widget loginButton() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding:
            EdgeInsets.only(left: 90.0, right: 90.0, top: 15.0, bottom: 15.0),
        child: Text(
          "Login",
          style: TextStyle(fontSize: 15),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print("Email: ${_email.text}");
            print("Password: ${_password.text}");
            setState(() {
              isLoading = true;
            });
            // poziv metode za login i prosledjivanje vrednosti
            AuthProvider()
                .login(
                    email: _email.text.trim(), password: _password.text.trim())
                .then((value) {
              if (value == "Welcome") {
                setState(() {
                  isLoading = false;
                });
                // preusmeravanje na home ekran
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false);
              } else {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(value!)));
              }
            });
          }
        },
        color: Colors.blueAccent,
        textColor: Colors.white,
      ),
    );
  }

  Widget linkToScreen() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: TextButton(
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
        child: Text(
          "Don't have an account? Register here.",
          style: TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(26, 31, 88, 1)),
        ),
      ),
    );
  }
}
