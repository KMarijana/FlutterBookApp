import 'dart:convert';

List<Quote> quoteFromJson(String str) =>
    List<Quote>.from(json.decode(str).map((x) => Quote.fromJson(x)));

class Quote {
  String text;
  String author;

  Quote({required this.text, required this.author});



  factory Quote.fromJson(Map<String, dynamic> json) {
    Quote quote =
        Quote(
            text: json['text'],
            author: json['author']
        );

    return quote;
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author
    };
  }
}
