import 'package:bookapp/Provider/auth_provider.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<CreateAccount> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading == false
            ? SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // naslovna slika
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 0.0),
                          constraints: BoxConstraints.expand(height: 200.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/register.png"),
                                  fit: BoxFit.contain)),
                        ),
                        // naslov
                        Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 20.0),
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: const FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "Create your account",
                              style: TextStyle(
                                  fontSize: 10.0,
                                  fontFamily: "Merienda",
                                  color: Color.fromRGBO(26, 31, 88, 1)),
                            ),
                          ),
                        ),
                        // polje za unos
                        inputUsername(),
                        inputEmail(),
                        inputPassword(),
                        registerButton(),
                        linkToScreen(),
                      ],
                    ),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }

  Widget inputUsername() {
    return Container(
        width: 320,
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          autocorrect: true,
          controller: _userName,
          decoration: const InputDecoration(
            hintText: 'Enter User Name',
            prefixIcon: Icon(Icons.account_circle),
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white70,
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(
                  color: Colors.blueAccent, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                  color: Colors.blueAccent, width: 2),
            ),
          ),
        ));
  }

  Widget inputEmail() {
    return Container(
        width: 320,
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          controller: _email,
          validator: (value) {
            //provera da li je uneta vrednost
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            // provera da li je email odgovarajućeg oblika
            if (!_emailRegex.hasMatch(value)) {
              return 'Not a valid email';
            }
            return null;
          },
          autocorrect: true,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Enter Email',
            prefixIcon: Icon(Icons.email),
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white70,
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(
                  color: Colors.blueAccent, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                  color: Colors.blueAccent, width: 2),
            ),
          ),
        ));
  }

  Widget inputPassword() {
    return Container(
        width: 320,
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          controller: _password,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          },
          autocorrect: true,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Enter Password',
            prefixIcon: Icon(Icons.lock),
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white70,
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(
                  color: Colors.blueAccent, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                  color: Colors.blueAccent, width: 2),
            ),
          ),
        ));
  }

  Widget registerButton() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.only(
            left: 90.0,
            right: 90.0,
            top: 15.0,
            bottom: 15.0),
        child: const Text(
          "Register",
          style: TextStyle(fontSize: 15),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print("Email: ${_email.text}");
            print("Password: ${_password.text}");
            setState(() {
              isLoading = true;
            });
            //poziv klase za kreiranje naloga, prosledjivanje potrebnih parametara
            AuthProvider()
                .createAccount(
                userName: _userName.text.trim(),
                email: _email.text.trim(),
                password: _password.text.trim())
                .then((value) {
              if (value == "Account created") {
                setState(() {
                  isLoading = false;
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login()),
                        (route) => false);
              } else {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(value!)));
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
    return // link za preusmeravanje na drugi ekran
      Container(
        margin: EdgeInsets.only(top: 10.0),
        child: TextButton(
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
          child: Text(
            "Already have an account? Login here.",
            style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(26, 31, 88, 1)),
          ),
        ),
      );
  }
}
