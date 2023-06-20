import 'package:bookapp/Screens/quotes_screen.dart';
import 'package:bookapp/Screens/user_account.dart';
import 'package:bookapp/Widgets/book_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class BookList extends StatefulWidget {
  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  int selectedIndex = 2;
  var user = FirebaseAuth.instance.currentUser!.email;
  int count = 0;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          initialSelection: 2,
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
        body: SafeArea(
            child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
            width: MediaQuery.of(context).size.width * 0.60,
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                "Saved books",
                style: TextStyle(
                    fontSize: 10.0,
                    fontFamily: "Merienda",
                    color: Color.fromRGBO(26, 31, 88, 1)),
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
              // preuzimanje podataka iz baze podatka, za prijavljenog korisnika
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('books')
                      .where("user", isEqualTo: user)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: .5,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            if (user.toString() ==
                                streamSnapshot.data!.docs[index]['user']) {
                              return Container(
                                  alignment: Alignment.center,
                                  child: BookCard(
                                    title: streamSnapshot.data!.docs[index]
                                        ['title'],
                                    imgSrc: streamSnapshot.data!.docs[index]
                                        ['image'],
                                    bookId: streamSnapshot.data!.docs[index]
                                        ['id'],
                                    press: () {},
                                  ));
                            }

                            return SizedBox();
                          });
                    }
                  }))
        ])));
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
}
