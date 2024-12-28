import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pixabay/service/api_service.dart';
import 'package:pixabay/views/provider/home_provider.dart';
import '../../mock_data.dart';
import 'home_provider_test.mocks.dart';



@GenerateMocks([ApiService])
void main() {
  late HomeProvider homeProvider;
  late MockApiService apiService;

  setUp(() {
    apiService = MockApiService();
    homeProvider = HomeProvider(api: apiService);
  });

  test(
    "Initial State",
    () {
      expect(homeProvider.photos, []);
      expect(homeProvider.error, null);
      expect(homeProvider.isLoading, false);
      expect(homeProvider.isFetchingMore, false);
    },
  );

  test(
    "Get Images should return mock data for page 1",
    () async {
      when(apiService.getImages(pageNum: 1))
          .thenAnswer((_) async => mockDataPage1['hits'] as List<dynamic>);

      await homeProvider.getImages(); // Call for page 1
      expect(homeProvider.photos, isNotEmpty); // Expect data to be non-empty
      expect(homeProvider.error, null); // No errors should occur
    },
  );

  test(
    "Get Images should return mock data for page 2",
    () async {
      // Fetch page 1 first
      when(apiService.getImages(pageNum: 1))
          .thenAnswer((_) async => mockDataPage1['hits'] as List<dynamic>);
      await homeProvider.getImages();
      expect(homeProvider.photos, isNotEmpty);

      // Fetch page 2 and expect photos to be appended
      when(apiService.getImages(pageNum: 2))
          .thenAnswer((_) async => mockDataPage2['hits'] as List<dynamic>);
      await homeProvider.getImages();

      expect(homeProvider.photos.length,
          greaterThan((mockDataPage1['hits'] as List).length));
      expect(homeProvider.error, null);
    },
  );

  test(
    "Get Images should return error for page 3",
    () async {
      // Fetch pages 1 and 2 to ensure photos are present
      when(apiService.getImages(pageNum: 1))
          .thenAnswer((_) async => mockDataPage1['hits'] as List<dynamic>);
      when(apiService.getImages(pageNum: 2))
          .thenAnswer((_) async => mockDataPage2['hits'] as List<dynamic>);

      await homeProvider.getImages();
      await homeProvider.getImages();
      expect(homeProvider.photos,
          isNotEmpty); // Photos from page 1 and 2 should be present

      // Simulate an error for page 3
      when(apiService.getImages(pageNum: 3)).thenThrow(Exception());

      await homeProvider.getImages();

      // Photos should still be there, but error should not be null
      expect(homeProvider.photos, isNotEmpty);
      expect(homeProvider.error, isNotNull);
    },
  );
}
