import 'package:bookapp/Screens/CRUD/read_book.dart';
import 'package:bookapp/Screens/home.dart';
import 'package:bookapp/Screens/user_account.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import '../Provider/quote_provider.dart';
import 'dart:async';

class Quotes extends StatefulWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  GlobalKey bottomNavigationKey = GlobalKey();
  int selectedIndex = 1;
  QuoteProvider quoteProvider = QuoteProvider();
  Future<List<dynamic>>? futureQuote;

  @override
  void initState() {
    super.initState();
    futureQuote = quoteProvider.fetchQuotes();
  }

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
            TabData(iconData: Icons.account_circle, title: "Account")
          ],
          initialSelection: 1,
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
            margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Container(
              constraints: BoxConstraints.expand(height: 200.0),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/quotesdesign.png"),
                      fit: BoxFit.fill)),
            ),
          ),
          showQuotes(),
        ])));
  }

  Widget showQuotes() {
    return Expanded(
        child: FutureBuilder(
            future: futureQuote,
            builder: (BuildContext ctx,
                    AsyncSnapshot<List<dynamic>> snapshot) =>
                snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                            margin: const EdgeInsets.only(
                                left: 20, top: 00, right: 20, bottom: 10),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.blueAccent.shade400,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(
                                  left: 0, top: 30, right: 10, bottom: 30),
                              title: Text(
                                  '"' + snapshot.data![index]['text'] + '"',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  )),
                              subtitle: snapshot.data![index]['author'] == null
                                  ? Text('\n ~ Anonymous',
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: "Merienda"))
                                  : Text(
                                      '\n ~ ' + snapshot.data![index]['author'],
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: "Merienda")),
                              leading: FlatButton(
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.blueAccent,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    await FlutterShare.share(
                                        title: '"' +
                                            snapshot.data![index]['text'] +
                                            '"',
                                        text: snapshot.data![index]['author'] ==
                                                null
                                            ? '~ Anonymous'
                                            : '~ ' +
                                                snapshot.data![index]['author'],
                                        chooserTitle: 'Find books app');
                                  }),
                            ),
                          );
                        })
                    : Center(
                        child: CircularProgressIndicator(),
                      )));
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
