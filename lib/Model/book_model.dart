import 'dart:convert';

import 'package:bookapp/Model/volume_info.dart';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

class Book {
  String id;
  VolumeInfo volumeInfo;

  Book(
      {required this.id,
        required this.volumeInfo,
      });

  factory Book.fromJson(Map<String, dynamic> json) {
    Book book = Book(
      id: json['id'] ?? '',
      volumeInfo: VolumeInfo.fromJson(json['volumeInfo']),

    );
    return book;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volumeInfo': volumeInfo,
    };
  }
}
