class Character {
  final String name;
  final String imageUrl;
  final String crew;

  Character({required this.name, required this.imageUrl, required this.crew});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      imageUrl: json['image_url'],
      crew: json['crew'],
    );
  }
}
