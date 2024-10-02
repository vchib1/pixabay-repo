import 'package:flutter/foundation.dart';
import 'package:pixabay/model/photo.dart';
import 'package:pixabay/service/api_service.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService _api;

  HomeProvider({required ApiService api}) : _api = api {
    getImages();
  }

  // Error message
  String? error;

  // List of photos
  List<Photo> _photos = [];

  List<Photo> get photos => _photos;

  // Page number for pagination
  int _pageNum = 1;

  // For pagination
  bool _isFetchingMore = false;

  // For initial loading
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  void initialLoading(bool value) {
    if (_pageNum == 1) {
      _isLoading = value;
      notifyListeners();
    }
  }

  Future<void> getImages() async {
    initialLoading(true);

    // return if the photos are already being fetched
    if (_isFetchingMore) {
      debugPrint("Already fetching more");
      return;
    }

    try {
      // fetching more starts only after page 1
      if (_pageNum > 1) _isFetchingMore = true;

      // Get the Raw data from the API
      final List rawDataList = await _api.getImages(pageNum: _pageNum);

      // Mapping Raw data to Photo model
      final List<Photo> newPhotos =
          rawDataList.map((x) => Photo.fromMap(x)).toList();

      // Updating state with new photos
      _photos = [..._photos, ...newPhotos];
      notifyListeners();

      initialLoading(false);

      // Increment page number
      _pageNum++;
    } catch (e) {
      error = e.toString();
      initialLoading(false);
    } finally {
      _isFetchingMore = false;
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}
