class ImageLinks {
  String thumbnail;
  String small;
  String? medium;
  String? large;

  ImageLinks({required this.thumbnail, required this.small, this.medium, this.large});

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    ImageLinks image = ImageLinks(
      thumbnail: json['thumbnail'] ?? '',
      small:  json.isNotEmpty ? json['small'] : null,
      medium: json['medium'] ?? '',
      large: json['large'] ?? '',
    );
    return image;
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'small': small,
      'medium': medium,
      'large': large,
    };
  }
}