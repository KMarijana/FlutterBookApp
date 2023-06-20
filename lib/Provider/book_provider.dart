import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bookapp/Model/book_model.dart';

class BookProvider {
  BookProvider();

  // sve knjige
  Future<List<dynamic>> fetchBooks() async {
    // ceka se odgovor sa google api-a
      var response = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:fiction&maxResults=30'));

      // ako je statusni kod 200, prebacivanje JSON fajl u knjigu, i vraca listu knjiga
      if (response.statusCode == 200) {
        final parsed =
            json.decode(response.body)['items'].cast<Map<String, dynamic>>();
        return parsed.map<Book>((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load book');
      }
  }

  // knjige prema određenim kateogrijama
  Future<List<dynamic>> fetchFictionBooks() async {
    final response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:fantasy&maxResults=20'));

    if (response.statusCode == 200) {
      final parsed =
          jsonDecode(response.body)['items']?.cast<Map<String, dynamic>>();
      return parsed.map<dynamic>((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load book');
    }
  }

  Future<List<dynamic>> fetchComputersBooks() async {
    final response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:computers'));

    if (response.statusCode == 200) {
      final parsed =
      jsonDecode(response.body)['items']?.cast<Map<String, dynamic>>();
      return parsed.map<dynamic>((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load book');
    }
  }

  Future<List<dynamic>> fetchScienceBooks() async {
    final response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:science'));

    if (response.statusCode == 200) {
      final parsed =
      jsonDecode(response.body)['items']?.cast<Map<String, dynamic>>();
      return parsed.map<dynamic>((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load book');
    }
  }

  Future<List<dynamic>> fetchEducationBooks() async {
    final response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:education'));

    if (response.statusCode == 200) {
      final parsed =
      jsonDecode(response.body)['items']?.cast<Map<String, dynamic>>();
      return parsed.map<dynamic>((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load book');
    }
  }

  Future<List<dynamic>> fetchLoveBooks() async {
    final response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=subject:love'));

    if (response.statusCode == 200) {
      final parsed =
      jsonDecode(response.body)['items']?.cast<Map<String, dynamic>>();
      return parsed.map<dynamic>((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load book');
    }
  }

  // prikaz knjige prema nazivu
  Future<List<Book>> getSpecificBook(String title) async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=${title.trim()}'));

    if (response.statusCode == 200) {
      final parsed =
          jsonDecode(response.body)['items']?.cast<Map<String, dynamic>>();
      return parsed.map<Book>((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load book');
    }
  }

  // prikaz knjige na koju je korisnik kliknuo, prosledjuje se id
  Future<Book> fetchBook(String id) async {
    final response = await http
        .get(Uri.parse('https://www.googleapis.com/books/v1/volumes/$id'));

    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load book');
    }
  }
}
