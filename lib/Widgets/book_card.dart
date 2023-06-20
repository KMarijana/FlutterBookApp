import 'package:bookapp/Screens/book_info.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String imgSrc;
  final String title;
  final Function press;
  final String bookId;
  const BookCard({
    required this.imgSrc,
    required this.title,
    required this.press,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    // rounded rectangle
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: Colors.blueAccent,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          // recArea sa linkom
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BookInfo(bookId);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Image.network(imgSrc),
                  Spacer(),
                  Text(title,
                      style: TextStyle(fontSize: 15.0),
                      textAlign: TextAlign.center),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
