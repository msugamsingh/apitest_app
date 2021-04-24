import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_error.dart';
import 'api_response.dart';

class NetworkHelper {
  String baseURL = 'https://newsapi.org/v2/';
  String key = '6f79e2843f2c44a0951413c60c0d4f4d';

  Future<ApiResponse> fetchData(String url) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      http.Response response = await http.get(Uri.parse(url));
      switch (response.statusCode) {
        case 200:
          apiResponse.data = response.body;
          break;

        case 402:
          apiResponse.apiError = ApiError.fromJson(jsonDecode(response.body));
          break;

        default:
          apiResponse.apiError = ApiError.fromJson(jsonDecode(response.body));
          break;
      }
    } on SocketException catch (e) {
      apiResponse.apiError = ApiError('Connection Error: Check your network!');
    } catch (e) {
      apiResponse.apiError = ApiError('Something went wrong: ${e.toString()}');
    }
    return apiResponse;
  }

  Future<ApiResponse> getNewsHeadlines(String country) async {
    var url = '${baseURL}top-headlines?country=$country&apiKey=$key';
    return fetchData(url);
  }

  Future<ApiResponse> getNewsHeadlinesWithCategory(
      String country, String category) async {
    var url =
        '${baseURL}top-headlines?country=$country&category=${category.toLowerCase()}&apiKey=$key';
    return fetchData(url);
  }

  Future<ApiResponse> searchNews(String q) {
    var url = '${baseURL}everything?q=$q&apiKey=$key';
    return fetchData(url);
  }

  Future<ApiResponse> getNewsFromSources(List l) {
    var q = l.join(',');
    var url = '${baseURL}everything?sources=$q&apiKey=$key';
    return fetchData(url);
  }
}
