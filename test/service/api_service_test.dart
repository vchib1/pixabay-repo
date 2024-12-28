import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pixabay/service/api_service.dart';
import '../mock_data.dart';
import 'api_service_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late ApiService apiService;
  late MockClient client;

  setUp(() {
    client = MockClient();
    apiService = ApiService(client: client);
  });

  test('getImages should return mock data for page 1', () async {
    when(client.get(any)).thenAnswer((_) async {
      return Response(jsonEncode(mockDataPage1), 200);
    });

    final List<dynamic> responsePage1 = await apiService.getImages(pageNum: 1);

    expect(responsePage1, isNotNull);
    expect(responsePage1, isA<List<dynamic>>());
  });

  test('getImages should return mock data for page 2', () async {
    when(client.get(any)).thenAnswer((_) async {
      return Response(jsonEncode(mockDataPage2), 200);
    });

    final List<dynamic> responsePage2 = await apiService.getImages(pageNum: 2);

    expect(responsePage2, isNotNull);
    expect(responsePage2, isA<List<dynamic>>());
  });

  test("getImages should throw an exception", () async {
    when(client.get(any)).thenThrow(Exception());

    expect(
      () async => await apiService.getImages(pageNum: 1),
      throwsA(predicate(
          (e) => e.toString().contains('An unexpected error occurred'))),
    );
  });
}
