import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:pixabay/utils/network_exception.dart';

class ApiService {
  final Client _client;

  ApiService({required Client client}) : _client = client;

  final int _perPage = 10;
  final String _apiKey = "46281416-d2372bac269ed1cefd4c8eb36";
  final String _baseUrl = "https://pixabay.com/api/";

  Future<List<dynamic>> getImages({required int pageNum}) async {
    try {
      String uri = "$_baseUrl?key=$_apiKey&per_page=$_perPage&page=$pageNum";
      Response response = await _client.get(Uri.parse(uri));

      if (response.statusCode == HttpStatus.ok) {
        final Map decodedResponse = jsonDecode(response.body);
        final List images = decodedResponse["hits"];
        return images;
      } else {
        throw Exception(handleNetworkError(response));
      }
    } catch (e) {
      throw handleNetworkException(e);
    }
  }
}
