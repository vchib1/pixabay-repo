final data = {
  "id": 3082832,
  "pageURL": "https://pixabay.com/photos/nature-waters-lake-island-3082832/",
  "type": "photo",
  "tags": "nature, mac wallpaper, waters",
  "previewURL":
      "https://cdn.pixabay.com/photo/2018/01/14/23/12/nature-3082832_150.jpg",
  "previewWidth": 150,
  "previewHeight": 84,
  "webformatURL":
      "https://pixabay.com/get/g02fd22d1aa4ec2a486157fc114c59b421547dd6612e2e275522684ad574327c1433182ecce32307247fe4491a1b8c12284ad824fedb54c8cf8f5b0b75f8974ae_640.jpg",
  "webformatWidth": 640,
  "webformatHeight": 359,
  "largeImageURL":
      "https://pixabay.com/get/g4a19f5b319f93266a73a073fac963a8b08ebdc735964bf89710c2fa81efdb0ce6796c5485819a681448c894738875624f3b2d9b77a2ea7da8ddc06dc7b860096_1280.jpg",
  "imageWidth": 5757,
  "imageHeight": 3238,
  "imageSize": 4638828,
  "views": 6993334,
  "downloads": 4276689,
  "collections": 185980,
  "likes": 5125,
  "comments": 746,
  "user_id": 7645255,
  "user": "jplenio",
  "userImageURL":
      "https://cdn.pixabay.com/user/2024/06/10/13-43-32-848_250x250.jpg"
};

class Photo {
  final int id;
  final String webformatURL;
  final String largeImageURL;
  final int views;
  final int likes;

  const Photo({
    required this.id,
    required this.webformatURL,
    required this.largeImageURL,
    required this.views,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'webformatURL': webformatURL,
      'largeImageURL': largeImageURL,
      'views': views,
      'likes': likes,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] as int,
      webformatURL: map['webformatURL'] as String,
      largeImageURL: map['largeImageURL'] as String,
      views: map['views'] as int,
      likes: map['likes'] as int,
    );
  }
}
