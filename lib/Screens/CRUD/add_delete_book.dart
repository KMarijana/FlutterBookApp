import 'dart:async';

import 'package:bookapp/Model/book_model.dart';
import 'package:bookapp/Provider/book_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

int count = 1;
var book;

class DeleteBook extends StatefulWidget {
  final String id;
  DeleteBook(this.id);

  @override
  State<DeleteBook> createState() => _DeleteBookState(this.id);
}

class _DeleteBookState extends State<DeleteBook>
    with AutomaticKeepAliveClientMixin {
  String id;
  _DeleteBookState(this.id);
  BookProvider bookProvider = BookProvider();

  var firebaseUser = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final snapShot = FirebaseFirestore.instance.collection('books').doc().get();

  var bookID, bookTitle, bookAuthors, bookDescription, bookImage, bookCategory;
  String text = "Add to library";
  String? img;

  @override
  void initState() {
    super.initState();
    setButtonText();
  }

  void setButtonText() {
    if (count > 0) {
      setState(() {
        text = "Remove from the library";
      });
    } else {
      setState(() {
        count = 0;
        text = "Add to library";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<Book>? futureBook = bookProvider.fetchBook(id);
    var key = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(25.0),
        height: 49,
        color: Colors.transparent,
        child: RaisedButton(
            padding: EdgeInsets.only(
                left: 50.0, right: 50.0, top: 15.0, bottom: 15.0),
            child: Text(text, style: TextStyle(color: Colors.white)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.blueAccent,
            onPressed: count != 0
                ? () {
                    // delete book
                    count = 0;
                    setButtonText();
                    FirebaseFirestore.instance
                        .collection("books")
                        .where("title", isEqualTo: bookTitle)
                        .get()
                        .then((value) {
                      value.docs.forEach((element) {
                        FirebaseFirestore.instance
                            .collection("books")
                            .doc(element.id)
                            .delete()
                            .then((value) {
                          print("Success!");
                        });
                      });
                    });
                  }
                : () async {
                    // add book
                    count++;
                    setButtonText();
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
                    }).catchError((e) {
                      print(e);
                    });
                  }),
      ),
      body: SafeArea(
          child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: const BackButton(color: Colors.blueAccent),
            backgroundColor: Colors.grey.withOpacity(0.2),
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            flexibleSpace: SizedBox(
              // color: Colors.blueAccent,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 25,
                    top: 35,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/homeScreen");
                      },
                    ),
                  ),
                  // prikaz slike knjige
                  Align(
                    alignment: Alignment.center,
                    child: FutureBuilder<Book>(
                      future: futureBook,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          bookImage = snapshot.data!.volumeInfo.imageLinks;
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
          // detalji knjige

          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 25),
              child: FutureBuilder<Book>(
                future: futureBook,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bookID = snapshot.data!.id;
                    book = bookID;
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
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 25, bottom: 20),
              child: FutureBuilder<Book>(
                future: futureBook,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bookAuthors = snapshot.data!.volumeInfo.authors.toString();
                    return Text(
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
            Divider(
              color: Colors.blueAccent,
              height: 20,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
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
                    return Text(
                        /*  desc.length > 1000
                            ? desc.substring(0, 1000) + '...'
                            : desc,*/
                        desc,
                        style: const TextStyle(fontSize: 16.0));
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
