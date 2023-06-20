import 'package:bookapp/Provider/book_provider.dart';
import 'package:bookapp/Screens/CRUD/read_book.dart';
import 'package:bookapp/Screens/quotes_screen.dart';
import 'package:bookapp/Widgets/book_card.dart';
import 'package:bookapp/Screens/user_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser!.email;
  List<String> categories = [
    "All",
    "Fiction",
    "Education",
    "Computers",
    "Science",
    "Love"
  ];
  int selectedIndex = 0;
  int selectedIndexCategory = 0;
  String? valueText;
  Future<List<dynamic>>? futureBook;
  final TextEditingController searchFieldController = TextEditingController();
  BookProvider bookProvider = BookProvider();
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedIndexCategory = 0;
    selectedIndex = 0;
    futureBook = bookProvider.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // navigacija u aplikaciji
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
          initialSelection: 0,
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
          // prikaz logo-a
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            constraints: BoxConstraints.expand(height: 90.0),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain)),
          ),
          searchBar(),
          // lista kategorija
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => buildCategory(index),
            ),
          ),
          SizedBox(height: 30),
          // prikaz knjiga
          prikazKnjiga(),
        ])));
  }

  Widget prikazKnjiga() {
    return Expanded(
      child: FutureBuilder<List<dynamic>>(
        // provera da li je polje za search prazno, i u zavisnosti od toga se formira gridview sa knjigama
          future: searchFieldController.text.isEmpty
              ? futureBook
              : bookProvider.getSpecificBook(searchFieldController.text),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(      // grid layout sa fiksiranim vrednostima prozora
                    crossAxisCount: 2,
                    childAspectRatio: .5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return BookCard( // prikaz knjige
                    title: snapshot.data![index].volumeInfo.title,
                    imgSrc: snapshot.data![index].volumeInfo.imageLinks,
                    press: () {},
                    bookId: snapshot.data![index].id,
                    //    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  // metoda koja omogućava prolaženje sa ekrana na ekran u zavisnosti od indexa - navigacija
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

  Widget searchBar() {
    return // search input polje
      Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: TextField(
            controller: searchFieldController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white70,
              contentPadding: EdgeInsets.all(10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2),
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              // za prosledjenu vrednost poziva se metoda koja vraća knjige prema nazivu ako postoje
              setState(() {
                valueText = value;
                bookProvider
                    .getSpecificBook(searchFieldController.text.toString());
              });
            }),
      );
  }

// metoda koja detektuje koja kategorija knjiga je odabrana
  Widget buildCategory(int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  selectedIndexCategory = index;
                });

                switch (index) {
                  case 0:
                    futureBook = bookProvider.fetchBooks();
                    break;
                  case 1:
                    futureBook = bookProvider.fetchFictionBooks();
                    break;
                  case 2:
                    futureBook = bookProvider.fetchEducationBooks();
                    break;
                  case 3:
                    futureBook = bookProvider.fetchScienceBooks();
                    break;
                  case 4:
                    futureBook = bookProvider.fetchComputersBooks();
                    break;
                  case 5:
                    futureBook = bookProvider.fetchLoveBooks();
                    break;
                }
              },
              // kliknuta kategorija, promena velicine fonta i boje
              child: Text(categories[index],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: selectedIndexCategory == index ? 18 : 16,
                      color: selectedIndexCategory == index
                          ? Colors.blueAccent
                          : Colors.grey)),
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              height: 2,
              width: 30,
              color: selectedIndexCategory == index
                  ? Color.fromRGBO(67, 111, 186, 1.0)
                  : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
