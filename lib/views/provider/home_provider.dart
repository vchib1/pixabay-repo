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
  final List<Photo> _photos = [];

  List<Photo> get photos => _photos;

  // Page number for pagination
  int _pageNum = 1;

  // For pagination
  bool _isFetchingMore = false;

  bool get isFetchingMore => _isFetchingMore;

  // For initial loading
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _initialLoading(bool value) {
    if (_pageNum == 1) {
      _isLoading = value;
      notifyListeners();
    }
  }

  Future<void> getImages() async {
    _initialLoading(true);

    // return if the photos are already being fetched
    if (_isFetchingMore) return;

    try {
      // fetching more starts only after page 1
      if (_pageNum > 1) {
        _isFetchingMore = true;
        notifyListeners();
      }

      // Get the Raw data from the API
      final List rawDataList = await _api.getImages(pageNum: _pageNum);

      // Mapping Raw data to Photo model
      final List<Photo> newPhotos =
          rawDataList.map((x) => Photo.fromMap(x)).toList();

      // Updating state with new photos
      _photos.addAll(newPhotos);
      notifyListeners();

      _initialLoading(false);

      // Increment page number
      _pageNum++;
    } catch (e) {
      error = e.toString();
      _initialLoading(false);
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}
