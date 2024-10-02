import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:pixabay/utils/network_exception.dart';

class ApiService {
  final int _perPage = 10;
  final String _baseUrl = "https://pixabay.com/api/";
  final String _apiKey = "API_KEY";

  Future<List<dynamic>> getImages({required int pageNum}) async {
    try {
      String uri =
          "$_baseUrl?key=$_apiKey&per_page=$_perPage&page=$pageNum&orientation=horizontal";
      Response response = await get(Uri.parse(uri));

      if (response.statusCode == HttpStatus.ok) {
        final Map decodedResponse = jsonDecode(response.body);
        final List images = decodedResponse["hits"];
        return images;
      } else {
        throw handleNetworkError(response);
      }
    } catch (e) {
      throw handleNetworkException(e);
    }
  }
}
