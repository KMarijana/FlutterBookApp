import 'dart:async';

import 'package:bookapp/Model/book_model.dart';
import 'package:bookapp/Provider/book_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class BookInfo extends StatefulWidget {
  final String id;
  BookInfo(this.id, {Key? key}) : super(key: key);
  @override
  State<BookInfo> createState() => _BookInfoState(this.id);
}

class _BookInfoState extends State<BookInfo> {
  String id;
  _BookInfoState(this.id);
  BookProvider bookProvider = BookProvider();

  var count;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final snapShot = FirebaseFirestore.instance.collection('books').doc().get();

  var bookID,
      bookTitle,
      bookAuthors,
      bookDescription,
      bookImage,
      bookCategory,
      added;
  String text = "Save";
  String? img;

  @override
  void initState() {
    super.initState();
    bookNumber();
  }

  // metoda koja menja tekst u dugmetu u zavisnosti da li knjiga postoji u bazi
  void setButtonText() {
    if (count > 0) {
      setState(() {
        text = "Remove";
      });
    } else {
      setState(() {
        text = "Save";
      });
    }
  }

  // metoda koja vraća broj knjiga u bazi podataka za prijavljenog korisnika
  void bookNumber() {
    FirebaseFirestore.instance
        .collection("books")
        .where("user", isEqualTo: firebaseUser!.email)
        .where("id", isEqualTo: id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        count = querySnapshot.docs.length;
        setButtonText();
      });
      print(querySnapshot.docs.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<Book>? futureBook = bookProvider.fetchBook(id);
    var key = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: key,
        body: SafeArea(
            child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: const BackButton(color: Colors.blueAccent),
              backgroundColor: Colors.grey.withOpacity(0.2),
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              flexibleSpace: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Stack(
                  children: <Widget>[
                    // prikaz slike
                    Align(
                      alignment: Alignment.center,
                      child: FutureBuilder<Book>(
                        future: futureBook,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            bookImage = snapshot.data!.volumeInfo.imageLinks;
                            // slika se preuzima sa interneta
                            return Image.network(
                              snapshot.data!.volumeInfo.imageLinks,
                              fit: BoxFit.fill,
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            // omogucava scroll liste objekata
            SliverList(
                delegate: SliverChildListDelegate([
              // naslov
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 25, right: 25),
                child: FutureBuilder<Book>(
                  future: futureBook,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bookID = snapshot.data!.id;
                      bookCategory =
                          snapshot.data!.volumeInfo.categories.toString();
                      bookTitle = snapshot.data!.volumeInfo.title;
                      return Text(snapshot.data!.volumeInfo.title,
                          style: const TextStyle(
                              fontSize: 22.0, fontFamily: "Merienda"));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Text('');
                  },
                ),
              ),
              // autori
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 25, bottom: 20),
                child: FutureBuilder<Book>(
                  future: futureBook,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bookAuthors =
                          snapshot.data!.volumeInfo.authors.toString();
                      return Text(
                          '~ ' +
                              snapshot.data!.volumeInfo.authors
                                  .toString()
                                  .replaceAll('[', '')
                                  .replaceAll(']', ''),
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black54));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Text('');
                  },
                ),
              ),
              // razmak - linija
              Divider(
                color: Colors.blueAccent,
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              // opis
              Padding(
                padding: const EdgeInsets.all(20),
                child: FutureBuilder<Book>(
                  future: futureBook,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bookDescription = snapshot.data!.volumeInfo.description;
                      String desc = snapshot.data!.volumeInfo.description
                          .toString()
                          .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
                      return Text(desc, style: const TextStyle(fontSize: 16.0));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Text('');
                  },
                ),
              ),
            ]))
          ],
        )),
        //dugme
        bottomNavigationBar: Row(children: [
          Container(
              margin: EdgeInsets.only(top: 20.0, right: 0, left: 25, bottom: 25),
              height: 50,
              color: Colors.transparent,
              child: ElevatedButton.icon(
                  /*child: Text(text, style: TextStyle(color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.blueAccent,*/
                  icon: Icon(
                    Icons.star,
                    size: 30.0,
                  ),
                  style: ElevatedButton.styleFrom(fixedSize: const Size(140, 90),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    primary: Colors.blueAccent),
                  label: Text(text),
                  onPressed: count != 0
                      ? () async {
                          // brisanje knjige
                          count = 0;
                          await FirebaseFirestore.instance
                              .collection("books")
                              .where("user", isEqualTo: firebaseUser!.email)
                              .where("id", isEqualTo: bookID)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              FirebaseFirestore.instance
                                  .collection("books")
                                  .doc(element.id)
                                  .delete()
                                  .then((value) {
                                print("Success!");
                                setButtonText();
                              });
                            });
                          });
                        }
                      : () async {
                          // dodavanje knjige
                          count++;
                          await firestoreInstance.collection("books").add({
                            "user": firebaseUser!.email,
                            "id": bookID,
                            "title": bookTitle,
                            "authors": bookAuthors,
                            "image": bookImage,
                            "description": bookDescription,
                            "category": bookCategory,
                          }).then((documentReference) {
                            print("success " + documentReference.id);
                            setButtonText();
                          }).catchError((e) {
                            print(e);
                          });
                        })),
          Container(
            margin: EdgeInsets.only(top: 20.0, right: 0, left: 30, bottom: 25),
            height: 50,
            color: Colors.transparent,
            child: FutureBuilder<Book>(
              future: futureBook,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ElevatedButton.icon(
                      icon: Icon(
                        Icons.share,
                        size: 30,
                      ),
                      style: ElevatedButton.styleFrom(fixedSize: const Size(140, 90),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        primary: Colors.blueAccent
                      ),
                      label: Text('Share'),
                      onPressed: () async {
                        await FlutterShare.share(
                            title: 'Book: ' + snapshot.data!.volumeInfo.title,
                            text: 'Author: ' +
                                snapshot.data!.volumeInfo.authors
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                            chooserTitle: 'Find a book');
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Text('');
              },
            ),
          ),
        ]));
  }
}
