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
      'likes': likes,
      'largeImageURL': largeImageURL,
      'views': views,
      'webformatURL': webFormatUrl,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photo &&
          id == other.id &&
          webFormatUrl == other.webFormatUrl &&
          largeImageURL == other.largeImageURL &&
          views == other.views &&
          likes == other.likes;

  @override
  int get hashCode =>
      Object.hash(id, webFormatUrl, largeImageURL, views, likes);
}
