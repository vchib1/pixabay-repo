import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';

String handleNetworkException(Object error) {
  if (error is SocketException) {
    return "No internet connection. Please check your network and try again.";
  } else if (error is HttpException) {
    return "Failed to connect to the server.";
  } else if (error is FormatException) {
    return "Bad response format from the server.";
  } else if (error is TimeoutException) {
    return "The connection timed out. Please try again later.";
  } else if (error is String) {
    return error;
  } else {
    return "An unexpected error occurred. Please try again.";
  }
}

String handleNetworkError(Response response) {
  switch (response.statusCode) {
    case 200:
      return "Success";
    case 400:
      return "Bad request. Please check your input.";
    case 401:
      return "Unauthorized. Please check your credentials.";
    case 403:
      return "Forbidden. You don't have permission to access this resource.";
    case 404:
      return "Resource not found. Please try again.";
    case 500:
      return "Internal server error. Please try again later.";
    case 503:
      return "Service unavailable. Please try again later.";
    default:
      return "Unknown error occurred. Status code: ${response.statusCode}";
  }
}
