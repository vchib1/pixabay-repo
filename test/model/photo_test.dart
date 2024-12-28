import 'package:flutter_test/flutter_test.dart';
import 'package:pixabay/model/photo.dart';

void main() {
  test('Should return properties from Photo', () {
    const photo = Photo(
        id: 1, largeImageURL: 'url', webFormatUrl: 'url', views: 1, likes: 1);

    expect(photo.id, 1);
    expect(photo.largeImageURL, 'url');
    expect(photo.webFormatUrl, 'url');
  });

  test('Should return map from Photo', () {
    const photo = Photo(
        id: 1, largeImageURL: 'url', webFormatUrl: 'url', views: 1, likes: 1);

    expect(photo.toMap(), {
      'id': 1,
      'likes': 1,
      'largeImageURL': 'url',
      'views': 1,
      'webformatURL': 'url',
    });
  });

  test('Should return Photo fromMap', () {
    const photo = Photo(
        id: 1, largeImageURL: 'url', webFormatUrl: 'url', views: 1, likes: 1);

    expect(
      Photo.fromMap({
        'id': 1,
        'likes': 1,
        'largeImageURL': 'url',
        'views': 1,
        'webformatURL': 'url',
      }),
      photo,
    );
  });
}
