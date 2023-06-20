class VolumeInfo {
  String title;
  List<dynamic> authors;
  String description;
  List<dynamic>? categories;
  String imageLinks;

  VolumeInfo(
      {required this.title,
      required this.authors,
      required this.description,
      this.categories,
      required this.imageLinks,
      }
  );


  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    VolumeInfo volume = VolumeInfo(
      title:  json['title'] ?? '',
      authors: json['authors'] ?? '',
      description: json['description'] ?? '',
      categories: json.isNotEmpty ? json['categories'] : null,
      imageLinks: json['imageLinks']['small'] ?? json['imageLinks']['thumbnail'],
    );
    return volume;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'authors': authors,
      'description': description,
      'categories': categories,
      'imageLinks': imageLinks,
    };


  }
}
