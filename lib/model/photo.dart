class Photo {
  final int id;
  final String webFormatUrl;
  final String largeImageURL;
  final int views;
  final int likes;

  const Photo({
    required this.id,
    required this.webFormatUrl,
    required this.largeImageURL,
    required this.views,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'webformatURL': webFormatUrl,
      'largeImageURL': largeImageURL,
      'views': views,
      'likes': likes,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] as int,
      webFormatUrl: map['webformatURL'] as String,
      largeImageURL: map['largeImageURL'] as String,
      views: map['views'] as int,
      likes: map['likes'] as int,
    );
  }
}
